(
  (
    req.http.Host ~ "^wwwau.(production|systest|uat|test|development).dbg.westfield.com$" ||
    req.http.Host ~ "^file-service\.(development|test|systest|uat|production)\.dbg\.westfield\.com$"
  ) &&
  req.url ~ "^/api/file/?"
)

