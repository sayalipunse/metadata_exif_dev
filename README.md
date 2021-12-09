## About The Project

This repository creates one source bucket A, a destination bucket B, and a Lambda function in python 3 that will clean exif metadata from the source bucket image and save in the destination bucket.

### Prerequisites

Please run below cmd in order to install terraform switch which will be usefull to install, run and switch any terraform version on your local machine. Please note, this cmd is use only on Mac and Linux machine.

* [tfswitch]
```sh
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
```

### Installation

1. Install the prerequisites as mentioned above
2. Clone the repository & review and if needed edit the variables.tf file:
   
   ```sh
   git clone https://github.com/sayalipunse/metadata_exif_dev.git
   vi provider.tf
   ```
    edit this block to reflect your configuration:
   ```sh
     provider "aws" {
    profile = "default" --> change this to your aws profile name"
    ...
    }
   ```

3. Initialize Terraform
   
   ```sh
   terraform init
   ```

4. Terraform Plan
   
   ```sh
   terraform plan
   ```

5. Terraform Apply to create mentioned resources

   ```sh
   terraform apply
   ```

6. After terraform apply you might want to test a file upload, please use the command below:
   
   ```sh
   terraform apply -var image_test=true -auto-approve
   terraform output a_user
   terraform output b_user
   ```
   this test upload will happen using the aws profile used by terraform, you can configure your AWS CLI with the users access_key secret to try with the user a and b

7. You can test the users after configuring the users in your aws cli:

   ```sh
   #USER A
   aws s3 --profile a_user --region us-east-1 ls s3://my-bucket-s3-a
   aws s3 --profile a_user --region us-east-1 cp s3://my-bucket-s3-a/test/my_test.jpg .
   aws s3 --profile a_user --region us-east-1 cp my_test.jpg s3://my-bucket-s3-a/test/my_test.jpg
   aws s3 --profile a_user --region us-east-1 ls s3://my-bucket-s3-b --> This will give you
   AccessDenied error as user a only has read/write access to bucket A

   #USER B
   aws s3 --profile b_user --region us-east-1 ls s3://my-bucket-s3-b
   aws s3 --profile b_user --region us-east-1 cp s3://my-bucket-s3-b/test/my_test.jpg .
   aws s3 --profile b_user --region us-east-1 cp my_test.jpg s3://my-bucket-s3-b --> This will give you
   AccessDenied error as user b only has read access to bucket B
   ```

9. (Optional) Once you're done and happy with your testing, you can destroy all the resources by executing below cmd:

   ```sh
   terraform destroy -auto-approve
   ```

## License

Distributed under the GNU GENERAL PUBLIC LICENSE

## Author

Name: Sayali Punse
Email Address: sayali.punse@hotmail.com
