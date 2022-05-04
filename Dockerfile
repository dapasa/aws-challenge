FROM nginx

WORKDIR /usr/share/nginx/html

COPY /html .

HEALTHCHECK CMD wget -q --no-cache --spider localhost/index.htm