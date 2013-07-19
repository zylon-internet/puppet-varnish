# House-keeping stuff
include "/etc/varnish/canonical_westfield_com_au.vcl";
include "/etc/varnish/canonical_westfield_com_nz.vcl";
include "/etc/varnish/canonical_westfield_com_uk.vcl";
include "/etc/varnish/canonical_westfield_com_us.vcl";

# Select the correct backend to process the request

# Westfield.com.au V2 Start

if include "/etc/varnish/filter_centre_service.vcl"; {
	set req.backend = centre_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "centre-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_deal_service.vcl"; {
	set req.backend = deal_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "deal-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_event_service.vcl"; {
	set req.backend = event_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "event-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_file_service.vcl"; {
	set req.backend = file_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "file-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_image_service.vcl"; {
	set req.backend = image_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "image-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_movie_service.vcl"; {
	set req.backend = movie_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "movie-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_product_service.vcl"; {
	set req.backend = product_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "product-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_store_service.vcl"; {
	set req.backend = store_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "store-service.systest.dbg.westfield.com";
}

#elseif include "/etc/varnish/filter_search_service.vcl"; {
#	set req.backend = search_service;
#	set req.http.X-Forwarded-Host = req.http.Host;
#	set req.http.Host = "search-service.systest.dbg.westfield.com";
#}

elseif include "/etc/varnish/filter_stream_service.vcl"; {
	set req.backend = stream_service;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "stream-service.systest.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_customer_console.vcl"; {
	set req.backend = customer_console;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "customer-console.systest.dbg.westfield.com";
}


# Westfield.com.au V2 End

if include "/etc/varnish/filter_redirects.vcl"; {
        set req.backend = redirects;
}

elseif (req.http.Host ~ "^(www\.|wwwus\.)?(uat\.)?westfield\.com$" && req.url ~ "^/corporate/") {
        set req.backend = corporate;
}

elseif include "/etc/varnish/filter_acacia.vcl"; {
        set req.backend = acacia;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "fas.prod.dbg.westfield.com";
}

elseif (req.url ~ "^/api/content(/|/?$)") {
        set req.backend = contentservice;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "contentservice.uat.dbg.westfield.com";
}

elseif (req.http.Host == "wwwau.uat.westfield.com" && req.url ~ "^/api/product/(v1|v2|latest)") {
        set req.backend = productservice;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "productservice.uat.dbg.westfield.com";
}

elseif (req.http.Host ~ "^static\.uat\.(dbg\.)?westfield\.com$") {
        if (req.url ~ "^/admin/" && req.url != "/admin/ping") {
                error 753;
        }
        set req.backend = contentstore;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "static.uat.dbg.westfield.com";
}

elseif (req.http.Host ~ "^cdn[1-4]\.uat\.atwestfield\.com$") {
        set req.backend = contentstore;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "static.uat.dbg.westfield.com";
}

elseif (req.http.Host ~ "^cdn[1-6]\.uat\.dbg\.westfield\.com$") {
        set req.backend = contentstore;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "static.uat.dbg.westfield.com";
}

elseif include "/etc/varnish/filter_centre_rails.vcl"; {
        set req.backend = centre_rails;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "premium.uat.dbg.westfield.com";
        # [2011-03-18 thiago] Testing premium with no server-side cookies
        remove req.http.Cookie;
}

elseif (req.url ~ "^/stratfordcityleasing(/|/?$)") {
        set req.backend = stratfordcity_rails;
        set req.http.X-Forwarded-Host = req.http.Host;
        set req.http.Host = "stratfordcity.uat.dbg.westfield.com";
}

elseif (req.http.Host ~ "^(www\.)?westfield\.com\.au$") {
        set req.backend = redirects;
}
