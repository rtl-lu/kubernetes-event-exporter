#########################
# BUILD
#########################
FROM golang:1.18 AS builder

ADD . /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux GO11MODULE=on go build -a -o /main .


#########################
# PRODUCTION
#########################
FROM gcr.io/distroless/static:nonroot AS prod
LABEL org.opencontainers.image.source https://github.com/rtl-lu/kubernetes-event-exporter
COPY --from=builder --chown=nonroot:nonroot /main /kubernetes-event-exporter

USER nonroot

ENTRYPOINT ["/kubernetes-event-exporter"]


#########################
# Vulnerability scanning
#########################
FROM prod as scan
COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy filesystem --exit-code 1 --severity CRITICAL --no-progress /
