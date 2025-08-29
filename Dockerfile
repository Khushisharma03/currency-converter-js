# Use Nginx image to serve static files
FROM nginx:alpine

# Remove the default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy your frontend project (HTML, CSS, JS)
COPY . /usr/share/nginx/html

# Expose port 80 inside the container
EXPOSE 80

