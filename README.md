# drone-sonar-plugin

The plugin of Drone CI to integrate with SonarQube (previously called Sonar), which is an open source code quality management platform.

Detail tutorials: [DOCS.md](DOCS.md).

## Build process

build go binary file:
`GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o drone-sonar cmd/drone-sonar/main.go`

build docker image
`docker build -t daixijun1990/drone-sonar .`

## Testing the docker image

```commandline
docker run --rm \
  -e DRONE_REPO=test \
  -e PLUGIN_SOURCES=. \
  -e SONAR_HOST=http://localhost:9000 \
  -e SONAR_TOKEN=60878847cea1a31d817f0deee3daa7868c431433 \
  daixijun1990/drone-sonar
```

## Pipeline example

```yaml
steps
  - name: code-analysis
    image: daixijun1990/drone-sonar
    settings:
      sonar_host:
        from_secret: sonar_host
      sonar_token:
        from_secret: sonar_token
```
