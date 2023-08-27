import { Post } from './../../post/entities/post.entity';
import { Owner } from './../../auth/entities/owner.entity';
import { Product } from '../../product/entities/product';
import {
  Column,
  CreateDateColumn,
  Double,
  Entity,
  JoinColumn,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity()
export class Store {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  business_registration_number: string;

  @Column({ nullable: true })
  image: string;

  @Column()
  store_name: string;

  @Column()
  description: string;

  @Column()
  address: string;

  @Column({ nullable: true, type: 'double' })
  latitude: number;

  @Column({ nullable: true, type: 'double' })
  longitude: number;

  @Column()
  open_time: Date;

  @Column()
  close_time: Date;

  @Column()
  start_break_time: Date;

  @Column()
  end_break_time: Date;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @OneToOne(() => Owner)
  owner: Owner;

  @OneToMany(() => Post, (post) => post.store, { eager: true })
  post: Post[];

  @OneToMany(() => Product, (product) => product.store)
  product: Product[];
}
