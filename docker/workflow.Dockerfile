FROM node:12.19.1 as Builder

WORKDIR /workflow

COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json

RUN npm install
RUN npm rebuild

RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN npm prune --production


# real image
FROM node:12.19.1-slim as App

WORKDIR /workflow

COPY --from=Builder /workflow/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /workflow/node_modules/.bin:$PATH

COPY  ./packages/workflow/src ./src
COPY  ./packages/mission-control-api/db ./db
RUN rm -rf /workflow/**/__tests__

COPY ./package.json /workflow/package.json
COPY ./package-lock.json /workflow/package-lock.json


ENTRYPOINT ["node", "/workflow/src/index.js"]
