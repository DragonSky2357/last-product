import { Transform } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class UpdateProductDto {
  @IsOptional()
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  capacity: number;

  @IsOptional()
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  fixed_price: number;

  @IsOptional()
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  sale_price: number;

  @IsOptional()
  @IsString()
  manufacture_date: Date;

  @IsOptional()
  @IsString()
  expiration_date: Date;
}
