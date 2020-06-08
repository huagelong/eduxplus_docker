FROM centos:7.8.2003
LABEL maintainer="kaihui.wang <hpuwang@gmail.com>"
RUN curl -LsS https://gitee.com/wangkaihui/codes/d651vswgimh0u79obe8xy85/raw?blob_name=lnmp_docker -o lnmp;\
     sed -i -e 's/\r//g' ./lnmp;\
     chmod +x lnmp;\
     ./lnmp
WORKDIR /opt/openresty/nginx/html
CMD ["service php-fpm restart", "service openresty restart"]

