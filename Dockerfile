FROM derailed/k9s

RUN apk add vim && \
    apk add jq && \
    apk add bash && \
    adduser --disabled-password k9s k9s
ENV EDITOR=vim
COPY dotfiles/vimrc /home/k9s/.vimrc
COPY dotfiles/vimrc.pager /home/k9s/.vimrc.pager
COPY plugins/plugin.yml /home/k9s/.config/k9s/plugin.yml
RUN chown k9s:k9s /home/k9s/.* /home/k9s/.config/k9s /home/k9s/.config/k9s/.* /home/k9s/.config/k9s/*
USER k9s
