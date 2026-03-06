FROM node:18-bookworm AS build

WORKDIR /opt/node_app

RUN apt update && apt install --no-install-recommends -y git

ARG GIT_REF=v0.18.0
RUN git clone --branch ${GIT_REF} --depth=1 https://github.com/excalidraw/excalidraw.git .

# FROM THIS POINT ITS RELATIVELY THE SAME AS THE OFFICIAL DOCKERFILE
#   https://github.com/excalidraw/excalidraw/blob/v0.18.0/Dockerfile

# do not ignore optional dependencies:
# Error: Cannot find module @rollup/rollup-linux-x64-gnu
RUN yarn --network-timeout 600000

ARG PROTOCOL=http
ARG HOSTNAME=portal.excalidraw.localhost

# adjustables
ENV VITE_APP_WS_SERVER_URL=${PROTOCOL}://${HOSTNAME}
ENV VITE_APP_BACKEND_V2_GET_URL=${PROTOCOL}://${HOSTNAME}/api/v2/
ENV VITE_APP_BACKEND_V2_POST_URL=${PROTOCOL}://${HOSTNAME}/api/v2/post/
ENV VITE_APP_HTTP_STORAGE_BACKEND_URL=${PROTOCOL}://${HOSTNAME}/api/v2
# hardcodes to get this config to work. NOTE: 
ENV VITE_APP_STORAGE_BACKEND=http
ENV VITE_APP_FIREBASE_CONFIG={}

RUN yarn build:app:docker

FROM nginx:1.27-alpine

COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
