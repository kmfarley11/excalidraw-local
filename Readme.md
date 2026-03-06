# excalidraw-local

The contents here intend to memorialize how we may setup an excalidraw instance locally with collaboration services working in an offline setup.

The setup requires modification of the frontend image since it bakes in env vars instead of having runtime config options.

As-is, it doesn't support a backend storage service. To set such a thing up we'd probably need to clone & leverage the kiliandeca images instead of the official ones. Though they appear to be old and not highly-maintained.

Otherwise, we could fork the official excalidraw frontend ourselves and either propose updates to support runtime configs or similar.

## building & preparing for offline use

```bash
docker compose build excalidraw

docker compose images excalidraw --format json

IMG_REPO=$(docker compose images excalidraw --format json | jq '.[0].Repository')
IMG_TAG=$(docker compose images excalidraw --format json | jq '.[0].Tag')

docker save ${IMG_REPO}:${IMG_TAG} -o ./excalidraw.${IMG_TAG}.tar

./genkey.sh

tar -czvf -C ../ ./excalidraw-local.tar.gz ./excalidraw-local

ls -lh ../*tar*
```