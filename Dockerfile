# Use golang alpine3.7 image for build
FROM golang:1.10.0-1.10.0-alpine3.7
# set working directory to local source
WORKDIR /go/src/github.com/HintikkaKimmo/kube-test-app
# Copy kube-test-app to currect working directory
COPY kube-test-app.go .
# build golang binary from the app source
RUN CGO_ENABLED=0 GOOS=linux go build -a installsuffix cgo -o app .



# Use Alpine 3.7 as base to mach the build face
FROM alpine:3.7
# Install ca-certificates for HTTPS connections
RUN apk --no-cache add ca-certificates
# Set working directory
WORKDIR /root/
COPY --from=builder /go/src/github.com/HintikkaKimmo/kube-test-app .
# Run the binary
CMD [ "./app" ]