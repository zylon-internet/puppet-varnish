backend customer_console_localhost {
  .host = "localhost";
  .port = "8080";
  .max_connections = 16;
  .connect_timeout = 120s;
  .first_byte_timeout = 120s;
  .between_bytes_timeout = 120s;
  .probe = {
    .timeout = 500 ms;
    .interval = 10 s;
    .window = 5;
    .threshold = 2;
    .request = 
      "GET /status.json HTTP/1.1"
      "Host: customer-console.production.dbg.westfield.com"
      "Connection: close";
  }
}

director customer_console random {
  { .backend = customer_console_localhost; .weight = 1; }
}

