FROM node:12.19.1 as Builder

WORKDIR /observer-api

COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json

RUN npm install
RUN npm rebuild

RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN npm prune --production


# real image
FROM node:12.19.1-slim as App

WORKDIR /observer-api

COPY --from=Builder /observer-api/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /observer-api/node_modules/.bin:$PATH

COPY  ./src /observer-api/src
RUN rm -rf /observer-api/**/__tests__

COPY ./package.json /observer-api/package.json
COPY ./package-lock.json /observer-api/package-lock.json


ENTRYPOINT ["node", "/observer-api/src/index.js"]
