import { Product } from './../product/entities/product';
import { CategoryService } from './../category/category.service';
import { StoreService } from './../store/store.service';
import { ProductService } from './../product/product.service';
import { AuthService } from './../auth/auth.service';
import { SuccessStatus, FailedStatus } from './../common/status/response';
import { HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from './entities/post.entity';
import { EntityManager, Repository } from 'typeorm';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { Request } from 'express';

@Injectable()
export class PostService {
  constructor(
    @InjectRepository(Post) private postRepository: Repository<Post>,
    private readonly entityManager: EntityManager,
    private authService: AuthService,
    private productService: ProductService,
    private storeService: StoreService,
    private categoryService: CategoryService,
  ) {}

  async findAllPosts(
    postCount: number,
    orderBy: string,
    order: string,
  ): Promise<SuccessStatus<Post[]> | FailedStatus> {
    console.log(postCount, orderBy, order);
    try {
      const findPosts = await this.postRepository.find({
        select: {
          id: true,
          title: true,
          description: true,
          image: true,
          created_at: true,
          product: {
            capacity: true,
            fixed_price: true,
            sale_price: true,
          },
          store: {
            id: true,
            store_name: true,
          },
        },
        take: postCount,
        order: {
          [orderBy]: order,
        },
        relations: ['product', 'store'],
        loadEagerRelations: false,
      });

      return {
        statusCode: HttpStatus.OK,
        data: findPosts,
      };
    } catch (e) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        error: e.message,
      };
    }
  }

  async findPostById(
    postId: string,
  ): Promise<SuccessStatus<Post> | FailedStatus> {
    try {
      const findPost = await this.postRepository.findOne({
        where: { id: postId },
        select: {
          id: true,
          title: true,
          description: true,
          image: true,
          created_at: true,
          product: {
            capacity: true,
            fixed_price: true,
            sale_price: true,
            manufacture_date: true,
            expiration_date: true,
          },
          store: {
            id: true,
            store_name: true,
            address: true,
            latitude: true,
            longitude: true,
          },
        },
        relations: {
          product: true,
          store: true,
        },
        loadEagerRelations: false,
      });

      return {
        statusCode: HttpStatus.OK,
        data: findPost,
      };
    } catch (e) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        error: e.message,
      };
    }
  }

  async findPostByTitle(
    postTitle: string,
  ): Promise<SuccessStatus<Post[]> | FailedStatus> {
    console.log(postTitle);
    const findPosts = await this.postRepository
      .createQueryBuilder('post')
      .where('post.title like :title', { title: `%${postTitle}%` })
      .getMany();

    return {
      statusCode: HttpStatus.OK,
      data: findPosts,
    };
  }

  async createPost(
    request: Request,
    createPostDto: CreatePostDto,
    image: Express.MulterS3.File,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    const ownerEmail = request.user['email'];

    try {
      const owner = await this.authService.findOwnerByEmail(ownerEmail);

      const product = new Product({
        ...createPostDto.product,
      });

      const store = await owner.store;

      const post = new Post({
        image: image ? image.location : null,
        ...createPostDto,
        product,
        store,
        owner,
      });

      await this.entityManager.save(post);

      return { statusCode: HttpStatus.CREATED, message: '포스트 생성 완료' };
    } catch (e) {
      console.log(e);
      return {
        statusCode: HttpStatus.FORBIDDEN,
        error: e.message,
      };
    }
  }

  async updatePost(
    request: Request,
    postId: string,
    updatePostDto: UpdatePostDto,
    image: Express.MulterS3.File,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    const ownerEmail = request.user['email'];
    try {
      const owner = await this.authService.findOwnerByEmail(ownerEmail);

      if (!owner) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: '존재 하지 유저 입니다.',
        };
      }

      const findPost = await this.postRepository.findOne({
        where: { id: postId, owner: { id: owner.id } },
        relations: ['product'],
      });

      if (!findPost) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: '존재 하지 않은 포스트입니다.',
        };
      }

      const { title, description, ...product } = updatePostDto;

      await this.postRepository.update(
        { id: postId },
        { title, description, image: image.location },
      );
      await this.productService.update(findPost.product.id, product);

      return { statusCode: HttpStatus.OK };
    } catch (e) {
      return {
        statusCode: e.message,
      };
    }
  }

  async deletePost(
    request: Request,
    postId: string,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    const ownerEmail = request.user['email'];
    try {
      const owner = await this.authService.findOwnerByEmail(ownerEmail);

      if (!owner) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: '존재 하지 유저 입니다.',
        };
      }

      const findPost = await this.postRepository.find({
        where: { id: postId, owner: { id: owner.id } },
        relations: ['product'],
      });

      await this.postRepository.softRemove(findPost);

      return {
        statusCode: HttpStatus.OK,
        message: '성공적으로 삭제하였습니다.',
      };
    } catch (e) {}
  }
}
