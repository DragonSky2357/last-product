import { AuthService } from './../auth/auth.service';
import { User } from './../auth/entities/user.entity';
import { BadRequestException, HttpStatus, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Product } from './entities/product';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateProductDto } from './dto/product.dto';
import { Request } from 'express';
import { UpdateProductDto } from './dto/update-product.dto';

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product) private productRepository: Repository<Product>,
    private authService: AuthService,
  ) {}

  async findAll(): Promise<Product[]> {
    return this.productRepository.find({ relations: ['user'] });
  }

  async findOne(id: number): Promise<Product> {
    return this.productRepository.findOne({ where: { id } });
  }

  async findByTitle(title: string): Promise<any> {
    const findProducts = await this.productRepository
      .createQueryBuilder('product')
      .where('product.title like :title', { title: `%${title}%` })
      .orWhere('product.description like :description', {
        description: `%${title}%`,
      })
      .getMany();

    return {
      statusCode: HttpStatus.OK,
      data: findProducts,
    };
  }
  async createProduct(
    request: Request,
    createProductDto: CreateProductDto,
  ): Promise<any> {
    const ownerEmail = request.user['email'];

    const product = this.productRepository.create({
      ...createProductDto,
    });

    const saveProduct = await this.productRepository.save(product);

    return saveProduct;
  }

  async update(
    id: number,
    updateProductDto: UpdateProductDto,
  ): Promise<Product> {
    await this.productRepository.update(id, updateProductDto);
    return this.productRepository.findOne({ where: { id } });
  }

  async delete(id: string): Promise<void> {
    await this.productRepository.delete(id);
  }
}
