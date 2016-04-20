FROM debian:wheezy

# Set environment.
ENV DEBIAN_FRONTEND noninteractive

# Compile openresty from source.
RUN \
  apt-get update && \
  apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make wget dnsmasq openssl unzip && \
  apt-get clean && \
  cd /home && \
  wget --no-check-certificate https://openresty.org/download/ngx_openresty-1.7.7.1.tar.gz && \
  tar -xzvf ngx_openresty-1.7.7.1.tar.gz && \
  rm -f ngx_openresty-1.7.7.1.tar.gz && \
  cd ngx_openresty-1.7.7.1 && \
  ./configure --with-pcre-jit --with-ipv6 \
  		--without-lua_cjson \
  		--without-lua_rds_parser \
  		--without-lua_resty_dns \
  		--without-lua_resty_lock \
  		--without-lua_resty_lrucache \
  		--without-lua_resty_memcached \
  		--without-lua_resty_mysql \
  		--without-lua_resty_redis \
  		--without-lua_resty_upload \
  		--with-http_spdy_module && \  	  	
  make && \
  make install && \
  make clean && \
  cd .. && \
  rm -rf ngx_openresty-* && \
  ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx && \
  ldconfig && \
  mkdir -p /usr/local/openresty/nginx/cache && \
  mkdir -p /usr/local/openresty/nginx/tmp && \
  ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log && \
  ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log && \
  echo 'user=root' >> /etc/dnsmasq.conf

# Set the working directory.
WORKDIR /opt/openresty

# Define the default command.
CMD /etc/init.d/dnsmasq start && nginx -g 'daemon off;' -c /etc/nginx/nginx.conf