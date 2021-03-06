FROM renewdoit/docker-clj-build:1.1.2

# Install requirements

RUN apk add -U python
RUN apk add -U py-pip
RUN pip install jinja2
RUN pip install pyYAML

# Install kubectl
ENV KUBECTL_VERSION=v1.7.11
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl && \
  kubectl version --client

# Install deploy scripts
ENV PATH=/opt/kubernetes-deploy:$PATH
COPY / /opt/kubernetes-deploy/

ENTRYPOINT []
CMD []
