import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Post } from './../../post/entities/post.entity';

@Entity()
export class Category {
  @Column({ primary: true, unique: true, name: 'category_name' })
  category_name: string;

  @Column()
  category_image: string;

  @OneToMany(() => Post, (post) => post.category, {
    eager: true,
  })
  posts: Post[];
}
