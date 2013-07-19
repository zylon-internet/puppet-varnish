if (req.url ~ "^/retailer-offers/extimg/wfcau/") {
	set req.backend = centre_refresh;
# Catalyst-centre doesn't know how to handle these headers
# Browser may issue a "some objects not secure" warning if catalyst
# redirects to http://westfield.com.au/ instead of https://secure.retailedge...
#	set req.http.X-Forwarded-Host = req.http.Host;
#	set req.http.X-Forwarded-Protocol = "https";
	set req.http.Host = "westfield.com.au";
	set req.url = regsub(req.url, "^/retailer-offers/extimg/wfcau/(.*)$", "/\1");

} elseif (req.url ~ "^/retailer-offers/extimg/static/") {
	set req.backend = contentstore;
	set req.http.Host = "static.westfield.com";
	set req.url = regsub(req.url, "^/retailer-offers/extimg/static/(.*)$", "/\1");

} elseif (req.url ~ "^/retailer-offers($|/)") {
	set req.backend = redgebackoffice_rails;
	set req.http.X-Forwarded-Host = req.http.Host;
	set req.http.Host = "redgebackoffice.prod.dbg.westfield.com";

} elseif (req.url ~ "^/(assets/|accounts-payable/|images/|favicon.ico$)") {
	set req.backend = centre_refresh;
	set req.http.Host = "nossl.retailedge.com.au";

} else {
	error 752 "http://retailedge.com.au/";

} 

