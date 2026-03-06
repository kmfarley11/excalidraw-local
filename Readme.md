# excalidraw-local

The contents here intend to memorialize how we may setup an excalidraw instance locally with collaboration services working in an offline setup.

The setup requires modification of the frontend image since it bakes in env vars instead of having runtime config options.

As-is, it doesn't support a backend storage service. To set such a thing up we'd probably need to clone & leverage the kiliandeca images instead of the official ones. Though they appear to be old and not highly-maintained.

Otherwise, we could fork the official excalidraw frontend ourselves and either propose updates to support runtime configs or similar.

## building & preparing for offline use

```bash
export ARTIFACTS_DIR=../out
mkdir -p ${ARTIFACTS_DIR}

docker compose build excalidraw

docker compose create excalidraw
docker compose images excalidraw --format json

export IMG_REPO=$(docker compose images excalidraw --format json | jq -r '.[0].Repository')
export IMG_TAG=$(docker compose images excalidraw --format json | jq -r '.[0].Tag')

docker save ${IMG_REPO}:${IMG_TAG} -o ${ARTIFACTS_DIR}/excalidraw.${IMG_TAG}.tar

./genkey.sh

tar --exclude='.git' -czvf ${ARTIFACTS_DIR}/excalidraw-local.tar.gz -C ../ ./excalidraw-local

ls -lh ${ARTIFACTS_DIR}
```