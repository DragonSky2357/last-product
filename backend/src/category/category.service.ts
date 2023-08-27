import { HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Category } from './entities/category.entity';
import { Repository } from 'typeorm';
import { FailedStatus, SuccessStatus } from './../common/status/response';
import { CreateCategoryDto } from './dto/create-category';

@Injectable()
export class CategoryService {
  constructor(
    @InjectRepository(Category)
    private categoryRepository: Repository<Category>,
  ) {}

  async findAllCategory(): Promise<SuccessStatus<Category[]> | FailedStatus> {
    try {
      const findCategorys = await this.categoryRepository.find({});

      return {
        statusCode: HttpStatus.OK,
        data: findCategorys,
      };
    } catch (e) {
      return {
        statusCode: HttpStatus.FORBIDDEN,
        error: e.message,
      };
    }
  }

  async getCategory(
    categoryName: string,
  ): Promise<SuccessStatus<Promise<Category>> | FailedStatus> {
    try {
      const findCategory = this.findCategory(categoryName);

      return {
        statusCode: HttpStatus.OK,
        data: findCategory,
      };
    } catch (e) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        error: e.message,
      };
    }
  }

  async findCategory(categoryName: string): Promise<Category> {
    try {
      const findCategory = await this.categoryRepository.findOne({
        where: { category_name: categoryName },
        relations: ['posts'],
      });

      return findCategory;
    } catch (e) {}
  }

  async createCategory(
    request: Request,
    createPostDto: CreateCategoryDto,
    image: Express.MulterS3.File,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    try {
      await this.categoryRepository.upsert(
        {
          category_name: createPostDto.category_name,
          category_image: image.location,
        },
        ['category_name'],
      );

      return {
        statusCode: HttpStatus.CREATED,
        message: `${createPostDto.category_name} 생성 완료`,
      };
    } catch (e) {
      return {
        statusCode: HttpStatus.FORBIDDEN,
        error: e.message,
      };
    }
  }

  async insertPostCategory(category: Category): Promise<any> {
    try {
      const a = await this.categoryRepository.update(
        {
          category_name: category.category_name,
        },
        {
          ...category,
        },
      );
      console.log(a);
    } catch (e) {
      console.log(e);
    }
  }

  deleteCategory(category: string) {
    throw new Error('Method not implemented.');
  }
}
