FROM node:12.13.0 AS builder
WORKDIR /usr/src/app
COPY package.json ./
COPY yarn.lock ./
COPY nodemon.json ./
COPY tsconfig.json ./
COPY ./src/ ./src/
RUN yarn install --quiet && yarn run build

# Production stage.
# This state compile get back the JavaScript code from builder stage
# It will also install the production package only
#
FROM node:12.13.0-alpine

WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN yarn install --quiet --only=production

## We just need the build to execute the command
COPY --from=builder /usr/src/app/build ./build