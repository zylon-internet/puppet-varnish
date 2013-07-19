(
 (
  req.http.Host ~ "^(www\.)?westfield\.com\.au$" ||
  req.http.Host ~ "^(www\.)?westfield\.co\.nz$" ||
  req.http.Host ~ "^(www(au|us|nz|uk)?\.)?(uat.)?westfield\.com$" ||
  req.http.Host == "uk.westfield.com" ||
  req.http.Host ~ "^cdnsa[1-4]?\.(uat.)?atwestfield\.com$"
 ) || (
  req.http.Host ~ "^api\.(uat.)?westfield\.com$" && 
  req.url ~ "^/(centres|product-feed|sitemap)/"
 )
)

