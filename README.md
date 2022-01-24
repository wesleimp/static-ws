# static-ws

Serve static content

## Usage

`static-ws` is focused in serve SPA applications (Angular, React) with routing. It's useful when you need to clustering you frontend application 

```shell
static-ws path/to/dist
```

By default, the server will start at port `8080`, but you can use the `-p` flag and change it accordingly you need.

## Install

### Manually

Download the pre-compiled binaries from the [OSS releases page](https://github.com/wesleimp/static-ws/releases) and copy them to the desired location.

### Running with Docker

You can also use it within a Docker container. To do that, you'll need to execute something like the examples below.

```shell
docker run --rm --privileged wesleimp/static-ws /path/to/dist/
```

### Compiling from source

If you just want to build from source for whatever reason, follow these steps:

**clone**

```shell
git clone git@github.com:wesleimp/static-ws
cd static-ws
```

**dependencies**

```shell
go mod tidy # or make deps
```

**build**

```shell
go build -o bin/static-ws . # or make build
```

**verify it works**

```shell
./bin/static-ws -h
```

## LICENSE

[MIT](./LICENSE)
