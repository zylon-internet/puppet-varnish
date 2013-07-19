(
  (
    req.http.Host ~ "^image-service\.(development|test|systest|uat|production)\.dbg\.westfield\.com$"
  ) &&
  req.url ~ "^/transform/?"
)

