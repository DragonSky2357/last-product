import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Req,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { CategoryService } from './category.service';
import { AuthGuard } from '@nestjs/passport';
import { FileInterceptor } from '@nestjs/platform-express';
import { CreateCategoryDto } from './dto/create-category';

@Controller('category')
export class CategoryController {
  constructor(private readonly categoryService: CategoryService) {}

  @Get()
  async findAllCategory() {
    return this.categoryService.findAllCategory();
  }

  @Get(':category')
  async getCategory(@Param('category') category: string) {
    return this.categoryService.getCategory(category);
  }

  @Post()
  @UseGuards(AuthGuard('jwt'))
  @UseInterceptors(FileInterceptor('image'))
  async createCategory(
    @Req() request,
    @Body() createPostDto: CreateCategoryDto,
    @UploadedFile() image: Express.MulterS3.File,
  ) {
    return this.categoryService.createCategory(request, createPostDto, image);
  }

  @Patch(':category')
  async updateCategory(@Param('category') categoryName: string) {
    //return this.categoryService.updateCategory();
  }

  @Delete(':category')
  async deleteCategory(@Param('category') category: string) {
    return this.categoryService.deleteCategory(category);
  }
}
