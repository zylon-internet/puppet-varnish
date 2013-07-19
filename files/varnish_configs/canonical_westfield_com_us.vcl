# Managed by Satellite

if (
	req.http.Host ~ "^uk\.westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfield\.com\.au$" ||
	req.http.Host ~ "^(www\.)?westfields\.com\.au$" ||
        req.http.Host ~ "^wwwnz\.uat\.westfield\.com$" ||
        req.http.Host ~ "^wwwuk\.uat\.westfield\.com$" ||
        req.http.Host ~ "^wwwau\.uat\.westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfield\.co\.nz$" ||
	req.http.Host ~ "^wwwau\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwnz\.(sta|uat|syt)\.dbg\.westfield\.com$" ||
	req.http.Host ~ "^wwwuk\.(sta|uat|syt)\.dbg\.westfield\.com$" )
{
	# It sucks to do the regexp twice but I couldn't come-up with a solution that
	# added a trailing / for "/centre" requests and didn't for "/centre/etc".
	# The latter can't have a slash added; the former must.  Feel free to come-up
	# with something better.
	if (req.url ~ "^/(annapolis|beldenvillage|brandon|broward|capital|centurycity|chicagoridge|citruspark|connecticutpost|corporate|countryside|culvercity|downtownplaza|eastridge|fashionsquare|foxhills|foxvalley|franklinpark|galleriaatroseville|gardenstateplaza|gateway|greatnorthern|hawthorn|hortonplaza|louisjoliet|mainplace|meriden|metreon|missionvalley|montgomery|northcounty|oakridge|oldorchard|palmdesert|parkway|plazabonita|plazacaminoreal|promenade|sanfrancisco|santaanita|sarasota|solano|southcenter|southgate|southlake|southpark|southshore|sunrise|topanga|trumbull|uscentres|utc|valencia|valleyfair|vancouver|westcovina|westland|wheaton)/?$") {
		set req.url = regsub(req.url, "^/([^/]+)/*$", "http://wwwus.uat.westfield.com/\1/");
		error 751 req.url;
	} elseif (req.url ~ "^/(annapolis|beldenvillage|brandon|broward|capital|centurycity|chicagoridge|citruspark|connecticutpost|corporate|countryside|culvercity|downtownplaza|eastridge|fashionsquare|foxhills|foxvalley|franklinpark|galleriaatroseville|gardenstateplaza|gateway|greatnorthern|hawthorn|hortonplaza|louisjoliet|mainplace|meriden|metreon|missionvalley|montgomery|northcounty|oakridge|oldorchard|palmdesert|parkway|plazabonita|plazacaminoreal|promenade|sanfrancisco|santaanita|sarasota|solano|southcenter|southgate|southlake|southpark|southshore|sunrise|topanga|trumbull|uscentres|utc|valencia|valleyfair|vancouver|westcovina|westland|wheaton)/") {
		set req.url = regsub(req.url, "^/([^/]+)/(.*)$", "http://wwwus.uat.westfield.com/\1/\2");
		error 751 req.url;
	}
}

