backend product_service_localhost {
  .host = "localhost";
  .port = "8080";
  .max_connections = 16;
  .probe = {
    .timeout = 500 ms;
    .interval = 10 s;
    .window = 5;
    .threshold = 2;
    .request =
      "GET /admin/about HTTP/1.1"
      "Host: product-service.production.dbg.westfield.com"
      "Connection: close";
  }
}

director product_service random {
  { .backend = product_service_localhost; .weight = 1; }
}

