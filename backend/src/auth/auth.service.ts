import { Store } from './../store/entities/store.entity';
import { OwnerLoginDto } from './dto/owner/owner-login.dto';
import {
  HttpException,
  HttpStatus,
  Injectable,
  Logger,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { SuccessStatus, FailedStatus } from './../common/status/response';
import { OwnerSignupDto } from './dto/owner/owner-signup.dto';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';

import * as bcrypt from 'bcrypt';
import { UserLoginDto } from './dto/user/user-login.dto';
import { JwtService } from '@nestjs/jwt';
import { UserSignupDto } from './dto/user/user-signup.dto';
import { Owner } from './entities/owner.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private userRepository: Repository<User>,
    @InjectRepository(Owner) private ownerRepository: Repository<Owner>,
    private jwtService: JwtService,
  ) {}

  async signUpUser(
    signupDto: UserSignupDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    const { email, password, nickname, phone } = signupDto;

    const findUserByEmail = await this.userRepository.findOne({
      where: { email },
    });

    if (findUserByEmail) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: '이미 존재하는 이메일 입니다.',
      };
    }

    const findUserByNickname = await this.userRepository.findOne({
      where: { nickname },
    });

    if (findUserByNickname) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: '이미 존재하는 닉네임 입니다.',
      };
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User();
    user.email = email;
    user.password = hashedPassword;
    user.nickname = nickname;
    user.phone = phone;

    await this.userRepository.save(user);

    return {
      statusCode: HttpStatus.CREATED,
    };
  }

  async loginUser(
    loginDto: UserLoginDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    const { email, password } = loginDto;

    try {
      const findUserByEmail = await this.userRepository.findOne({
        where: { email },
      });

      if (!findUserByEmail) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: '존재하지 않은 사용자 입니다.',
        };
      }

      const isCompare = await bcrypt.compare(
        password,
        findUserByEmail.password,
      );

      if (!isCompare) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: '비밀번호가 틀립니다.',
        };
      }

      const payload = { email: findUserByEmail.email };

      return {
        statusCode: HttpStatus.CREATED,
        data: this.jwtService.sign(payload),
      };
    } catch (error) {}
  }

  async ownerSignUpOwner(
    ownerSignupDto: OwnerSignupDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    const { email, password, phone } = ownerSignupDto;

    const findOwnerByEmail = await this.ownerRepository.findOne({
      where: { email },
    });

    if (findOwnerByEmail) {
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: '이미 존재하는 이메일 입니다.',
      };
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const owner = new Owner();
    owner.email = email;
    owner.password = hashedPassword;
    owner.phone = phone;

    await this.ownerRepository.save(owner);

    return {
      statusCode: HttpStatus.CREATED,
    };
  }

  async ownerLoginOwner(
    ownerLoginDto: OwnerLoginDto,
  ): Promise<SuccessStatus<String> | FailedStatus> {
    const { email, password } = ownerLoginDto;

    try {
      const findOwner = await this.ownerRepository.findOne({
        where: { email },
      });

      if (!findOwner) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: '존재하지 않은 사용자 입니다.',
        };
      }

      const isCompare = await bcrypt.compare(password, findOwner.password);

      if (!isCompare) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: '비밀번호가 틀립니다.',
        };
      }

      const payload = { email: findOwner.email };

      return {
        statusCode: HttpStatus.CREATED,
        data: this.jwtService.sign(payload),
      };
    } catch (error) {}
  }

  async findOwnerByEmail(email: string): Promise<Owner> {
    try {
      const owner = await this.ownerRepository.findOne({
        where: { email },
        relations: ['store'],
      });

      return owner;
    } catch (e) {}
  }

  async ownerUpdate(owner: Owner): Promise<any> {
    try {
      await this.ownerRepository.update(
        { id: owner.id },
        {
          ...owner,
        },
      );
    } catch (e) {}
  }
}
