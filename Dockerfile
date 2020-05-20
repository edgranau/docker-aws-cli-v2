FROM golang:alpine AS helper
# get amazon-ecr-credential-helper
RUN apk add --no-cache --quiet git && go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

FROM docker:19

ENV GLIBC_VER=2.31-r0

# install glibc compatibility for alpine and install aws-cli-v2
RUN apk --no-cache add --quiet \
  binutils \
  curl \
  && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
  && apk add --no-cache \
  glibc-${GLIBC_VER}.apk \
  glibc-bin-${GLIBC_VER}.apk \
  && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
  && unzip awscliv2.zip \
  && aws/install \
  && rm -rf \
  awscliv2.zip \
  aws \
  /usr/local/aws-cli/v2/*/dist/aws_completer \
  /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
  /usr/local/aws-cli/v2/*/dist/awscli/examples \
  && apk --no-cache del \
  binutils \
  curl \
  && rm glibc-${GLIBC_VER}.apk \
  && rm glibc-bin-${GLIBC_VER}.apk \
  && rm -rf /var/cache/apk/*

# install nodejs and jq to support pipeline scripts
RUN apk --no-cache add nodejs npm jq
# install amazon-ecr-credential-helper
COPY --from=helper /go/bin/docker-credential-ecr-login /usr/local/bin
# configure docker to use amazon-ecr-credential-helper
RUN mkdir -p /root/.docker && echo '{ "credsStore": "ecr-login" }' > /root/.docker/config.json
# continue normal execution of official Docker image
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
