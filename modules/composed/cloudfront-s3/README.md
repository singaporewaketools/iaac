# CloudFront S3 Root

A very opinionated module for a static website hosted on S3, deployed through AWS Keys and served through CloudFront

for an input `dns_zone` of "example.com", this module will:

- Create ACM for host names: `["example.com","www.example.com"]` in us-east-1 Region (required for CloudFront to work)
- Create an S3 bucket to host the static site
- Create AWS Access Keys with permissions to push to the s3 bucket
- Create CloudFront distribution with TLS with the s3 bucket as origin
- Create Route53 Alias records for `["example.com","www.example.com"]` pointing to the CF Distribution

TODO:

- Currently this module is very opinionated for a specific use case and needs to be broken down
- Logging to the DataDog s3 logging bucket should be an optional configuration so we can easily enabled/disable it on demand
- This module is very strict in naming resources, this causes problems when importing manually created resources
  Refer to the `datadog-integration` module to see how we can relax the naming conventions to import manually created resources
