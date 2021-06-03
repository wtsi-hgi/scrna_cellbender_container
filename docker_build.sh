nohup sudo docker build . -t wtsihgi/nf_cellbender:v1.2 &
docker login
docker push wtsihgi/nf_cellbender:v1.2
