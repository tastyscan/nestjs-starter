import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { FastifyServerOptions, FastifyInstance, fastify } from 'fastify';

export async function bootstrap(): Promise<FastifyInstance> {
  const serverOptions: FastifyServerOptions = {
    logger: true,
  };
  const instance: FastifyInstance = fastify(serverOptions);
  const nestApp = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter(instance),
  );
  nestApp.setGlobalPrefix('api');
  await nestApp.init();
  return instance;
}
