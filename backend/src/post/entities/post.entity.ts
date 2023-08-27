import { Owner } from './../../auth/entities/owner.entity';
import { Category } from './../../category/entities/category.entity';
import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToOne,
  PrimaryColumn,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './../../auth/entities/user.entity';
import { Cart } from './../../cart/entities/cart.entity';
import { Store } from '../../store/entities/store.entity';
import { Product } from '../../product/entities/product';

@Entity()
export class Post {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column()
  description: string;

  @Column({ nullable: true })
  image: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @DeleteDateColumn()
  deletedAt: Date | null;

  @ManyToOne(() => Owner, (owner) => owner.posts)
  owner: Owner;

  @ManyToOne(() => Category, (category) => category.posts)
  category: Category;

  @OneToOne(() => Product, (product) => product.post, {
    cascade: true,
  })
  @JoinColumn()
  product: Product;

  @ManyToOne(() => Store)
  store: Store;

  @ManyToOne(() => Cart, (cart) => cart.post)
  cart: Cart;

  constructor(post: Partial<Post>) {
    Object.assign(this, post);
  }
}
