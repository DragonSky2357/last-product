import { PostReview } from './../../review/entities/post-review.entity';
import { Cart } from './../../cart/entities/cart.entity';
import { Order } from './../../order/entities/order.entity';
import { Product } from '../../product/entities/product';

import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  email: string;

  @Column()
  password: string;

  @Column({ unique: true })
  nickname: string;

  @Column()
  phone: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @OneToMany(() => Order, (order) => order.order_user)
  orders: Order[];

  @OneToOne(() => Cart)
  @JoinColumn()
  cart: Cart;

  @OneToMany(() => PostReview, (postReview) => postReview.id)
  post_review: PostReview[];
}
