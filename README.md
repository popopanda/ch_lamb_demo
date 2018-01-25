[![CircleCI](https://circleci.com/gh/popopanda/ch_lamb_demo.svg?style=svg)](https://circleci.com/gh/popopanda/ch_lamb_demo)

# Playground
CH Demo

# Goal
Provide a demo that satisfies requirements and demonstrate skills

## How is it provisioned?
- Terraform provisions VPC and initial setup run of Fargate through ECS.
- Provisions ALB in front of chhello Fargate container

## CI/CD
- CI/CD is ran through CircleCI

Build:
- Builds image from dockerfile in master branch
- Push docker image to docker hub

Test1:
- Runs docker container from image built
- Curls localhost to check a return of 200

Test2:
- Checks for terraform format

Deploy:
- Deploys image into Fargate

### Modules
VPC
Fargate through ECS
ALB

### Providers
AWS/us-east-1/ch_lamb_demo
