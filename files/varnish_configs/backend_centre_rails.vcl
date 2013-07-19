# $Id$

backend centre_rail_aubdc_fapuat01 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 16;
	.probe = {
		.timeout = 2 s;
		.interval = 30 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /admin/ping HTTP/1.1"
			"Host: premium.uat.dbg.westfield.com"
			"Connection: close";
	}
}

backend centre_rail_aubdc_fapuat02 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 16;
	.probe = {
		.timeout = 2 s;
		.interval = 30 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /admin/ping HTTP/1.1"
			"Host: premium.uat.dbg.westfield.com"
			"Connection: close";
	}
}

director centre_rails random {
	{ .backend = centre_rail_aubdc_fapuat01; .weight = 1; }
	{ .backend = centre_rail_aubdc_fapuat02; .weight = 1; }
}

