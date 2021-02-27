FROM node:12.19.1 as Builder

WORKDIR /mission-control-api

COPY ./packages/mission-control-api/package.json ./package.json
COPY ./packages/mission-control-api/package-lock.json ./package-lock.json

RUN npm install
RUN npm rebuild

# real image
FROM node:12.19.1-slim as App

WORKDIR /mission-control-api

COPY --from=Builder /mission-control-api/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /mission-control-api/node_modules/.bin:$PATH

COPY  ./packages/mission-control-api/src ./src
COPY  ./packages/mission-control-api/db ./db
RUN rm -rf /mission-control-api/**/__tests__

COPY ./packages/mission-control-api/package.json ./package.json
COPY ./packages/mission-control-api/package-lock.json ./package-lock.json


ENTRYPOINT ["node", "/mission-control-api/src/index.js"]
