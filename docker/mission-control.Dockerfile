FROM node:12.19.1 as Builder

WORKDIR /mission-control-api

COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json

RUN npm install
RUN npm rebuild

RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN npm prune --production


# real image
FROM node:12.19.1-slim as App

WORKDIR /mission-control-api

COPY --from=Builder /mission-control-api/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /mission-control-api/node_modules/.bin:$PATH

COPY  ./src /mission-control-api/src
RUN rm -rf /mission-control-api/**/__tests__

COPY ./package.json /mission-control-api/package.json
COPY ./package-lock.json /mission-control-api/package-lock.json


ENTRYPOINT ["node", "/mission-control-api/src/index.js"]
