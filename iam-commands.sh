#!/bin/bash

# ===== AWS IAM Automation Script =====
# This script creates IAM groups, attaches policies,
# creates a Lambda execution role with a trust policy,
# creates a test user, and adds the user to a group.
# =====================================

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting IAM provisioning..."

# Create Developer group and attach AmazonS3FullAccess policy
echo "Creating Developers group and attaching AmazonS3FullAccess policy..."
aws iam create-group --group-name Developers
aws iam attach-group-policy --group-name Developers --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

# Create QA group and attach AmazonEC2ReadOnlyAccess policy
echo "Creating QA group and attaching AmazonEC2ReadOnlyAccess policy..."
aws iam create-group --group-name QA
aws iam attach-group-policy --group-name QA --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess

# Create Lambda execution role with trust policy
echo "Creating LambdaDynamoDBRole with trust policy..."
aws iam create-role --role-name LambdaDynamoDBRole --assume-role-policy-document file://trust-policy.json

# Attach DynamoDB full access to Lambda role
echo "Attaching AmazonDynamoDBFullAccess policy to LambdaDynamoDBRole..."
aws iam attach-role-policy --role-name LambdaDynamoDBRole --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess

# Create a test user and add to Developers group
echo "Creating test user LAB-WORK and adding to Developers group..."
aws iam create-user --user-name LAB-WORK
aws iam add-user-to-group --user-name LAB-WORK --group-name Developers

echo "IAM provisioning completed successfully!"
