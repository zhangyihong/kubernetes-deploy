#FROM docker:latest
FROM renewdoit/docker-clj-build:1.1.2

# Install requirements
RUN apk add -U curl tar bash

ENV KUBECTL_VERSION=v1.7.11
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl && \
  kubectl version --client
  
# Install Helm
RUN curl https://kubernetes-helm.storage.googleapis.com/helm-v2.5.0-linux-amd64.tar.gz | \
 tar zx && mv linux-amd64/helm /usr/bin/ && \
 helm version --client


# Install deploy scripts
ENV PATH=/opt/kubernetes-deploy:$PATH
COPY / /opt/kubernetes-deploy/
RUN ln -s /opt/kubernetes-deploy/run /usr/bin/deploy && \
  which deploy && \
  which destroy
