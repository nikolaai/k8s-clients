# Use the Alpine Linux base image
FROM alpine:3.18

# Install the required packages (curl, kubectl, and helm)
RUN apk --no-cache add curl bash openssl

# Create a new user named "runner" with UID 1000
RUN adduser -D -u 1000 runner

# Set the kubectl version using a build argument
ARG KUBECTL_VERSION

# get latest stable patch version for KUBECTL_VERSION

# Download and install kubectl
RUN LATEST_PATCH_KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable-$KUBECTL_VERSION.txt) \
    && curl -LO "https://dl.k8s.io/release/${LATEST_PATCH_KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh

# Switch to the "runner" user
USER runner

# Set the working directory to the home directory of the "runner" user
WORKDIR /home/runner

# Set the default command (you can change this as needed)
CMD ["/bin/sh"]