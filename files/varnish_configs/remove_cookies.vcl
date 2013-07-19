# $Id: remove_cookies.vlc 861 2010-03-01 02:29:21Z thiago $ 

# Remove cookies not used by Westfield.com
if (req.http.Cookie) {
	# GA cookies
	set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *__utm.=[^;]+;? *", "\1");

	if (req.http.Cookie == "") {
		remove req.http.Cookie;
	}
}
