# Terraform for EKS


## Install terraform
> Please refer to [terraform install doc](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## AWS AccessKey Pair
```bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```


## Deploy s3
### S3 configuration
Note: You need to config them in the service modules manually

```bash
cd services/global/s3
terraform init
terraform plan
terraform apply -auto-approve
```

## Deploy eks
```bash
cd services/eks
terraform init
terraform plan
terraform apply -auto-approve "-var=region=eu-west-1"
```

## Deploy nodegroup
```bash
cd services/nodegroup
terraform init
terraform plan
terraform apply -auto-approve "-var=region=eu-west-1"
```

> You can define parameters about instance_types, disk_size and scaling_config.

## Support efs (optional)

### Deploy efs
```bash
cd services/efs
terraform init
terraform plan
terraform apply -auto-approve "-var=region=eu-west-1"
```

### Install eksctl
> Please refer to [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

### Create efs policy

```bash
curl -o iam-policy-example.json https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.3.2/docs/iam-policy-example.json

aws iam create-policy \
  --policy-name AmazonEKS_EFS_CSI_Driver_Policy \
  --policy-document file://iam-policy-example.json

eksctl create iamserviceaccount \
  --name efs-csi-controller-sa \
  --namespace kube-system \
  --cluster tf-eks-cluster \
  --attach-policy-arn arn:aws:iam::${accountID}:policy/AmazonEKS_EFS_CSI_Driver_Policy \
  --approve \
  --override-existing-serviceaccounts \
  --region ${region}
```

### CSI Driver

```bash
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
  --namespace kube-system \
  --set image.repository=602401143452.dkr.ecr.ap-southeast-1.amazonaws.com/eks/aws-efs-csi-driver \
  --set controller.serviceAccount.create=false \
  --set controller.serviceAccount.name=efs-csi-controller-sa
```

### Storage Class Manifest
```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: tf-efs-sc
provisioner: efs.csi.aws.com
parameters:
  provisioningMode: efs-ap
  fileSystemId: ${fileSystemId}
  directoryPerms: "700"
  gidRangeStart: "1000" # optional
  gidRangeEnd: "2000" # optional
  basePath: "/dynamic_provisioning" # optional
volumeBindingMode: WaitForFirstConsumer
```
