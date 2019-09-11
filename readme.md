# Agnosticd runner

## Pre-requisites
Add the `.pem` file with the key to `ssh` subdir.

Build the container:

```bash
docker build -t "agnosticd-runner" .
```

Run the container:

```bash
docker run -it --rm -v $(pwd)/config:/opt/app-root/data -v $(pwd)/ssh:/opt/app-root/src/.ssh --entrypoint bash agnosticd-runner
```
