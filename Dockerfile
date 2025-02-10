FROM golang:1.23-alpine3.21 AS builder

RUN go install github.com/mrxk/jlv@main

FROM alpine:3.21.2

COPY --from=builder /go/bin/jlv /usr/local/bin/jlv

RUN apk update
RUN apk add  vim && \
    apk add jq && \
    apk add bash && \
    apk add ca-certificates && \
    apk add curl && \
    adduser --disabled-password k9s k9s

ARG TARGETPLATFORM="amd64"
ARG KUBECTL_VERSION="v1.32.1"
RUN curl -L https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETPLATFORM}/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

ARG K9S_VERSION="v0.32.7"
RUN curl -L https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${TARGETPLATFORM#linux/}.tar.gz -o /tmp/k9s.tar.gz && \
    tar -C /tmp -xzf /tmp/k9s.tar.gz && \
    mv /tmp/k9s /usr/local/bin/k9s && \
    chmod +x /usr/local/bin/k9s

RUN rm -f /var/cache/apk/* && \
    rm -f /tmp/*

ENV COLORTERM=truecolor
ENV EDITOR=vim
COPY dotfiles/vimrc /home/k9s/.vimrc
COPY dotfiles/vimrc.pager /home/k9s/.vimrc.pager
COPY plugins/plugins.yaml /home/k9s/.config/k9s/plugins.yaml
RUN chown -R k9s:k9s /home/k9s/.*
USER k9s
ENTRYPOINT ["/usr/local/bin/k9s"]
