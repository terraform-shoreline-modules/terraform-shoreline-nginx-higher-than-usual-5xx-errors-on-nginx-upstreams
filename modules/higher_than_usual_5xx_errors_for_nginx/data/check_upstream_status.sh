if curl -s -o /dev/null -w "%{http_code}" $UPSTREAM_URL | grep -q "200"; then

  echo "Upstream server is responding with HTTP 200"

else

  echo "Upstream server is not responding with HTTP 200"

fi