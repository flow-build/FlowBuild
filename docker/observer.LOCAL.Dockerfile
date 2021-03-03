FROM node:12.19.1 as Builder

WORKDIR /observer-api

COPY ./packages/observer-api/package.json ./package.json
COPY ./packages/observer-api/package-lock.json ./package-lock.json

RUN npm install
RUN npm rebuild

# real image
FROM node:12.19.1-slim as App

WORKDIR /observer-api

COPY --from=Builder /observer-api/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /observer-api/node_modules/.bin:$PATH

COPY  ./packages/observer-api/src ./src
RUN rm -rf /observer-api/**/__tests__

COPY ./packages/observer-api/package.json ./package.json
COPY ./packages/observer-api/package-lock.json ./package-lock.json


ENTRYPOINT ["node", "/observer-api/src/index.js"]
