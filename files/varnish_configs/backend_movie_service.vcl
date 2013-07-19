backend movie_service_localhost {
  .host = "localhost";
  .port = "8080";
  .max_connections = 16;
  .probe = {
    .timeout = 500 ms;
    .interval = 10 s;
    .window = 5;
    .threshold = 2;
    .request =
      "GET /api/movie/master/movies.json HTTP/1.1"
      "Host: movie-service.production.dbg.westfield.com"
      "Connection: close";
  }
}

director movie_service random {
  { .backend = movie_service_localhost; .weight = 1; }
}

