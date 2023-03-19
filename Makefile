deploy_autoscaler:
	kubectl apply -f cluster-autoscaler-updated.v3.yaml

destroy_autoscaler:
	kubectl delete -f cluster-autoscaler-updated.v3.yaml

create_IAM_policy:
	aws iam create-policy --policy-name k8s-asg-policy --policy-document file://k8s-asg-policy.json


