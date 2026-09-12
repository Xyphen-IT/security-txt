FROM nginxinc/nginx-unprivileged:1.28-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY security.txt /usr/share/nginx/html/security.txt

EXPOSE 8080
