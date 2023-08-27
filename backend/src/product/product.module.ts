import { AuthModule } from './../auth/auth.module';
import { User } from './../auth/entities/user.entity';
import { ConfigService, ConfigModule } from '@nestjs/config';
import { Module } from '@nestjs/common';
import { ProductController } from './product.controller';
import { ProductService } from './product.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Product } from './entities/product';
import { MulterModule } from '@nestjs/platform-express';
import { multerOptionsFactory } from '../common/utils/multer.options';

@Module({
  imports: [
    TypeOrmModule.forFeature([Product, User]),
    MulterModule.registerAsync({
      imports: [ConfigModule],
      useFactory: multerOptionsFactory,
      inject: [ConfigService],
    }),
    AuthModule,
  ],
  controllers: [ProductController],
  providers: [ProductService],
  exports: [ProductService],
})
export class ProductModule {}
