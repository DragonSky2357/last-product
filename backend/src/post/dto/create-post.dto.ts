import { Transform } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';
import { CreateProductDto } from './create-product.dto';

export class CreatePostDto {
  @IsNotEmpty({ message: '제목을 입력해주세요' })
  @IsString()
  title: string;

  @IsNotEmpty({ message: '글을 입력해주세요' })
  @IsString()
  description: string;

  // @IsNotEmpty()
  // @IsString()
  // category: string;

  @IsNotEmpty()
  product: CreateProductDto;
}
