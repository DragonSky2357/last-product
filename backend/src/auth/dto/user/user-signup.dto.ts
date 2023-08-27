import { IsNotEmpty, MinLength } from 'class-validator';

export class UserSignupDto {
  @IsNotEmpty({ message: '이메일을 입력해주세요.' })
  email: string;

  @IsNotEmpty({ message: '비밀번호를 입력해주세요.' })
  @MinLength(6, { message: '비밀번호를 최소 6자 이상을 입력해주세요' })
  password: string;

  @IsNotEmpty({ message: '이름을 입력해주세요.' })
  nickname: string;

  @IsNotEmpty({ message: '휴대폰 번호를 입력해주세요.' })
  phone: string;
}
