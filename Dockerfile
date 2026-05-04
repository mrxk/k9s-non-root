FROM golang:1.26-alpine3.23 AS builder

RUN go install github.com/mrxk/jlv@v1.0.10
RUN go install github.com/charmbracelet/gum@latest

FROM alpine:3.23

COPY --from=builder /go/bin/jlv /usr/local/bin/jlv
COPY --from=builder /go/bin/gum /usr/local/bin/gum

RUN apk update
RUN apk add --no-cache \
    vim \
    jq \
    bash \
    ca-certificates \
    curl
RUN adduser --disabled-password k9s k9s

ARG TARGETPLATFORM="amd64"
ARG KUBECTL_VERSION="v1.36.0"
RUN curl -L https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETPLATFORM}/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

ARG K9S_VERSION="v0.50.18"
RUN curl -L https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${TARGETPLATFORM#linux/}.tar.gz -o /tmp/k9s.tar.gz && \
    tar -C /tmp -xzf /tmp/k9s.tar.gz && \
    mv /tmp/k9s /usr/local/bin/k9s && \
    chmod +x /usr/local/bin/k9s

ARG KUBELOGIN_VERSION="v0.2.17"
RUN curl -L https://github.com/Azure/kubelogin/releases/download/${KUBELOGIN_VERSION}/kubelogin-linux-${TARGETPLATFORM#linux/}.zip -o /tmp/kubelogin.zip && \
    unzip -d /tmp /tmp/kubelogin.zip && \
    mv /tmp/bin/linux_${TARGETPLATFORM}/kubelogin /usr/local/bin/kubelogin && \
    chmod +x /usr/local/bin/kubelogin

RUN apk add --no-cache python3 py3-pip
RUN python3 -m venv /.venv && \
    source /.venv/bin/activate && \
    pip3 install azure-cli

RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

ENV COLORTERM=truecolor
ENV EDITOR=vim
COPY dotfiles/vimrc /home/k9s/.vimrc
COPY dotfiles/vimrc.pager /home/k9s/.vimrc.pager
COPY plugins/plugins.yaml /home/k9s/.config/k9s/plugins.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chown -R k9s:k9s /home/k9s/.* /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER k9s
ENTRYPOINT ["/entrypoint.sh"]
