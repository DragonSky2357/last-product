import { FileInterceptor } from '@nestjs/platform-express';
import { CreateProductDto } from './dto/product.dto';
import { Product } from './entities/product';
import { ProductService } from './product.service';
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  UseInterceptors,
  UploadedFile,
  Req,
  UseGuards,
  Query,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UpdateProductDto } from './dto/update-product.dto';

@Controller('product')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Get()
  async findAll(): Promise<Product[]> {
    return this.productService.findAll();
  }

  @Get('/search')
  async findPostByTitle(@Query('title') title: string): Promise<Product> {
    return this.productService.findByTitle(title);
  }
  @Get(':id')
  async findProductById(@Param('id') id: number): Promise<Product> {
    return this.productService.findOne(id);
  }

  @Post()
  @UseGuards(AuthGuard('jwt'))
  async createProduct(
    @Req() request,
    @Body() createProductDto: CreateProductDto,
  ): Promise<any> {
    return this.productService.createProduct(request, createProductDto);
  }

  @Put(':id')
  async update(
    @Param('id') id: number,
    @Body() product: UpdateProductDto,
  ): Promise<Product> {
    return this.productService.update(id, product);
  }

  @Delete(':id')
  async delete(@Param('id') id: string): Promise<void> {
    return this.productService.delete(id);
  }
}
