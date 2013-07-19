# Managed by Satellite

backend centre_refresh_aubdc_dpuat01 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 50;
	.probe = {
		.timeout = 1 s;
		.interval = 5 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /common/ping HTTP/1.1"
			"Host: westfield.com"
			"Connection: close";
	}
}

backend centre_refresh_aubdc_dpuat02 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 50;
	.probe = {
		.timeout = 1 s;
		.interval = 5 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /common/ping HTTP/1.1"
			"Host: westfield.com"
			"Connection: close";
	}
}

director centre_refresh random {
	{ .backend = centre_refresh_aubdc_dpuat01; .weight = 1; }
	{ .backend = centre_refresh_aubdc_dpuat02; .weight = 1; }
}

