# IAM - Identity and Access Management

## What is IAM?
IAM is the AWS service that decides who can log in and what they're allowed to do.
The way I think of it: AWS is a big office building and IAM is the security desk handing out ID cards.
It's global (not tied to a region) and it's free to use.

## Users
A user is one person or one app that needs access to AWS.
Each user can have a password (for the console) and/or access keys (for CLI / Terraform).
For this course I made a user called `AaditDhariwal` and Terraform uses its access keys.

## Groups
A group is just a bunch of users. You attach permissions to the group and every user inside gets them.
Example: a "developers" group with EC2 access, so new devs just get added to the group.
Groups can't be nested (no group inside a group).

## Roles
A role is like a temporary ID card that someone or something "puts on" when they need it.
No long-term password or keys, AWS hands out short-lived credentials instead.
Common case: an EC2 instance gets a role so the app on it can read S3 without storing keys on the server.

## Policies
A policy is a JSON document that lists what is allowed or denied.
Main parts: Effect (Allow/Deny), Action (like `s3:GetObject`), Resource (which ARN).
AWS managed policies (like `AmazonS3FullAccess`) are ready-made, customer managed ones you write yourself.

Small example - read-only access to just one bucket:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::my-notes-bucket",
        "arn:aws:s3:::my-notes-bucket/*"
      ]
    }
  ]
}
```

## Permissions
By default everything is denied. You only get what a policy explicitly allows.
An explicit Deny always wins over an Allow, even if another policy allows it.
So the order is basically: explicit deny > explicit allow > default deny.

## Least privilege
Give only the permissions needed for the job, nothing extra.
My `AaditDhariwal` user only has AmazonEC2FullAccess + AmazonS3FullAccess, not AdministratorAccess.
So even if the keys leak, someone can't go and delete IAM users or touch billing.

## IAM best practices
- Don't use the root account for daily work, lock it away with MFA turned on.
- Turn on MFA for real users too.
- Use roles instead of long-term access keys wherever possible.
- Never commit access keys to GitHub (use `aws configure` or env vars).
- Rotate keys and remove users/keys that aren't used anymore.
- Prefer groups over attaching policies directly to each user.

## Common use cases
- Giving each team member their own login instead of sharing one account.
- Letting Terraform / CI pipelines deploy stuff with limited keys.
- EC2 or Lambda reading from S3 / DynamoDB using a role.
- Cross-account access (one AWS account assuming a role in another).

Quick check of who I'm logged in as:

```bash
aws sts get-caller-identity
```

What I learned:
IAM is basically "who are you and what can you do". Users and groups are for people, roles are for services,
and policies are the actual rules. Start with nothing and only add what's needed.
