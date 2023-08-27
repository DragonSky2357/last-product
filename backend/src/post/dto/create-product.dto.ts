import { Transform } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CreateProductDto {
  @IsNotEmpty({ message: '재고 수량을 입력해주세요' })
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  capacity: number;

  @IsNotEmpty({ message: '판매가를 입력해주세요' })
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  fixed_price: number;

  @IsNotEmpty({ message: '세일 가격을 입력해주세요' })
  @IsNumber()
  @Transform(({ value }) => parseInt(value))
  sale_price: number;

  @IsNotEmpty({ message: '제조 일자를 입력해주세요' })
  @IsString()
  manufacture_date: Date;

  @IsNotEmpty({ message: '유통 기한을 입력해주세요' })
  @IsString()
  expiration_date: Date;
}
