FROM fluent/fluentd:edge-debian

USER root

RUN apt-get update && apt-get install -y default-libmysqlclient-dev \
	&& apt-get install -y --no-install-recommends sudo make gcc g++ libc-dev \
	&& sudo gem install mysql2 \
	&& sudo gem install fluent-plugin-json \
	&& gem install fluent-plugin-mysql --no-document \
	&& sudo gem sources --clear-all \
	&& apt-get purge -y --auto-remove \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

USER fluent
