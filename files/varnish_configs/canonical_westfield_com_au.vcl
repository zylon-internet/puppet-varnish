if (
	req.http.Host ~ "^uk\.westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfields\.com\.au$" ||
	req.http.Host ~ "^(www\.)?westfield\.co\.nz$" ||
	req.http.Host ~ "^wwwnz\.uat\.westfield\.com$" ||
	req.http.Host ~ "^wwwuk\.uat\.westfield\.com$" ||
	req.http.Host ~ "^wwwus\.uat\.westfield\.com$" || 
	req.http.Host ~ "^wwwnz\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwuk\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwus\.(sta|uat|syt)\.dbg\.westfield\.com$" ) 
{
	# It sucks to do the regexp twice but I couldn't come-up with a solution that
	# added a / for "/centre" requests and didn't for "/centre/file.exp".
	# The latter can't have a slash added; the former must.  Feel free to come-up
	# with something better.
	if (req.url ~ "^/(au|airportwest|aucentres|belconnen|bondijunction|brandspace|burwood|carindale|carousel|centrepoint|chatswood|chermside|community|doncaster|eastgardens|figtree|fountaingate|gardencity|geelong|gifts|helensvale|hornsby|hurstville|innaloo|kotara|liverpool|marion|miranda|mtdruitt|northlakes|northrocks|parramatta|penrith|plentyvalley|southland|strathpine|sydney|sydneycentralplaza|teatreeplaza|tuggerah|warrawong|westlakes|whitfordcity|woden)/?$") {
		set req.url = regsub(req.url, "^/([^/]+)(/*)$", "http://wwwau.uat.westfield.com/\1/");
		error 751 req.url;
	} elseif (req.url ~ "^/(au|airportwest|aucentres|belconnen|bondijunction|brandspace|burwood|carindale|carousel|centrepoint|chatswood|chermside|community|doncaster|eastgardens|figtree|fountaingate|gardencity|geelong|gifts|helensvale|hornsby|hurstville|innaloo|kotara|liverpool|marion|miranda|mtdruitt|northlakes|northrocks|parramatta|penrith|plentyvalley|southland|strathpine|sydney|sydneycentralplaza|teatreeplaza|tuggerah|warrawong|westlakes|whitfordcity|woden)/") {
		set req.url = regsub(req.url, "^/([^/]+)/(.*)$", "http://wwwau.uat.westfield.com/\1/\2");
		error 751 req.url;
	}
}

