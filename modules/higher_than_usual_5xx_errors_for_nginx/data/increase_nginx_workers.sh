
#!/bin/bash

# Set the number of NGINX worker processes to ${NUM_WORKERS}

NUM_WORKERS=${NUM_WORKERS}

sed -i "s/worker_processes [0-9]\+;/worker_processes $NUM_WORKERS;/" /etc/nginx/nginx.conf

# Reload the NGINX configuration

nginx -t && service nginx reload

echo "NGINX worker processes increased to $NUM_WORKERS"