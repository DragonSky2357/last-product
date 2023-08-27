import { Transform } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class UpdatePostDto {
  @IsString()
  @IsOptional()
  title: string;

  @IsString()
  @IsOptional()
  description: string;

  @IsString()
  @IsOptional()
  category: string;

  @IsNumber()
  @IsOptional()
  @Transform(({ value }) => parseInt(value))
  capacity: number;

  @IsNumber()
  @IsOptional()
  @Transform(({ value }) => parseInt(value))
  fixed_price: number;

  @IsNumber()
  @IsOptional()
  @Transform(({ value }) => parseInt(value))
  sale_price: number;

  @IsString()
  @IsOptional()
  manufacture_date: Date;

  @IsString()
  @IsOptional()
  expiration_date: Date;
}
