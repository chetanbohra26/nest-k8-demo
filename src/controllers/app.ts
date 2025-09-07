import { Controller, Get } from '@nestjs/common';
import { AppService } from '../services';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('health')
  getHealth() {
    return { success: true, message: 'App is running fine' };
  }

  @Get()
  getHello() {
    const message = this.appService.getHello();
    return { success: true, message };
  }
}
