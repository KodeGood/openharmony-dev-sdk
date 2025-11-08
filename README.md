# docker-openharmony

To build the Dockerfile:

```bash
docker build -t openharmony-dev-sdk:latest .
```

To run the container:

```bash
docker run -it -v $(pwd):/home/openharmony -v "$HOME/.gitconfig:/root/.gitconfig:ro" openharmony-dev-sdk:latest
```
```

