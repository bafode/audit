import { Injectable } from '@nestjs/common';

@Injectable()
export class LoggerService {
  constructor() {}

  error(message: string, trace?: string, context?: string) {
    console.error(`[ERROR] ${context ? `[${context}] ` : ''}${message}`, trace ? `\nTrace: ${trace}` : '');
  }

  warn(message: string, context?: string) {
    console.warn(`[WARN] ${context ? `[${context}] ` : ''}${message}`);
  }

  info(message: string, context?: string) {
    console.log(`[INFO] ${context ? `[${context}] ` : ''}${message}`);
  }

  debug(message: string, context?: string) {
    console.debug(`[DEBUG] ${context ? `[${context}] ` : ''}${message}`);
  }

  verbose(message: string, context?: string) {
    console.log(`[VERBOSE] ${context ? `[${context}] ` : ''}${message}`);
  }

  // Méthodes spécifiques pour l'application F1
  logUserAction(userId: string, action: string, details?: any) {
    this.info(`User action: ${action}`, 'UserAction');
    console.log(`[USER_ACTION] User: ${userId}, Action: ${action}`, details);
  }

  logBetPlaced(userId: string, betId: string, grandPrixId: string) {
    this.info('Bet placed', 'BetService');
    console.log(`[BET_PLACED] User: ${userId}, Bet: ${betId}, GrandPrix: ${grandPrixId}`);
  }

  logLeagueActivity(userId: string, leagueId: string, activity: string) {
    this.info(`League activity: ${activity}`, 'LeagueService');
    console.log(`[LEAGUE_ACTIVITY] User: ${userId}, League: ${leagueId}, Activity: ${activity}`);
  }

  logDatabaseQuery(query: string, duration: number, success: boolean) {
    this.debug('Database query executed', 'DatabaseService');
    console.log(`[DB_QUERY] Query: ${query.substring(0, 100)}, Duration: ${duration}ms, Success: ${success}`);
  }

  logApiCall(endpoint: string, method: string, statusCode: number, duration: number) {
    this.info('API call', 'ApiService');
    console.log(`[API_CALL] ${method} ${endpoint} - ${statusCode} (${duration}ms)`);
  }
}
