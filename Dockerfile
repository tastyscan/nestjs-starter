FROM node:16-alpine as builder

ENV NODE_ENV build
# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm ci
# If you are building your code for production
# RUN npm ci --only=production
COPY . .

RUN npm run build \
    && npm prune --production

# ---

FROM node:12-alpine

COPY --from=builder /usr/src/app/ ./

CMD [ "node", "dist/main" ]