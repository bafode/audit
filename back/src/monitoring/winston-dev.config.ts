import * as winston from 'winston';

export const devWinstonConfig: winston.LoggerOptions = {
  level: 'debug',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.colorize(),
    winston.format.printf(({ timestamp, level, message, context, ...meta }) => {
      const contextStr = context ? `[${context}] ` : '';
      const metaStr = Object.keys(meta).length ? ` ${JSON.stringify(meta)}` : '';
      return `${timestamp} ${level}: ${contextStr}${message}${metaStr}`;
    }),
  ),
  transports: [
    // Console pour le développement
    new winston.transports.Console({
      level: 'debug',
    }),
  ],
};
