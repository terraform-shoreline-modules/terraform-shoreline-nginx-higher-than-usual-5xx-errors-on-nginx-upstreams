
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Higher than usual 5xx Errors for NGINX 
---

This incident type refers to a situation where the number of 5xx errors on NGINX upstreams is higher than usual. It is an indication that there could be an issue with the NGINX server or the upstream application server. This type of incident requires immediate attention as it can impact the availability and performance of the application.

### Parameters
```shell
# Environment Variables

export UPSTREAM_SERVER_URL="PLACEHOLDER"

export SERVER_IP="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export UPSTREAM_URL="PLACEHOLDER"

export NUM_WORKERS="PLACEHOLDER"
```

## Debug

### 1. Check server status
```shell
systemctl status nginx
```

### 2. Check if the server is running
```shell
ps aux | grep nginx
```

### 3. Check the error log for any relevant information
```shell
tail -f /var/log/nginx/error.log
```

### 4. Check the access log to see if there are any suspiciously high traffic spikes
```shell
tail -f /var/log/nginx/access.log
```

### 5. Check the server configuration for any errors
```shell
nginx -t
```

### 6. Check if there are any issues with upstream servers
```shell
curl -I ${UPSTREAM_SERVER_URL}
```

### 7. Check the network connectivity to the server
```shell
ping ${SERVER_IP}
```

### 8. Check if there are any firewall rules blocking traffic
```shell
iptables -L
```

### 9. Check if there are any other services running on the same host that could be interfering with NGINX
```shell
ps aux | grep ${SERVICE_NAME}
```

### 10. Check if there are any resource constraints on the server
```shell
top
```

### 11. Check if there are any other system-level issues that may be impacting NGINX
```shell
dmesg
```
## Check if the upstream server is responding with a HTTP 200 status code
```shell
if curl -s -o /dev/null -w "%{http_code}" $UPSTREAM_URL | grep -q "200"; then

  echo "Upstream server is responding with HTTP 200"

else

  echo "Upstream server is not responding with HTTP 200"

fi
```
## Repair

### Increase the number of NGINX worker processes to handle the increased traffic and prevent the server from getting overloaded.
```shell

#!/bin/bash

# Set the number of NGINX worker processes to ${NUM_WORKERS}

NUM_WORKERS=${NUM_WORKERS}

sed -i "s/worker_processes [0-9]\+;/worker_processes $NUM_WORKERS;/" /etc/nginx/nginx.conf

# Reload the NGINX configuration

nginx -t && service nginx reload

echo "NGINX worker processes increased to $NUM_WORKERS"


```