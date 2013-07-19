(
 (req.http.Host == "secure.uat.westfield.com") ||
  ((
   (req.http.Host == "wwwau.uat.westfield.com") 
  ) && (
# [2012-11-01 thiago] Broke down regexps.  We know how cool they look in a 
#                     single line but it's hard to maintain.
# Shopping cart
   req.url ~ "^/api/(latest/)?cart(\.json)?$" ||
# Delete item from shopping cart
   req.url ~ "^/api/(latest/)?cart/items/[^/]+\.json$" ||
# Shipping options
   req.url ~ "^/api/latest/cart/update_shipping.json$"
  )
 )
)
