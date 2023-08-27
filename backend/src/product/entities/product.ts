import { Store } from './../../store/entities/store.entity';
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  OneToOne,
  JoinColumn,
  DeleteDateColumn,
} from 'typeorm';

import { Post } from './../../post/entities/post.entity';

@Entity()
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  capacity: number;

  @Column()
  fixed_price: number;

  @Column()
  sale_price: number;

  @Column()
  manufacture_date: Date;

  @Column()
  expiration_date: Date;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @DeleteDateColumn()
  deletedAt: Date | null;

  @OneToOne(() => Post, (post) => post.product)
  post: Post;

  @ManyToOne(() => Store, (store) => store.product)
  store: Store;

  constructor(product: Partial<Product>) {
    Object.assign(this, product);
  }
}
