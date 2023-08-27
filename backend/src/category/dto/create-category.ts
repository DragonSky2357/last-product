import { Transform } from 'class-transformer';
import { IsJSON, IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CreateCategoryDto {
  @IsNotEmpty({ message: '카테고리명을 입력해주세요' })
  @IsString()
  category_name: string;
}
