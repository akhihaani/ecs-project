# Project Overview
Overview of the setup

Project strucuture (Repo structure)

# Architecture Diagram
(Draw.io)

What to include:
- VPC
- Subnets (+ Three AZs clearly labeled (eu-west-2a/b/c))
- ALB
- ECS
- ECR
- ACM
- Cloudflare → Route53 NS delegation (the subdomain handoff)
- Two scopes side-by-side: bootstrap (S3 state, DynamoDB lock, Route53 zone, ECR repo OIDC provider + IAM role) vs infra (VPC, ALB, ECS, ACM, etc.)
- GitHub Actions → OIDC → IAM role trust relationship (label as OIDC, no static keys)
- The data flow: user → Cloudflare DNS → Route53 → ALB → ECS task in private container
- Security groups as boundaries (ALB SG and ECS SG) — usually shown as dashed boxes around resources
- The two S3 buckets: state bucket and ALB logs bucket
- The CloudWatch log group the container writes to


# Reproduction Instructions
the dense part. Walk through bootstrap → NS records in Cloudflare → infra apply → CI/CD.
Be honest about what's manual.

This is the section reviewers actually read carefully. Don't gloss over:
- AWS account prerequisites — must own a registered domain (you have abuniyyah.uk), have AWS CLI configured locally for bootstrap.
- The Cloudflare NS step is manual. Be explicit: after bootstrap apply, copy the 4 nameservers from outputs into Cloudflare. Without this step the cert never validates.
- Bootstrap is local, infra is CI. Document the split.
- The ECR import on first run. If someone else clones this and terraform applys bootstrap, ECR doesn't exist for them — so the import step isn't needed. (Or is it? If their account had an old memos repo from elsewhere... worth noting.)
- The cert validation can take 10-15 minutes on first apply. Set expectations.

(Also how to set up locally)

## APP Demo Video

# Screenshots
Once everything is documented, you know exactly what to capture: ECS console, AWS, CI runs, the live site with HTTPS padlock.

Screenshots of successful deployment and app running live on AWS via domain

SC of pipeline succeses