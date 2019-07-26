FROM golang:1.12-alpine as builder
ENV GOOS=linux
ENV CGO_ENABLED=0
ENV GOARCH=amd64
WORKDIR /build
COPY . .
RUN go build -mod=vendor -ldflags "-w -s" -o drone-sonar cmd/drone-sonar/main.go

FROM wzshiming/upx as upx
WORKDIR /build
COPY --from=builder /build/drone-sonar ./drone-sonar-origin
RUN upx --best --lzma -o drone-sonar drone-sonar-origin

FROM openjdk:8-jre-alpine
ARG SONAR_VERSION=3.3.0.1492
ARG SONAR_SCANNER_CLI=sonar-scanner-cli-${SONAR_VERSION}
ARG SONAR_SCANNER=sonar-scanner-${SONAR_VERSION}
RUN apk add --no-cache --update nodejs curl
COPY --from=upx /build/drone-sonar /bin/
WORKDIR /bin
RUN curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_SCANNER_CLI}.zip -so /bin/${SONAR_SCANNER_CLI}.zip
RUN unzip ${SONAR_SCANNER_CLI}.zip \
    && rm ${SONAR_SCANNER_CLI}.zip \
    && apk del curl
ENV PATH $PATH:/bin/${SONAR_SCANNER}/bin
ENTRYPOINT /bin/drone-sonar
