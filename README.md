Set Up Cluster Autoscaler for EKS Cluster 
# Set Up Cluster Autoscaler for EKS Cluster 

On AWS, Cluster Autoscaler utilizes Amazon EC2 Auto Scaling Groups to manage node groups. Cluster Autoscaler typically runs as a Deployment in your cluster.
On AWS, Cluster Autoscaler utilizes Amazon EC2 Auto Scaling Groups to manage node groups. Cluster Autoscaler typically runs as a `Deployment` in your cluster.

Prerequisites/requirements: 
Cluster Autoscaler requires Kubernetes v1.3.0 or greater. 
kubectl is a command-line tool for interacting with Kubernetes clusters. You can install kubectl by following the steps in the Kubernetes documentation.
Connect to the EKS cluster by running aws eks update-kubeconfig –name <cluster name> This will update the kubectl configuration file with the necessary authentication credentials. 
## Prerequisites/requirements: 
Cluster Autoscaler requires Kubernetes v1.3.0 or greater.


Create OIDC Federated Authentication
OIDC federated authentication allows your service to assume an IAM role and interact with AWS services without having to store credentials as environment variables. Create an IAM OIDC identity provider for your cluster with the AWS Management Console using the documentation 
`kubectl` is a command-line tool for interacting with Kubernetes clusters. You can install **kubectl** by following the steps in the Kubernetes documentation [Install and Set up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).

Create a policy 

Create an IAM role for your service accounts in the console.
Connect to the EKS cluster by running `aws eks update-kubeconfig –name <cluster name>`. This will update the kubectl configuration file with the necessary authentication credentials. 

## Permissions
Cluster Autoscaler requires the ability to examine and modify EC2 Auto Scaling
Groups. It is recommended to use [IAM roles for Service
Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
to associate the Service Account that the Cluster Autoscaler Deployment runs as
with an IAM role that is able to perform these functions. 

### IAM policy

The following policy provides the minimum privileges necessary for Cluster Autoscaler to run. You must pass the following arguments to the Cluster Autoscaler binary, replacing min and max node counts and the ASG:

```bash
--aws-use-static-instance-list=false
--nodes=1:100:exampleASG1
--nodes=1:100:exampleASG2
```

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
				"ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
```

### Create OIDC Federated Authentication
OIDC federated authentication allows your service to assume an IAM role and interact with AWS services without having to store credentials as environment variables. For an example of how to use AWS IAM OIDC with the Cluster Autoscaler please see [here](CA_with_AWS_IAM_OIDC.md).


Retrieve the OIDC issuer URL from the Amazon EKS console description of your cluster. It will look something identical to: 'https://oidc.eks.us-east-1.amazonaws.com/id/xxxxxxxxxx'
While creating a new IAM role, In the "Select type of trusted entity" section, choose "Web identity".
In the "Choose a web identity provider" section: For Identity provider, choose the URL for your cluster. For Audience, type sts.amazonaws.com.
In the "Attach Policy" section, select the policy to use for your service account, that you created in the second step
In the "Attach Policy" section, select the policy to use for your service account, that you created in the previous step.
After the role is created, choose the role in the console to open it for editing.
Choose the "Trust relationships" tab, and then choose "Edit trust relationship". Edit the OIDC provider suffix and change it from :aud to :sub. Replace sts.amazonaws.com to your service account ID.
Update trust policy to finish.


Deploy the cluster autoscaler cluster-autoscaler-updated.v3.yaml 
### Create and Deploy the cluster autoscaler config file. 
In this case cluster-autoscaler-updated.v3.yaml 


## Test the autoscaler: 
Check if cluster autoscaler is in running state by running: `kubectl get pods -n kube-system`


Run `kubectl get nodes` - to check how many nodes are currently running 


Create a deployment, for example `kubectl create deployment <name> –image=nginx` 


Scale it up. Example: `kubectl scale deployment <name> –replicas=5`


Test the autoscaler: 
Check if cluster autoscaler is in running state by running: kubectl get pods -n kube-system
Run kubectl get nodes - to check how many nodes are currently running 
Create a deployment, for example kubectl create deployment <name> –image=nginx 
Scale it up. Example: kubectl scale deployment <name> –replicas=5
Run kubectl get nodes again to check if the number of nodes increased 
Run `kubectl get nodes` again to check if the number of nodes increased.
