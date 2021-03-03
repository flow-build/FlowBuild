FROM node:12.19.1 as Builder

WORKDIR /workflow

COPY ./packages/workflow/package.json ./package.json
COPY ./packages/workflow/package-lock.json ./package-lock.json

RUN npm install
RUN npm rebuild

# real image
FROM node:12.19.1-slim as App

WORKDIR /workflow

COPY --from=Builder /workflow/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /workflow/node_modules/.bin:$PATH

COPY  ./packages/workflow/src ./src
COPY  ./packages/workflow/knexfiile.js ./knexfiile.js
COPY  ./packages/workflow/db ./db
RUN rm -rf /workflow/**/__tests__

COPY ./packages/workflow/package.json ./package.json
COPY ./packages/workflow/package-lock.json ./package-lock.json


ENTRYPOINT ["node", "/workflow/src/index.js"]
