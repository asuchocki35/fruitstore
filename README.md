#####################################
README
#####################################
IASP 540 LAB
Lab Objective:
This lab will guide students through the process of installing Kubernetes, creating a Kubernetes Secret to store a SQL database password, and then encrypting that Secret by creating a Sealed Secret. This exercise demonstrates the application of the CIA Triad, particularly focusing on confidentiality and integrity within a Kubernetes environment.
________________________________________
Part 1: Installing Kubernetes
Step 1: Install a Kubernetes Cluster
•	Option 1: Minikube (For Local Development)
1.	Install Minikube:
	On Windows:
	Download the Minikube installer from Minikube's official site.
	https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download 
	Run the installer and follow the on-screen instructions.
	On Mac OS:
	Open Terminal and run the following command:
#brew install minikube
2.	Start Minikube:
	Run the following command to start Minikube:
#minikube start
•	Option 2: Kubernetes via Docker Desktop
1.	Install Docker Desktop:
	Download Docker Desktop from Docker's official site and install it.
2.	Enable Kubernetes:
	Open Docker Desktop, go to Settings > Kubernetes, and enable Kubernetes.
	Click Apply & Restart to start the Kubernetes cluster.
Step 2: Verify Kubernetes Installation
1.	Open a terminal or command prompt.
2.	Run the following command to check the status of your Kubernetes cluster:
#kubectl cluster-info
o	You should see output indicating that the Kubernetes control plane is running.
3.	Next confirm the current default namespaces on the cluster
#kubectl get namespace
4.	In VsCode traverse to a blank directory (does not matter)
5.	Next perform a git clone on this repository
6.	Now traverse to the fruitstore home directory
7.	Next enter this command to initialize your current terminals environment (eval $(minikube docker-env)
8.	Perform the docker build on the dockerfile (docker build -t fruitstore:latest)
9.	Next enter this command to list the current available images (docker image list)
10.	Next tag the recent image for version 1.0 (docker tag fruitstore:latest fruitstore:1.0)
11.	Next traverse to the Kubernetes directory
12.	Next deploy the MariaDB first (bash create-db.sh)
13.	Open a new gitbash terminal and enable the Kubernetes dashboard (minikube dashboard)
14.	Next get the pod name for the MariaDB (kubectl get pods)
15.	Copy the Init.sql script to the pod (kubectl cp ./init.sql <podname>:/var/lib/mysql)
16.	Login to the MariaDB Pod (mysql -uroot -ppassword)
17.	Execute the sql script to create the database (source /var/lib/mysql/init.sql)
18.	Now go back to the gitbash terminal and deploy the app (bash create-app.sh)
19.	Once the pod is up we will now expose the service (minikube service fruitstore-service -n fruitstore)
________________________________________
Part 2: Creating a Kubernetes Secret
Step 1: Create a YAML File for the Secret
1.	Create a file named secret.yaml with the following content:
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=       # Base64 encoded value of 'admin'
  password: c3VwZXJzZWNyZXQ=  # Base64 encoded value of 'supersecret'
o	Explanation:
	username and password fields store the Base64 encoded values of admin and supersecret.
	These values represent the credentials for accessing the SQL database.
2.	Test the encoding
#echo -n 'c3VwZXJzZWNyZXQ=' | base64 --decode
Step 2: Apply the Secret to Kubernetes
1.	Use the following command to create the Secret in your Kubernetes cluster:
kubectl apply -f secret.yaml
2.	Verify the Secret is created:
kubectl get secrets
o	You should see db-secret listed among the Secrets.
________________________________________
Part 3: Sealing the Secret
Step 1: Install Kubeseal
1.	Install Kubeseal (a tool for sealing Kubernetes Secrets):
o	On Windows:
	Download the controller.yaml filfe from the Kubeseal Github release page below
	Once you have the controller.yaml deploy it to minikube under the namespace kube-system
#kubectl apply -f controller.yaml
•	Confirm the controller was deployed
			#kubectl get pods -n kube-system
NAME                                         READY   STATUS    RESTARTS      AGE
coredns-7db6d8ff4d-rzcmb                     1/1     Running   0             16h
etcd-minikube                                1/1     Running   0             16h
kube-apiserver-minikube                      1/1     Running   1 (16h ago)   16h
kube-controller-manager-minikube             1/1     Running   0             16h
kube-proxy-2qzbn                             1/1     Running   0             16h
kube-scheduler-minikube                      1/1     Running   0             16h
sealed-secrets-controller-648d6cccdb-gnxtc   1/1     Running   0             3m32s
storage-provisioner                          1/1	Running	0
	Download the Kubeseal binary from the Kubeseal GitHub releases page.
	Add the binary to your system's Minikube folder.
Mine was C:/Program Files/Kubernetes/MiniKube
o	On Mac OS:
	Install Kubeseal via Homebrew:
brew install kubeseal
Step 2: Retrieve the Sealed Secrets Controller Public Key
1.	Run the following command to retrieve the public key from the Sealed Secrets controller:
kubeseal --fetch-cert --controller-name=sealed-secrets-controller --controller-namespace=kube-system > mycert.pem
Step 3: Create a Sealed Secret
1.	Use Kubeseal to encrypt the Secrets
kubectl get secret db-secret -o yaml | kubeseal --cert mycert.pem --format yaml > sealedsecret.yaml
2.	The sealedsecret.yaml file now contains the encrypted Secret.
Step 4: Apply the Sealed Secret
1.	Apply the Sealed Secret to your Kubernetes cluster:
kubectl apply -f sealedsecret.yaml
2.	Verify the Sealed Secret is created:
kubectl get sealedsecrets
o	The Sealed Secret should be listed, ensuring that the SQL database password is securely encrypted.
________________________________________
Conclusion:
In this lab, you successfully installed Kubernetes, created a Secret to store a SQL database password, and then encrypted that Secret by creating a Sealed Secret. This process demonstrates how Kubernetes can be used to maintain the confidentiality and integrity of sensitive information within a cloud-native environment.

