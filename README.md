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

6. After terraform apply you might want to test a file upload, please use the provided test image:
   Upload the provided image into source_s3 bucket either via aws console or aws cli cmd and you will get the image without exif metadata in the destination_s3 bucket.


9. (Optional) Once you're done and happy with your testing, you can destroy all the resources by executing below cmd:

   ```sh
   terraform destroy -auto-approve
   ```

## License

Distributed under the GNU GENERAL PUBLIC LICENSE

## Author

Name: Sayali Punse
Email Address: sayali.punse@hotmail.com
