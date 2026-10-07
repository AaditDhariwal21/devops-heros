# S3 - Simple Storage Service

## What is S3?
S3 is object storage. You throw files in and get them back over HTTP/API.
The way I think of it: an unlimited Google Drive for apps, not a disk you mount.
It's built for 99.999999999% (11 nines) durability, so losing data is very unlikely.

## Buckets
A bucket is the top-level container where files go.
Bucket names are globally unique across ALL AWS accounts, so `test` is already taken.
You pick a region when creating it (I use ap-southeast-2, Sydney - my AWS project only allows that region).
Lowercase letters, numbers, hyphens and dots only, 3-63 characters.

## Objects
An object = the file + its metadata. Each object has a key (basically the path/name).
There are no real folders, `images/cat.png` is just a key with a slash in it, the console shows it as a folder.
Max size of one object is 5 TB (big uploads use multipart upload).

## Storage classes
Pick based on how often you read the data:
- Standard - default, frequently accessed data.
- Intelligent-Tiering - AWS moves objects between tiers automatically based on usage.
- Standard-IA - infrequent access, cheaper storage but you pay per retrieval.
- One Zone-IA - like Standard-IA but only one AZ, cheaper, less resilient.
- Glacier Instant Retrieval - archive data you still need in milliseconds.
- Glacier Flexible Retrieval - archive, minutes to hours to get it back.
- Glacier Deep Archive - cheapest, retrieval takes up to ~12-48 hours.
- Express One Zone - super fast single-AZ storage for high performance workloads.

## Versioning
When on, S3 keeps every old version of an object instead of overwriting.
If you delete something it just adds a "delete marker", the old version is still there.
My Terraform state bucket has versioning on, so if the state file gets messed up I can roll back.
Once enabled you can only suspend it, not fully turn it off.

## Lifecycle policies
Rules that move or delete objects automatically after some days.
Example: move logs to Standard-IA after 30 days, Glacier after 90, delete after 365.
Saves money without doing it by hand.

## Encryption
Since Jan 2023 all new objects are encrypted at rest by default with SSE-S3 (AES256, keys managed by S3).
Other options: SSE-KMS (keys in KMS, more control + audit), DSSE-KMS, or client-side encryption.
In transit you use HTTPS. My Terraform bucket sets AES256 explicitly.

## Bucket policies
A JSON policy attached to the bucket itself (IAM policies attach to users/roles instead).
Used for things like allowing another account, or forcing HTTPS.
Block Public Access is on by default for new buckets, and I keep it on for my Terraform bucket.

Example - deny anything that's not over HTTPS:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyInsecureTransport",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::my-notes-bucket",
        "arn:aws:s3:::my-notes-bucket/*"
      ],
      "Condition": { "Bool": { "aws:SecureTransport": "false" } }
    }
  ]
}
```

## Common use cases
- Storing Terraform state files (remote backend).
- Backups and logs.
- Hosting static websites (HTML/CSS/JS).
- Images/videos for apps, data lake for analytics.

CLI commands I used:

```bash
aws s3 ls
aws s3 cp notes.txt s3://my-notes-bucket/notes.txt
aws s3 sync ./site s3://my-notes-bucket/site
```

What I learned:
S3 is storage for files (objects) inside buckets, not a normal disk. Versioning + encryption + blocking
public access is the safe default setup, and storage classes/lifecycle rules are how you keep it cheap.
