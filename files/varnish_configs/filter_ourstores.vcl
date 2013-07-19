((
	req.http.Host ~ "^uk\.westfield\.com$" ||
	req.http.Host ~ "^(www\.)?westfield\.com(\.au)?$" ||
	req.http.Host ~ "^(www\.)?westfield\.co\.nz$" ||
	req.http.Host ~ "^www(au|nz|uk|us)\.uat\.westfield\.com$" ||
	req.http.Host ~ "^www(au|nz|uk|us)\.(sta|uat|syt)\.dbg\.westfield\.com$" ) &&
( req.url ~ "^/(albany|annapolis|beldenvillage|brandon|broadmarsh|broward|capital|castlecourt|chartwell|chicagoridge|citruspark|connecticutpost|countryside|culvercity|downtown|downtownplaza|eastridge|fashionsquare|foxvalley|franklinpark|gateway|glenfield|greatnorthern|hawthorn|hortonplaza|louisjoliet|mainplace|manukau|meriden|merryhill|metreon|missionvalley|newmarket|northcounty|oakridge|pakuranga|palmdesert|parkway|plazabonita|plazacaminoreal|promenade|queensgate|riccarton|royalvictoriaplace|santaanita|sarasota|shorecity|solano|southcenter|southgate|southlake|southpark|southshore|stlukes|sunrise|thefriary|trumbull|valencia|vancouver|westcity|westcovina|westland|wheaton)/ourstores(/?$|/)"))
