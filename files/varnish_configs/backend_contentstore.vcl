# $Id$


backend contentstore_aubdc_fapuat01 {
	.host = "localhost";
	.port = "8080";
 	.max_connections = 128;
 	.probe = {
	 	.timeout = 1000 ms;
		.interval = 5 s;
 		.window = 5;
 		.threshold = 2;
 		.request =
 		"GET /admin/about HTTP/1.1"
 		"Host: static.uat.dbg.westfield.com"
 		"Connection: close";
 	} 
}

backend contentstore_aubdc_fapuat02 {
	.host = "localhost";
	.port = "8080";
 	.max_connections = 128;
 	.probe = {
	 	.timeout = 1000 ms;
		.interval = 5 s;
 		.window = 5;
 		.threshold = 2;
 		.request =
 		"GET /admin/about HTTP/1.1"
 		"Host: static.uat.dbg.westfield.com"
 		"Connection: close";
 	} 
}

director contentstore random {
	{ .backend = contentstore_aubdc_fapuat01; .weight = 1; }
	{ .backend = contentstore_aubdc_fapuat02; .weight = 1; }
}

