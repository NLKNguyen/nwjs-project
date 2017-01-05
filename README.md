nwjs-project

// Work In Progress

## Build
```sh
docker build -t nwjs-project .
```

## Run

At NW.js project

```sh
docker run --rm -it -v $(pwd):/mnt nwjs-project

docker run --rm -it -v $(pwd):/mnt nwjs-project --package="linux-x64 win-x64 osx-x64" --archive="true" --name="my-app"
```
