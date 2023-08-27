import { OwnerLoginDto } from './dto/owner/owner-login.dto';
import { SuccessStatus, FailedStatus } from './../common/status/response';
import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';

import { UserLoginDto } from './dto/user/user-login.dto';
import { UserSignupDto } from './dto/user/user-signup.dto';
import { OwnerSignupDto } from './dto/owner/owner-signup.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/user/signup')
  async signUpUser(
    @Body() userSignupDto: UserSignupDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    return this.authService.signUpUser(userSignupDto);
  }

  @Post('/user/login')
  async loginUser(
    @Body() userLoginDto: UserLoginDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    return this.authService.loginUser(userLoginDto);
  }

  @Post('/owner/signup')
  async signUpOwner(
    @Body() ownerSignupDto: OwnerSignupDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    return this.authService.ownerSignUpOwner(ownerSignupDto);
  }

  @Post('/owner/login')
  async loginOwner(
    @Body() ownerLoginDto: OwnerLoginDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    return this.authService.ownerLoginOwner(ownerLoginDto);
  }
}
