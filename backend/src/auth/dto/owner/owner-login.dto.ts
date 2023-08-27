import { IsNotEmpty, MinLength } from 'class-validator';

export class OwnerLoginDto {
  @IsNotEmpty({ message: '이메일을 입력해주세요.' })
  email: string;

  @IsNotEmpty({ message: '비밀번호를 입력해주세요.' })
  @MinLength(6, { message: '비밀번호를 최소 6자 이상을 입력해주세요' })
  password: string;
}
