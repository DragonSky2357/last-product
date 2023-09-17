import { SwaggerCustomOptions } from './../node_modules/@nestjs/swagger/dist/interfaces/swagger-custom-options.interface.d';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

export class BaseAPIDocument {
  public builder = new DocumentBuilder();

  public initializeOptions() {
    return this.builder
      .setTitle('떨이요 API')
      .setDescription('떨이요 API 문서')
      .setVersion('1.0.0')
      .addBearerAuth(
        {
          type: 'http',
          scheme: 'bearer',
          name: 'JWT',
          in: 'header',
        },
        'access-token',
      )

      .build();
  }
}
