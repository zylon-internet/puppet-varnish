if (
	req.http.Host ~ "^(www\.)?westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfield\.com\.au$" ||
	req.http.Host ~ "^(www\.)?westfields\.com\.au$" ||
	req.http.Host ~ "^(www\.)?westfield\.co\.nz$" ||
	req.http.Host ~ "^(www\.)?westfields\.co\.uk$" ||
        req.http.Host ~ "^wwwnz\.uat\.westfield\.com$" ||
        req.http.Host ~ "^wwwau\.uat\.westfield\.com$" ||
        req.http.Host ~ "^wwwus\.uat\.westfield\.com$" ||
	req.http.Host ~ "^wwwau\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwnz\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwus\.(sta|uat|syt)\.dbg\.westfield\.com$" ) 
{
	# It sucks to do the regexp twice but I couldn't come-up with a solution that
	# added a / for "/centre" requests and didn't for "/centre/file.exp".
	# The latter can't have a slash added; the former must.  Feel free to come-up
	# with something better.
	if (req.url ~ "^/(bradford|broadmarsh|castlecourt|derby|eaglecentre|london|londondevelopment|merryhill|royalvictoriaplace|stratfordcity|stratfordcityleasing|thefriary|thevillagelondon|ukcentres)/?$") {
		set req.url = regsub(req.url, "^/([^/]+)(/*)$", "http://wwwuk.uat.westfield.com/\1/");
		error 751 req.url;
	} elseif (req.url ~ "^/(bradford|broadmarsh|castlecourt|derby|eaglecentre|london|londondevelopment|merryhill|royalvictoriaplace|stratfordcity|stratfordcityleasing|thefriary|thevillagelondon|ukcentres)/") {
		set req.url = regsub(req.url, "^/([^/]+)/(.*)$", "http://wwwuk.uat.westfield.com/\1/\2");
		error 751 req.url;
	}
}

