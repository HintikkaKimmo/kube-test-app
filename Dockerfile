# Use golang alpine3.7 image for build
FROM golang:1.10.0-alpine3.7
# Maintainer information
LABEL Maintainer="Kimmo Hintikka"
# set working directory to local source
WORKDIR /go/src/github.com/HintikkaKimmo/kube-test-app
# Copy kube-test-app to currect working directory
COPY kube-test-app.go .
# build golang binary from the app source
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o kube-test-app .


# Use Alpine 3.7 as base to mach the build face
FROM alpine:3.13.8
# Maintainer information
LABEL Maintainer="Kimmo Hintikka"
# Install ca-certificates for HTTPS connections
RUN apk --no-cache add ca-certificates
# Set working directory
WORKDIR /root/
# Copy binary from previous stage. --from=0 means the index of the build action
COPY --from=0 /go/src/github.com/HintikkaKimmo/kube-test-app/kube-test-app .
# Run the binary
CMD [ "./kube-test-app" ]