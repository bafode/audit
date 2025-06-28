import { Module, Global } from '@nestjs/common';
import { WinstonModule } from 'nest-winston';
import { LoggerService, MetricsService, MetricsController, winstonConfig } from './index';

@Global()
@Module({
  imports: [
  ],
  controllers: [MetricsController],
  providers: [
    LoggerService,
    MetricsService,
  ],
  exports: [
    LoggerService,
    MetricsService,
  ],
})
export class MonitoringModule {}
