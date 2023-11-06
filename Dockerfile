FROM mcr.microsoft.com/azure-cli
WORKDIR /tmp

# Get latest Terraform version and local architecture
RUN curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1' > version.txt
RUN arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/ > arch.txt

# Download and install relevant Terraform package
RUN echo $release
RUN wget https://releases.hashicorp.com/terraform/$(cat version.txt)/terraform_$(cat version.txt)_linux_$(cat arch.txt).zip
RUN unzip terraform_$(cat version.txt)_linux_$(cat arch.txt).zip
RUN mv terraform /usr/bin/terraform

# Set up Kubernetes tools
RUN az aks install-cli
RUN git clone https://github.com/ahmetb/kubectx kubectx
RUN apk add ncurses
RUN mv kubectx/kubectx /usr/bin/kct
RUN mv kubectx/kubens /usr/bin/kns

# Timesaver aliases
RUN /bin/bash -c "echo \"alias k='kubectl'\" >> /root/.bashrc"
RUN /bin/bash -c "echo \"alias ti='terraform init'\" >> /root/.bashrc"
RUN /bin/bash -c "echo \"alias tp='terraform plan -refresh=true -out=terraform.tfplan'\" >> /root/.bashrc"
RUN /bin/bash -c "echo \"alias ta='terraform apply terraform.tfplan'\" >> /root/.bashrc"
RUN /bin/bash -c "echo \"alias to='terraform output'\" >> /root/.bashrc"
RUN /bin/bash -c "echo \"alias tr='rm -rf .terraform terraform.tfstate* terraform.tfplan .terraform.lock.hcl'\" >> /root/.bashrc"

WORKDIR /code
ENTRYPOINT ["/bin/bash"]
