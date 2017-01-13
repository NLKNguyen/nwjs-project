nwjs-project

// Work In Progress

## Build locally
```sh
docker build -t nwjs-project .
```

## Run local build

At NW.js project

```sh
docker run --rm -it -v $(pwd):/mnt nwjs-project

docker run --rm -it -v $(pwd):/mnt nwjs-project --package="linux-x64 win-x64 osx-x64" --name="my-app"
```
