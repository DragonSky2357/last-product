import { Transform } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';
import { UpdateProductDto } from './update-product.dto';

export class UpdatePostDto {
  @IsString()
  @IsOptional()
  title: string;

  @IsString()
  @IsOptional()
  description: string;

  // @IsString()
  // @IsOptional()
  // category: string;

  @IsOptional()
  product: UpdateProductDto;
}
