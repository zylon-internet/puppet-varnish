# This file is managed by RHN Satellite

backend acacia_aubdc_fapuat01 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 64;
	.probe = {
		.timeout = 2 s;
		.interval = 5 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /admin/about HTTP/1.1"
			"Host: fas.uat.dbg.westfield.com"
			"Connection: close";
	}
}

backend acacia_aubdc_fapuat02 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 64;
	.probe = {
		.timeout = 2 s;
		.interval = 5 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /admin/about HTTP/1.1"
			"Host: fas.uat.dbg.westfield.com"
			"Connection: close";
	}
}
director acacia random {
	{ .backend = acacia_aubdc_fapuat01; .weight = 1; }
	{ .backend = acacia_aubdc_fapuat02; .weight = 1; }
}

