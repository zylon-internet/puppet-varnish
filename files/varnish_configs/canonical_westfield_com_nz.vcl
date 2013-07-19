# Managed by Satellite

if (
	req.http.Host ~ "^uk\.westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfield\.com\.au$" ||
        req.http.Host ~ "^wwwau\.uat\.westfield\.com$" ||
        req.http.Host ~ "^wwwuk\.uat\.westfield\.com$" ||
        req.http.Host ~ "^wwwus\.uat\.westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfields\.com\.au$" ||
	req.http.Host ~ "^wwwau\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwuk\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwus\.(sta|uat|syt)\.dbg\.westfield\.com$" ) 
{
	# It sucks to do the regexp twice but I couldn't come-up with a solution that
	# added a / for "/centre" requests and didn't for "/centre/file.exp".
	# The latter can't have a slash added; the former must.  Feel free to come-up
	# with something better.
	if (req.url ~ "^/(albany|chartwell|downtown|glenfield|manukau|newmarket|nzcentres|pakuranga|queensgate|riccarton|shorecity|stlukes|westcity)/?$") {
		set req.url = regsub(req.url, "^/([^/]+)(/*)$", "http://wwwnz.uat.westfield.com/\1/");
		error 751 req.url;
	} elseif (req.url ~ "^/(albany|chartwell|downtown|glenfield|manukau|newmarket|nzcentres|pakuranga|queensgate|riccarton|shorecity|stlukes|westcity)/") {
		set req.url = regsub(req.url, "^/([^/]+)/(.*)$", "http://wwwnz.uat.westfield.com/\1/\2");
		error 751 req.url;
	}
}

