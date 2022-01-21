FROM golang:alpine AS base
WORKDIR /app

# Go builder
FROM base as builder
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -v -o static-server main.go

FROM scratch as final
WORKDIR /app
COPY --from=builder /app/static-server /static-server

EXPOSE 8080
ENTRYPOINT ["./static-server"]
