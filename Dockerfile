FROM public.ecr.aws/lambda/nodejs:latest as development

ARG APP_PATH=${LAMBDA_TASK_ROOT}
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

RUN npm run build

# ---

FROM public.ecr.aws/lambda/nodejs:latest as production

WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=development ${LAMBDA_TASK_ROOT}/package*.json ./

RUN npm ci --only=production

COPY --from=development ${LAMBDA_TASK_ROOT}/dist ./dist/

CMD [ "dist/lambda.handler"]