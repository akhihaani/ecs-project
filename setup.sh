#!/usr/bin/env bash
set -euo pipefail

# --- 1. Ask the porter for their 4 values ---
read -rp "AWS account ID: " ACCOUNT_ID
read -rp "AWS region (e.g. eu-west-2): " REGION
read -rp "Domain (e.g. memos.example.com): " DOMAIN
read -rp "GitHub repo (owner/repo): " REPO

# --- 2. The author's CURRENT values ---
OLD_ACCOUNT="310829530244"
OLD_REGION="eu-west-2"
OLD_DOMAIN="memos.abuniyyah.uk"
OLD_REPO="akhihaani/ecs-project"

# --- 3. Files that contain those literals ---
FILES=(
  bootstrap/terraform.tfvars
  infra/terraform.tfvars
  bootstrap/backend.tf.disabled
  infra/backend.tf
)

# --- 4. Swap old -> new in each file ---
for f in "${FILES[@]}"; do
  sed -i.bak \
    -e "s|${OLD_ACCOUNT}|${ACCOUNT_ID}|g" \
    -e "s|${OLD_REGION}|${REGION}|g" \
    -e "s|${OLD_DOMAIN}|${DOMAIN}|g" \
    -e "s|${OLD_REPO}|${REPO}|g" \
    "$f"
  rm "${f}.bak"
done

# --- 5. Set the GitHub Actions variables (derived from the same inputs) ---
ECR_REPO="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/memos"
gh variable set AWS_ACCOUNT_ID --body "$ACCOUNT_ID" --repo "$REPO"
gh variable set AWS_REGION     --body "$REGION"     --repo "$REPO"
gh variable set ECR_REPO       --body "$ECR_REPO"   --repo "$REPO"
gh variable set APP_DOMAIN     --body "$DOMAIN"     --repo "$REPO"

echo "Done. Review the changed files, then run terraform init/apply."