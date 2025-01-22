FROM nginx:alpine

RUN apk add --no-cache \
	geoip geoip-dev \
	libmaxminddb-dev \
	&& apk add --no-cache --virtual .build-deps \
	build-base \
	&& mkdir -p /etc/nginx/geoip \
	&& wget -q -O /etc/nginx/geoip/GeoIP.dat.gz "https://mailfud.org/geoip-legacy/GeoIP.dat.gz" \
	&& wget -q -O /etc/nginx/geoip/GeoIPCity.dat.gz "https://mailfud.org/geoip-legacy/GeoIPCity.dat.gz" \
	&& gunzip /etc/nginx/geoip/GeoIP.dat.gz \
	&& gunzip /etc/nginx/geoip/GeoIPCity.dat.gz \
	&& apk del .build-deps

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
