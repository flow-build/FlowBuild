FROM node:12.19.1 as Builder

WORKDIR /admin

COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json

RUN npm install
RUN npm rebuild

RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN npm prune --production


# real image
FROM node:12.19.1-slim as App

WORKDIR /admin

COPY --from=Builder /admin/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /admin/node_modules/.bin:$PATH

COPY  ./packages/admin/src ./src
COPY  ./packages/admin/db ./db
RUN rm -rf /admin/**/__tests__

COPY ./package.json /admin/package.json
COPY ./package-lock.json /admin/package-lock.json


ENTRYPOINT ["node", "/admin/src/index.js"]
