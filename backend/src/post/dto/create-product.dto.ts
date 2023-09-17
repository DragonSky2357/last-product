import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsDate, IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CreateProductDto {
  @ApiProperty({
    description: '재고 수량',
    example: '10',
  })
  @IsNotEmpty({ message: '재고 수량을 입력해주세요' })
  @Type(() => Number)
  @IsNumber()
  capacity: number;

  @ApiProperty({
    description: '판매 가격',
    example: '20000',
  })
  @IsNotEmpty({ message: '판매가를 입력해주세요' })
  @Type(() => Number)
  @IsNumber()
  fixed_price: number;

  @ApiProperty({
    description: '세일 가격',
    example: '15000',
  })
  @IsNotEmpty({ message: '세일 가격을 입력해주세요' })
  @Type(() => Number)
  @IsNumber()
  sale_price: number;

  @ApiProperty({
    description: '제조 일자',
    example: '2023-08-05',
  })
  @IsNotEmpty({ message: '제조 일자를 입력해주세요' })
  @Type(() => Date)
  @IsDate()
  manufacture_date: Date;

  @ApiProperty({
    description: '유통 기한',
    example: '2023-09-13',
  })
  @IsNotEmpty({ message: '유통 기한을 입력해주세요' })
  @Type(() => Date)
  @IsDate()
  expiration_date: Date;
}
