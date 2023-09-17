import { IsJSON, IsNotEmpty, IsObject, IsString } from 'class-validator';
import { CreateProductDto } from './create-product.dto';
import { ApiProperty } from '@nestjs/swagger';

export class CreatePostDto {
  @ApiProperty({
    required: true,
    description: '포스트 제목',
    example: '오늘 잡은 싱싱한 대방어 판매합니다.',
  })
  @IsNotEmpty({ message: '제목을 입력해주세요' })
  @IsString()
  title: string;

  @ApiProperty({
    description: '포스트 설명',
    example: '동해산 대방어 1kg 20000원을 15000원에 선착순 5명에게 판매합니다.',
  })
  @IsNotEmpty({ message: '글을 입력해주세요' })
  @IsString()
  description: string;

  @ApiProperty({
    required: true,
    description: '제품 정보',
    example: 'CreateProductDto',
  })
  @IsObject()
  @IsNotEmpty()
  product: CreateProductDto;
}
