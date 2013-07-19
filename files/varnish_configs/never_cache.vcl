(
        (req.http.Host ~ "^insurance\.westfield\.com$") ||
	(req.http.Host ~ "^(www\.)?westfield\.com$" && req.url ~ "^/geo/$" ) ||
	(req.http.Host ~ "^(www\.)?westfield\.com$" && req.url ~ "^/$") ||
	(req.http.Host ~ "^((www|uk)\.)?westfield.com?(\.(nz|au|mobi))?$" && req.url ~ "^/common/ping") ||
	(req.url ~ "^/(admin|api/cart.json)/")
)
