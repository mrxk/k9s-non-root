FROM derailed/k9s:v0.27.4

RUN apk add vim
RUN apk add jq
RUN apk add bash
RUN adduser --disabled-password k9s k9s
ENV EDITOR=vim
COPY dotfiles/vimrc /home/k9s/.vimrc
COPY dotfiles/vimrc.pager /home/k9s/.vimrc.pager
COPY plugins/plugin.yml /home/k9s/.config/k9s/plugin.yml
RUN chown k9s:k9s /home/k9s/.* /home/k9s/.config/k9s /home/k9s/.config/k9s/.* /home/k9s/.config/k9s/*
USER k9s
