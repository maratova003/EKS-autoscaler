# EKS-autoscaler
Set Up Cluster Autoscaler for EKS Cluster 

On AWS, Cluster Autoscaler utilizes Amazon EC2 Auto Scaling Groups to manage node groups. Cluster Autoscaler typically runs as a Deployment in your cluster.

Prerequisites/requirements: 
Cluster Autoscaler requires Kubernetes v1.3.0 or greater. 
kubectl is a command-line tool for interacting with Kubernetes clusters. You can install kubectl by following the steps in the Kubernetes documentation.
Connect to the EKS cluster by running aws eks update-kubeconfig –name <cluster name> This will update the kubectl configuration file with the necessary authentication credentials. 


Create OIDC Federated Authentication
OIDC federated authentication allows your service to assume an IAM role and interact with AWS services without having to store credentials as environment variables. Create an IAM OIDC identity provider for your cluster with the AWS Management Console using the documentation 

Create a policy 

Create an IAM role for your service accounts in the console.

Retrieve the OIDC issuer URL from the Amazon EKS console description of your cluster. It will look something identical to: 'https://oidc.eks.us-east-1.amazonaws.com/id/xxxxxxxxxx'
While creating a new IAM role, In the "Select type of trusted entity" section, choose "Web identity".
In the "Choose a web identity provider" section: For Identity provider, choose the URL for your cluster. For Audience, type sts.amazonaws.com.
In the "Attach Policy" section, select the policy to use for your service account, that you created in the second step
After the role is created, choose the role in the console to open it for editing.
Choose the "Trust relationships" tab, and then choose "Edit trust relationship". Edit the OIDC provider suffix and change it from :aud to :sub. Replace sts.amazonaws.com to your service account ID.
Update trust policy to finish.


Deploy the cluster autoscaler. Yaml file below.  


Test the autoscaler: 
Check if cluster autoscaler is in running state by running: kubectl get pods -n kube-system
Run kubectl get nodes - to check how many nodes are currently running 
Create a deployment, for example kubectl create deployment <name> –image=nginx 
Scale it up. Example: kubectl scale deployment <name> –replicas=5
Run kubectl get nodes again to check if the number of nodes increased 


