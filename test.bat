docker build -t mramados/datascience_server .
docker run  mramados/datascience_server
docker container stop $(docker container ls -aq) | docker system prune -af --volumes
