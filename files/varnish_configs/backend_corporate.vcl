backend corporate_aubdc_dpuat01 {
	.host = "localhost";
	.port = "8080";
	.max_connections = 30;
	.probe = {
		.timeout = 3 s;
		.interval = 5 s;
		.window = 5;
		.threshold = 2;
		.request = 
			"GET /corporate/ HTTP/1.1"
			"Host: westfield.com"
			"Connection: close";
	}
}

backend corporate_aubdc_dpuat02 {
        .host = "localhost";
        .port = "8080";
        .max_connections = 30;
        .probe = {
                .timeout = 3 s;
                .interval = 5 s;
                .window = 5;
                .threshold = 2;
                .request =
			"GET /corporate/ HTTP/1.1"
                        "Host: westfield.com"
                        "Connection: close";
        }
}


director corporate random {
	{ .backend = corporate_aubdc_dpuat01; .weight = 1; }
	{ .backend = corporate_aubdc_dpuat02; .weight = 1; }
}

