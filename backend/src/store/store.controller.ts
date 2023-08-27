import { AuthGuard } from '@nestjs/passport';
import { SuccessStatus, FailedStatus } from './../common/status/response';
import { Store } from './entities/store.entity';
import { StoreService } from './store.service';
import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  Req,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { CreateStoreDto } from './dto/create-store-dto';
import { UpdateStoreDto } from './dto/update-store.dto';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('store')
export class StoreController {
  constructor(private readonly storeService: StoreService) {}

  @Get()
  async findAll(): Promise<SuccessStatus<Store[]> | FailedStatus> {
    return this.storeService.findAllStore();
  }

  @Get('/search')
  async findStoreByStoreName(
    @Query('name') storeName: string,
  ): Promise<SuccessStatus<Store[]> | FailedStatus> {
    return this.storeService.findStoreByTitle(storeName);
  }

  @Get(':id')
  async findPostById(@Param('id') storeId: number) {
    return this.storeService.findStoreById(storeId);
  }

  @Post()
  @UseGuards(AuthGuard('jwt'))
  @UseInterceptors(FileInterceptor('image'))
  async createStore(
    @Req() request,
    @Body() createStoreDto: CreateStoreDto,
    @UploadedFile() image: Express.MulterS3.File,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    return this.storeService.createStore(request, createStoreDto, image);
  }

  @Patch(':id')
  @UseGuards(AuthGuard('jwt'))
  async update(
    @Param('id') storeId: string,
    @Body() updateStoreDto: UpdateStoreDto,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    //return this.storeService.updateStore(storeId, updateStoreDto);
    return null;
  }

  @Delete(':id')
  @UseGuards(AuthGuard('jwt'))
  async delete(
    @Param('id') storeId: string,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    return this.storeService.deleteStore(storeId);
  }
}
