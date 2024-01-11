FROM nginx:latest

LABEL org.label-schema.maintainer="Hexagone team"

# deliver a custom index.html file
ADD index.html /usr/share/nginx/html/

# start the app
CMD ["nginx", "-g", "daemon off;"]

