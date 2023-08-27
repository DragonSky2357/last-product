import { Transform, Type } from 'class-transformer';
import { IsDate, IsNotEmpty, IsNumber, IsString } from 'class-validator';
import { CreateDateColumn, UpdateDateColumn } from 'typeorm';

export class CreateProductDto {
  @IsNotEmpty()
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  capacity: number;

  @IsNotEmpty()
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  fixed_price: number;

  @IsNotEmpty()
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  sale_price: number;

  @IsDate()
  @IsNotEmpty()
  @Transform(({ value }) => new Date(value))
  manufacture_date: Date;

  @IsDate()
  @IsNotEmpty()
  @Transform(({ value }) => new Date(value))
  expiration_date: Date;
}
