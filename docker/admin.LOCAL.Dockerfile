FROM node:12.14.1 as Builder

WORKDIR /admin

COPY ./packages/admin/package.json ./package.json
COPY ./packages/admin/yarn.lock ./yarn.lock

RUN yarn install

# real image
FROM node:12.14.1-slim as App

WORKDIR /admin

COPY --from=Builder /admin/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /admin/node_modules/.bin:$PATH

COPY  ./packages/admin/src ./src
COPY  ./packages/admin/generators ./generators
COPY  ./packages/admin/public ./public
COPY  ./packages/admin/.jest ./.jest
COPY  ./packages/admin/.babelrc ./.babelrc
RUN rm -rf /admin/**/__tests__

COPY  ./packages/admin/.babelrc ./.babelrc

COPY  ./packages/admin/.editorconfig ./.editorconfig
COPY  ./packages/admin/.eslintignore ./.eslintignore
COPY  ./packages/admin/.eslintrc.json ./.eslintrc.json
COPY  ./packages/admin/.prettierrc ./.prettierrc
COPY  ./packages/admin/.prettierignore ./.prettierignore
COPY  ./packages/admin/.stylelintrc.json ./.stylelintrc.json

COPY  ./packages/admin/jsconfig.json ./jsconfig.json
COPY  ./packages/admin/jest.config.js ./jest.config.js

COPY  ./packages/admin/craco.config.js ./craco.config.js

COPY  ./packages/admin/.env.development ./.env.development
COPY  ./packages/admin/.env.local ./.env.local

COPY ./packages/admin/package.json ./package.json
COPY ./packages/admin/package-lock.json ./package-lock.json


ENTRYPOINT ["npm", "start"]
