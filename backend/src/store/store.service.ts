import { AuthService } from './../auth/auth.service';
import { HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Store } from './entities/store.entity';
import { Repository } from 'typeorm';
import { SuccessStatus, FailedStatus } from './../common/status/response';
import { CreateStoreDto } from './dto/create-store-dto';
import { Request } from 'express';

import { UpdateStoreDto } from './dto/update-store.dto';

@Injectable()
export class StoreService {
  constructor(
    @InjectRepository(Store) private storeRepository: Repository<Store>,

    private authService: AuthService,
  ) {}

  async findAllStore(): Promise<SuccessStatus<Store[]> | FailedStatus> {
    try {
      const findStores = await this.storeRepository.find();

      return {
        statusCode: HttpStatus.OK,
        data: findStores,
      };
    } catch (e) {}
  }

  async findStoreById(
    storeId: number,
  ): Promise<SuccessStatus<Store> | FailedStatus> {
    try {
      const findStores = await this.storeRepository.findOne({
        where: { id: storeId },
        loadEagerRelations: false,
      });

      return {
        statusCode: HttpStatus.OK,
        data: findStores,
      };
    } catch (e) {}
  }

  async findStoreByTitle(
    storeName: string,
  ): Promise<SuccessStatus<Store[]> | FailedStatus> {
    try {
      const findStore = await this.storeRepository
        .createQueryBuilder('store')
        //.leftJoinAndSelect('store.store_detail', 'store_detail')
        .where('store.store_name like :storeName', {
          storeName: `%${storeName}%`,
        })
        .getMany();

      return {
        statusCode: HttpStatus.OK,
        data: findStore,
      };
    } catch (e) {}
  }

  async createStore(
    request: Request,
    createStoreDto: CreateStoreDto,
    image: Express.MulterS3.File,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    const { store_name, description, ...detailStore } = createStoreDto;
    const ownerEmail = request.user['email'];

    try {
      const owner = await this.authService.findOwnerByEmail(ownerEmail);

      const store = this.storeRepository.create({
        image: image.location,
        ...createStoreDto,
      });
      await this.storeRepository.insert(store);

      owner.store = store;
      await this.authService.ownerUpdate(owner);

      return {
        statusCode: HttpStatus.CREATED,
        message: '상점 생성 완료',
      };
    } catch (e) {}
  }

  async updateStore(store: Store): Promise<SuccessStatus<null> | FailedStatus> {
    return null;
  }

  async deleteStore(
    storeId: string,
  ): Promise<SuccessStatus<null> | FailedStatus> {
    return;
  }
}
