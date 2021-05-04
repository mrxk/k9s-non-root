FROM derailed/k9s

RUN adduser --disabled-password k9s k9s

USER k9s

