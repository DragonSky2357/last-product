import { StoreReview } from './review/entities/store-review.entity';
import { Post } from './post/entities/post.entity';
import { Category } from './category/entities/category.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProductModule } from './product/product.module';
import { Product } from './product/entities/product';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { User } from './auth/entities/user.entity';

import { JwtStrategy } from './auth/jwt/jwt.strategy';
import { PostModule } from './post/post.module';
import { OrderModule } from './order/order.module';
import { StoreModule } from './store/store.module';
import { CartModule } from './cart/cart.module';
import { CategoryModule } from './category/category.module';
import { Owner } from './auth/entities/owner.entity';
import { ReviewModule } from './review/review.module';
import { Order } from './order/entities/order.entity';
import { Cart } from './cart/entities/cart.entity';
import { Store } from './store/entities/store.entity';
import { PostReview } from './review/entities/post-review.entity';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'localhost',
      port: 3307,
      username: 'dragonsky',
      password: '235711',
      database: 'last_product',
      entities: [
        User,
        Owner,
        Product,
        Post,
        Order,
        Cart,
        Category,
        Store,
        PostReview,
        StoreReview,
      ], // 사용할 entity의 클래스명을 넣어둔다.
      synchronize: true,
    }),

    ProductModule,
    AuthModule,
    PostModule,
    OrderModule,
    StoreModule,
    CartModule,
    CategoryModule,
    ReviewModule,
  ],
  controllers: [AppController],
  providers: [AppService, JwtStrategy],
})
export class AppModule {}
