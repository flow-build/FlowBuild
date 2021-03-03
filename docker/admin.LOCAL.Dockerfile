FROM node:12.14.1 as Builder

WORKDIR /admin

COPY ./packages/admin/package.json ./package.json
COPY ./packages/admin/package-lock.json ./package-lock.json
RUN npm install
RUN npm rebuild

# real image
FROM node:12.14.1-slim as App

WORKDIR /admin

COPY --from=Builder /admin/node_modules ./node_modules

# add `node_modules/.bin` to $PATH
ENV PATH /admin/node_modules/.bin:$PATH

COPY  ./packages/admin/src ./src
COPY  ./packages/admin/.storybook ./.storybook
COPY  ./packages/admin/.babelrc ./.babelrc
RUN rm -rf /admin/**/__tests__

COPY  ./packages/admin/.storybook ./.storybook
COPY  ./packages/admin/.babelrc ./.babelrc

COPY  ./packages/admin/.editorconfig ./.editorconfig
COPY  ./packages/admin/.eslintignore ./.eslintignore
COPY  ./packages/admin/.eslintrc.json ./.eslintrc.json
COPY  ./packages/admin/.nvmrc ./.nvmrc
COPY  ./packages/admin/.stylelintrc.json ./.stylelintrc.json

COPY  ./packages/admin/webpack.dev.js ./webpack.dev.js
COPY  ./packages/admin/webpack.common.js ./webpack.common.js
COPY  ./packages/admin/jsconfig.json ./jsconfig.json
COPY  ./packages/admin/jest.config.js ./jest.config.js
COPY  ./packages/admin/setup-tests.js ./setup-tests.js


COPY ./packages/admin/package.json ./package.json
COPY ./packages/admin/package-lock.json ./package-lock.json


ENTRYPOINT ["npm", "start"]
