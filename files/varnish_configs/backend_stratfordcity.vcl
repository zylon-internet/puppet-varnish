# $Id$

backend centre_stratfordcity_aubdc_fapuat01 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 16;
	.probe = {
		.timeout = 2 s;
		.interval = 5 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /stratfordcity/ HTTP/1.1"
			"Host: stratfordcity.uat.dbg.westfield.com"
			"Connection: close";
	}
}

backend centre_stratfordcity_aubdc_fapuat02 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 16;
	.probe = {
		.timeout = 2 s;
		.interval = 5 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /stratfordcity/ HTTP/1.1"
			"Host: stratfordcity.uat.dbg.westfield.com"
			"Connection: close";
	}
}

director stratfordcity_rails random {
	{ .backend = centre_stratfordcity_aubdc_fapuat01; .weight = 1; }
	{ .backend = centre_stratfordcity_aubdc_fapuat02; .weight = 1; }
}
