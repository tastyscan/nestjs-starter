/* eslint-disable @typescript-eslint/no-var-requires */
import {
  Context,
  APIGatewayProxyEvent,
  APIGatewayProxyResult,
} from 'aws-lambda';
import { bootstrap } from './app';

import { FastifyInstance } from 'fastify';
const awsLambdaFastify = require('aws-lambda-fastify');

let cashedFastifyServer: FastifyInstance;
let cachedProxy;

export const handler = async (
  event: APIGatewayProxyEvent,
  context: Context,
): Promise<APIGatewayProxyResult> => {
  if (!cashedFastifyServer) {
    cashedFastifyServer = await bootstrap();
  }
  if (!cachedProxy) {
    cachedProxy = awsLambdaFastify(cashedFastifyServer, {
      decorateRequest: true,
    });
    await cashedFastifyServer.ready();
  }
  return cachedProxy(event, context);
};
