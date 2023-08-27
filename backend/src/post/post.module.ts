import { Product } from './../product/entities/product';
import { CategoryModule } from './../category/category.module';
import { StoreModule } from './../store/store.module';
import { ProductModule } from './../product/product.module';

import { AuthModule } from './../auth/auth.module';
import { AuthService } from './../auth/auth.service';
import { multerOptionsFactory } from './../common/utils/multer.options';
import { Module } from '@nestjs/common';
import { PostController } from './post.controller';
import { PostService } from './post.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Post } from './entities/post.entity';
import { MulterModule } from '@nestjs/platform-express';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
  imports: [
    TypeOrmModule.forFeature([Post, Product]),
    MulterModule.registerAsync({
      imports: [ConfigModule],
      useFactory: multerOptionsFactory,
      inject: [ConfigService],
    }),
    AuthModule,
    ProductModule,
    StoreModule,
    CategoryModule,
  ],
  controllers: [PostController],
  providers: [PostService],
})
export class PostModule {}
