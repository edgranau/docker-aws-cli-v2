# docker-aws-cli-v2

This is an expansion of the [Official Docker](https://github.com/docker-library/docker/blob/0bab8e3d0ebe6dc4b7a122bb1d0b2e017925c50d/19.03/Dockerfile) image to be used in a Gitlab CI/CD environment where the pipeline jobs need to build node-based docker images and publish them to ECR and / or running other AWS CLI commands.

The following tools have been added:

- [aws-cli-v2](https://github.com/aws/aws-cli)
- [amazon-ecr-credential-helper](https://github.com/awslabs/amazon-ecr-credential-helper)
- [Node.js + npm](https://nodejs.org/en/)
- [jq](https://stedolan.github.io/jq/)

References:

- <https://stackoverflow.com/a/61268529/13161796>