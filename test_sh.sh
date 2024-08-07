deploymentYaml=$(cat <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
 name: flask-app
spec:
 replicas: 1
 selector:
   matchLabels:
     app: flask-app
 template:
   metadata:
     labels:
       app: flask-app
   spec:
     containers:
     - name: flask-app
       image: deep1301/$2:$3
       ports:
       - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
 name: flask-app-service
spec:
 type: LoadBalancer
 selector:
   app: flask-app
 ports:
   - port: 80
     targetPort: 8001
EOF
)

if [ -e deployment.yaml ]
then
        rm -rf deployment.yaml
fi

echo "$deploymentYaml" > deployment.yaml
kubectl apply -f deployment.yaml

