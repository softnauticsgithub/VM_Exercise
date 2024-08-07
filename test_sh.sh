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
 namespace: metallb-system
spec:
 type: LoadBalancer
 selector:
   app: flask-app
 ports:
   - protocol: TCP
     port: 80
     targetPort: 5000
EOF
)

if [ -e deployment.yaml ]
then
        rm -rf deployment.yaml
fi

echo "$deploymentYaml" > deployment.yaml
kubectl apply -f deployment.yaml

