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
import { PostService } from './post.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { AuthGuard } from '@nestjs/passport';

@Controller('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @Get()
  async findAllPosts(
    @Query('count') postCount,
    @Query('orderBy') orderBy,
    @Query('order') order,
  ) {
    return this.postService.findAllPosts(postCount, orderBy, order);
  }

  @Get('/search')
  async findPostByTitle(@Query('title') postTitle: string) {
    return this.postService.findPostByTitle(postTitle);
  }

  @Get(':id')
  async findPostById(@Param('id') postId: string) {
    return this.postService.findPostById(postId);
  }

  @Post('')
  @UseGuards(AuthGuard('jwt'))
  @UseInterceptors(FileInterceptor('image'))
  async createPost(
    @Req() request,
    @Body() createPostDto: CreatePostDto,
    @UploadedFile() image: Express.MulterS3.File,
  ) {
    return this.postService.createPost(request, createPostDto, image);
  }

  @Patch(':id')
  @UseGuards(AuthGuard('jwt'))
  @UseInterceptors(FileInterceptor('image'))
  async updatePost(
    @Req() request,
    @Param('id') postId: string,
    @Body() updatePostDto: UpdatePostDto,
    @UploadedFile() image: Express.MulterS3.File,
  ) {
    return this.postService.updatePost(request, postId, updatePostDto, image);
  }

  @Delete(':id')
  @UseGuards(AuthGuard('jwt'))
  async deletePost(@Req() request, @Param('id') postId: string) {
    return this.postService.deletePost(request, postId);
  }
}
