FROM jenkins/jenkins:$JENKINS_VERSION
USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https \
  ca-certificates curl \
  gnupg gnupg2 \
  software-properties-common \
  lsb-release \
  apt-utils

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce-cli

RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  chmod +x kubectl && mv kubectl /usr/local/bin/kubectl


USER jenkins
