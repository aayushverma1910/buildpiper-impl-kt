terraform {
  backend "s3" {
    bucket         = "buildpiper-impl-kt"
    key            = "buildpiper-impl-kt/module/buildpiper-eks-vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "buildpiper-tf-lock-table"
    encrypt        = true
  }
}