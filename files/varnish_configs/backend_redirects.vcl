backend redirects_aubdc_fapuat01 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 20;
	.probe = {
		.timeout = 2 s;
		.interval = 20 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET / HTTP/1.1"
			"Host: ukleasing.westfield.com"
			"Connection: close";
	}
}

backend redirects_aubdc_fapuat02 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 20;
	.probe = {
		.timeout = 2 s;
		.interval = 20 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET / HTTP/1.1"
			"Host: ukleasing.westfield.com"
			"Connection: close";
	}
}

director redirects random {
	{ .backend = redirects_aubdc_fapuat01; .weight = 1; }
	{ .backend = redirects_aubdc_fapuat02; .weight = 1; }
}

