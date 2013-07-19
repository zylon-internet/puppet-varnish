# $Id$


backend contentservice_aubdc_fapuat01 {
	.host = "localhost";
	.port = "8080";
 	.max_connections = 32;
 	.probe = {
	 	.timeout = 500 ms;
		.interval = 5 s;
 		.window = 5;
 		.threshold = 2;
 		.request =
 		"GET /admin/ping HTTP/1.1"
 		"Host: contentservice.uat.dbg.westfield.com"
 		"Connection: close";
 	} 
}

backend contentservice_aubdc_fapuat02 {
	.host = "localhost";
	.port = "8080";
 	.max_connections = 32;
 	.probe = {
	 	.timeout = 500 ms;
		.interval = 5 s;
 		.window = 5;
 		.threshold = 2;
 		.request =
 		"GET /admin/ping HTTP/1.1"
 		"Host: contentservice.uat.dbg.westfield.com"
 		"Connection: close";
 	} 
}

director contentservice random {
	{ .backend = contentservice_aubdc_fapuat01; .weight = 1; }
	{ .backend = contentservice_aubdc_fapuat02; .weight = 1; }
}

