kind create cluster --config=config.yaml
kubectl apply -f ingress-nginx-controller.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
docker build -t kindtest:latest ./images/
kind load docker-image kindtest:latest --name local