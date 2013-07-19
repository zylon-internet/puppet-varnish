# Managed by Satellite

## BACKENDS
# Centre rail application backends: rails/mod_passenger/apache2
include "/etc/varnish/backend_centre_rails.vcl";
# Acacia rail application backends: rails/mod_passenger/apache2
include "/etc/varnish/backend_acacia.vcl";
# Content store rail application backends: rails/mod_passenger/apache2
include "/etc/varnish/backend_contentstore.vcl";
# ContentService: rails/mod_passenger/apache2
include "/etc/varnish/backend_contentservice.vcl";
# Productservice: rails/mod_passenger/apache2
include "/etc/varnish/backend_productservice.vcl";
# Corporate: perl/mason/apache1
include "/etc/varnish/backend_corporate.vcl";
# Centre rail application - stratfordcity backends: rails/mod_passenger/apache2
include "/etc/varnish/backend_stratfordcity.vcl";
# URL redirect: apache2
include "/etc/varnish/backend_redirects.vcl";


# Westfield.com.au V2 (Evolution)
# customer_console
include "/etc/varnish/backend_customer_console.vcl";
## centre_service
include "/etc/varnish/backend_centre_service.vcl";
# deal_service
include "/etc/varnish/backend_deal_service.vcl";
# event_service
include "/etc/varnish/backend_event_service.vcl";
# file_service
include "/etc/varnish/backend_file_service.vcl";
# image_service
include "/etc/varnish/backend_image_service.vcl";
# movie_service
include "/etc/varnish/backend_movie_service.vcl";
# product_service
include "/etc/varnish/backend_product_service.vcl";
# search_service
#include "/etc/varnish/backend_search_service.vcl";
# store_service
include "/etc/varnish/backend_store_service.vcl";
# stream_service
include "/etc/varnish/backend_stream_service.vcl";

# Called when a client request is received
sub vcl_recv {
        if (req.request != "GET" &&
                req.request != "HEAD" &&
                req.request != "PUT" &&
                req.request != "POST" &&
                req.request != "TRACE" &&
                req.request != "OPTIONS" &&
                req.request != "DELETE") {
                /* Non-RFC2616 or CONNECT which is weird. */
                return (pipe);
        }

        # clean out requests sent via curl's -X mode and LWP
        if (req.url ~ "^http://") {
                set req.url = regsub(req.url, "http://[^/]*", "");
        }
        # Remove Google tracking urls
        if(req.url ~ "(\?|&)(gclid|utm_[a-z]+)=") {
                set req.url = regsuball(req.url, "(gclid|utm_[a-z]+)=[-_A-z0-9]+&?", "");
                set req.url = regsub(req.url, "(\?|&)$", "");
}

        # Remove Yahoo tracking urls
        if(req.url ~ "(\?|&)((OV|YSM)(KEY|RAW|MTC|ADID|KWID|NDID|CAMPGID|ADGRPID))=") {
                set req.url = regsuball(req.url, "((OV|YSM)(KEY|RAW|MTC|ADID|KWID|NDID|CAMPGID|ADGRPID))=[-_A-z0-9]+&?", "");
                set req.url = regsub(req.url, "(\?|&)$", "");
}

        # Remove Rails time-stamp. This keeps coming back; pesky devs :(
        if(req.url ~ "\?[0-9]+$") {
                set req.url = regsub(req.url, "\?[0-9]+$", "");
        }

        # Moved as per varnish groups recommendations
        if (req.backend.healthy) {
                set req.grace = 1m;
        } else {
                set req.grace = 10h;
        }

        # Blocks some URL-based XSS attacks
        if (req.url ~ "(java|vb)?script:") {
                set req.url = regsub(req.url, "^/([a-zA-Z/\-_])+.*$", "/\1");
        }

        # Decommission internal address space for UAT
        if (req.http.Host ~ "(www(au|us|uk|nz)\.)uat\.dbg\.westfield\.com$") {
                error 777;
        }

        # FB 17348
        if (req.http.Host ~ "uat\.(dbg\.)?westfield\.com$" &&
                req.url ~ "^/_let_me_in_to_uat/F4ijieriGWRgsfSDFwreg$" ) {
                error 777;
        }

#       if (!(client.ip ~ westfield_internal ||
#           req.http.Cookie ~ "wfcau_uat=F4ijieriGWRgsfSDFwreg" ||
#           req.http.Host == "static.uat.westfield.com" )) {
#               error 752 "http://westfield.com.au/au/";
#       }


        # Backend selection
        include "/etc/varnish/select_backend.vcl";

        set req.http.X-Forwarded-For = client.ip;

        if (req.request != "GET" && req.request != "HEAD") {
                /* We only deal with GET and HEAD by default */
                return (pass);
        }

        if include "/etc/varnish/never_cache.vcl"; {
                return (pass);
        }

        # Allow purging from westfield clients
        if (req.backend.healthy) {
                if (req.http.Pragma ~ "no-cache" || req.http.Cache-Control ~ "no-cache") {
                        purge_url(req.url);
                }
        }

        include "/etc/varnish/remove_cookies.vcl";

        #       if (req.http.Authorization || req.http.Cookie) {
        if (req.http.Authorization ) {
                /* Not cacheable by default */
                return (pass);
        }

        # Normalise Accept-Encoding. See http://varnish-cache.org/wiki/FAQ/Compression
        if (req.http.Accept-Encoding) {
                if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
                        # No point in compressing these
                        remove req.http.Accept-Encoding;
                } elsif (req.http.Accept-Encoding ~ "gzip") {
                        set req.http.Accept-Encoding = "gzip";
                } elsif (req.http.Accept-Encoding ~ "deflate") {
                        set req.http.Accept-Encoding = "deflate";
                } else {
                        # unkown algorithm
                        remove req.http.Accept-Encoding;
                }
        }

        return (lookup);
} # end sub vcl_recv


