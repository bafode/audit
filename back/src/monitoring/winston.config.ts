import * as winston from 'winston';
import * as DailyRotateFile from 'winston-daily-rotate-file';

const logFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.errors({ stack: true }),
  winston.format.json(),
  winston.format.printf(({ timestamp, level, message, stack, ...meta }) => {
    return JSON.stringify({
      timestamp,
      level,
      message,
      stack,
      ...meta,
    });
  })
);

export const winstonConfig: winston.LoggerOptions = {
  level: process.env.LOG_LEVEL || 'info',
  format: logFormat,
  defaultMeta: {
    service: 'p10-backend',
    environment: process.env.NODE_ENV || 'development',
  },
  transports: [
    // Console transport
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    }),
  ],
};
