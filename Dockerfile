FROM alpine:3.18.0

RUN apk update
RUN apk add  vim && \
    apk add jq && \
    apk add bash && \
    apk add ca-certificates && \
    apk add curl && \
    adduser --disabled-password k9s k9s

ARG KUBECTL_VERSION="v1.25.2"
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

ARG TARGETPLATFORM
RUN curl -L https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_${TARGETPLATFORM#linux/}.tar.gz -o /tmp/k9s.tar.gz && \
    tar -C /tmp -xzf /tmp/k9s.tar.gz && \
    mv /tmp/k9s /usr/local/bin/k9s && \
    chmod +x /usr/local/bin/k9s

RUN rm -f /var/cache/apk/* && \
    rm -f /tmp/*

ENV EDITOR=vim
COPY dotfiles/vimrc /home/k9s/.vimrc
COPY dotfiles/vimrc.pager /home/k9s/.vimrc.pager
COPY plugins/plugin.yml /home/k9s/.config/k9s/plugin.yml
RUN chown k9s:k9s /home/k9s/.* /home/k9s/.config/k9s /home/k9s/.config/k9s/.* /home/k9s/.config/k9s/*
USER k9s
ENTRYPOINT ["/usr/local/bin/k9s"]