sub vcl_miss {

        return (fetch);
}


# Called when the request has been sent to the backend and a response has been
# received from the backend.
sub vcl_fetch {
        # Remove/modify unwanted headers
        unset beresp.http.X-Powered-By;
        set beresp.http.Server = "Apache";

        # Temporary, waiting for application fix (FB 14453)
        if ((req.http.Host ~ "^(static|contentstore\.prod\.dbg)\.westfield\.com$") && (beresp.status == 200)) {
                unset beresp.http.Cache-Control;
        }

        # Sprint 35 bug; pending jira for fix/investigation
        if ((req.http.Host == "premium.uat.dbg.westfield.com") &&
            (beresp.status == 200) &&
            (req.http.X-Forwarded-Host ~ "^cdnsa[1-4]?(\.uat)?\.atwestfield\.com$") &&
            (beresp.http.Cache-Control ~ "private")) {
                set beresp.http.Cache-Control = regsub(beresp.http.Cache-Control, "private", "public");
        }

        if (beresp.http.Cache-Control) {

                if (beresp.http.Cache-Control ~ "(no-cache|private)") {
                        return (pass);
                }

                # Prefer HTTP 1.1 headers over 1.0
                if (beresp.http.Cache-Control ~ "max-age") {
                        if (beresp.http.Expires) { unset beresp.http.Expires; }
                        if (beresp.http.Pragma) { unset beresp.http.Pragma; }
                }

                # [2012-01-23 thiago] WSF-xxxx
                if (beresp.http.X-Runtime ~ "[0-9][0-9][0-9][0-9]+") {
                        set beresp.ttl = 1d;
                }

        # Default for all cacheable objects without a Cache-Control header
        } elseif (! (include "/etc/varnish/never_cache.vcl"; || include "/etc/varnish/filter_redirects.vcl";) ) {
                set beresp.http.Cache-Control = "public, max-age=86400";
        }

        # If status not one of the below try again (up to max_restarts)
        if (
        beresp.status != 200 && beresp.status != 201 && beresp.status != 204 &&
        beresp.status != 301 && beresp.status != 302 && beresp.status != 307 &&
        beresp.status != 403 && beresp.status != 404 && beresp.status != 422 &&
        beresp.status != 410) {
                if (req.http.X-Forwarded-Host) {
                         set req.http.Host = req.http.X-Forwarded-Host;
                }
                restart;
        }

        if (bereq.request == "POST" || bereq.request == "DELETE" ||
            bereq.request == "PUT") {
                set beresp.http.Cache-Control = "private, max-age=0";
                if (beresp.http.Expires) { unset beresp.http.Expires; }
        }


        if (!beresp.cacheable) {
                return (pass);
        }

        # Need to be max(req.grace): see vcl_miss()
        set beresp.grace = 20h;

        return (deliver);
}

# Called before a response object (from the cache or the web server) is sent
# to the requesting client.
sub vcl_deliver {
        if (obj.hits > 0) {
                set resp.http.X-Cache = "HIT";
                set resp.http.X-Cache-Hits = obj.hits;
        } else {
                set resp.http.X-Cache = "MISS";
        }
        if (resp.status == 307 && req.url ~ "^/img_resized"){
                set resp.http.Location = "http://static.westfield.com" req.url;
        }

        return (deliver);
}

sub vcl_error {
        if (obj.status == 751) {
                set obj.http.Location = obj.response;
                set obj.response = "Moved permanently";
                set obj.status = 301;
        }

        elseif (obj.status == 752) {
                set obj.http.Location = obj.response;
                set obj.response = "Moved temporarily";
                set obj.status = 302;
        }
        if (obj.status == 753) {
                set obj.http.Location = obj.response;
                set obj.response = "Access denied";
                set obj.status = 403;
        }
        elseif (obj.status == 777) {
                # FB 17348
                set obj.http.Location = "http://wwwau.uat.westfield.com/au/";
                set obj.response = "Moved temporarily";
                set obj.http.Set-Cookie = "wfcau_uat=F4ijieriGWRgsfSDFwreg; domain=.uat.westfield.com; path=/; expires=Fri, 17-Feb-2012 03:38:32 GMT";
                set obj.status = 302;
        } else {
                set obj.http.Content-Type = "text/html; charset=utf-8";
                synthetic {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Westfield - "} obj.status " " obj.response {"</title>
</head>

<body>

<div style="margin:100px auto 0 auto; width:580px; font-family:Arial, Helvetica, sans-serif; font-size:25px; line-height:1.4em; color:#555;" >

<div style="width:580px;" >
        <p align="center">Westfield.com is experiencing<br />technical difficulties</p>
        <p style="font-size:15px; line-height:1.4em;" align="center">We're working hard to identify the problem,<br />and hope to be up and running again soon.</p>
</div>

<div style="font-family:Arial, Helvetica, sans-serif; font-size:10px;color:white" <p><small>Technician's Note: </p><p>HTTP status code "} obj.status " " obj.response {"</p><p>Guru Meditation: XID: "} req.xid {"</p></div>

</body>
</html>
"};
                }

        return(deliver);
}
