rm nohup.out && nohup sudo docker build . -t wtsihgi/nf_cellbender:v1.3 & sleep 2 && tail -f nohup.out

docker login

docker push wtsihgi/nf_cellbender:v1.3
