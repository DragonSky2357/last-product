import { Transform } from 'class-transformer';
import { IsDate, IsNotEmpty, IsNumber, IsString } from 'class-validator';
import { Double } from 'typeorm';

export class CreateStoreDto {
  @IsNotEmpty({ message: '상호명을 입력해주세요' })
  @IsString()
  store_name: string;

  @IsNotEmpty({ message: '상호 설명을 입력해주세요' })
  @IsString()
  description: string;

  @IsNotEmpty({ message: '사업자 등록번호를 입력해주세요' })
  @IsString()
  business_registration_number: string;

  @IsNotEmpty({ message: '주소를 입력해주세요' })
  @IsString()
  address: string;

  @IsNotEmpty({ message: '위도를 입력해주세요' })
  @IsNumber()
  @Transform(({ value }) => parseFloat(value))
  latitude: number;

  @IsNotEmpty({ message: '경도를 입력해주세요' })
  @IsNumber()
  @Transform(({ value }) => parseFloat(value))
  longitude: number;

  @IsNotEmpty({ message: '오픈 시간을 입력해주세요' })
  @IsDate()
  @Transform(({ value }) => new Date(value))
  open_time: Date;

  @IsNotEmpty({ message: '마감 시간을 입력해주세요' })
  @IsDate()
  @Transform(({ value }) => new Date(value))
  close_time: Date;

  @IsNotEmpty({ message: '마감 시간을 입력해주세요' })
  @IsDate()
  @Transform(({ value }) => new Date(value))
  start_break_time: Date;

  @IsNotEmpty({ message: '마감 시간을 입력해주세요' })
  @Transform(({ value }) => new Date(value))
  @IsDate()
  end_break_time: Date;
}
