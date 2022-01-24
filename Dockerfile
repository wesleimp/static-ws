FROM golang:alpine

WORKDIR /app

COPY . .
RUN chmod +x ./entrypoint.sh

RUN go mod download
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -v -o static-ws .

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
