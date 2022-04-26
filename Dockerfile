FROM public.ecr.aws/lambda/nodejs:12 as builder

ARG APP_PATH=/var/app
# Create app directory
WORKDIR $APP_PATH

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

FROM public.ecr.aws/lambda/nodejs:12

WORKDIR /var/app

COPY --from=builder /var/app ./

CMD [ "dist/lambda.handler"]

# remove unused dependencies
# RUN rm -rf node_modules/rxjs/src/
# RUN rm -rf node_modules/rxjs/bundles/
# RUN rm -rf node_modules/rxjs/_esm5/
# RUN rm -rf node_modules/rxjs/_esm2015/
# RUN rm -rf node_modules/swagger-ui-dist/*.map
# RUN rm -rf node_modules/couchbase/src/