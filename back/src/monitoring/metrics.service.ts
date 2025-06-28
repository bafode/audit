import { Injectable } from '@nestjs/common';
import * as client from 'prom-client';

@Injectable()
export class MetricsService {
  private readonly register: client.Registry;
  
  // Métriques HTTP
  private readonly httpRequestDuration: client.Histogram<string>;
  private readonly httpRequestTotal: client.Counter<string>;
  private readonly httpRequestErrors: client.Counter<string>;
  
  // Métriques base de données
  private readonly dbQueryDuration: client.Histogram<string>;
  private readonly dbConnectionsActive: client.Gauge<string>;
  
  // Métriques métier F1
  private readonly activeBets: client.Gauge<string>;
  private readonly activeUsers: client.Gauge<string>;
  private readonly leagueActivity: client.Counter<string>;
  private readonly betPlaced: client.Counter<string>;
  
  // Métriques système
  private readonly memoryUsage: client.Gauge<string>;
  private readonly cpuUsage: client.Gauge<string>;

  constructor() {
    this.register = new client.Registry();
    
    // Métriques par défaut (CPU, mémoire, etc.)
    client.collectDefaultMetrics({ register: this.register });

    // Métriques HTTP
    this.httpRequestDuration = new client.Histogram({
      name: 'http_request_duration_seconds',
      help: 'Duration of HTTP requests in seconds',
      labelNames: ['method', 'route', 'status_code'],
      buckets: [0.1, 0.5, 1, 2, 5],
      registers: [this.register],
    });

    this.httpRequestTotal = new client.Counter({
      name: 'http_requests_total',
      help: 'Total number of HTTP requests',
      labelNames: ['method', 'route', 'status_code'],
      registers: [this.register],
    });

    this.httpRequestErrors = new client.Counter({
      name: 'http_request_errors_total',
      help: 'Total number of HTTP request errors',
      labelNames: ['method', 'route', 'error_type'],
      registers: [this.register],
    });

    // Métriques base de données
    this.dbQueryDuration = new client.Histogram({
      name: 'db_query_duration_seconds',
      help: 'Duration of database queries in seconds',
      labelNames: ['operation', 'table'],
      buckets: [0.01, 0.05, 0.1, 0.5, 1, 2],
      registers: [this.register],
    });

    this.dbConnectionsActive = new client.Gauge({
      name: 'db_connections_active',
      help: 'Number of active database connections',
      registers: [this.register],
    });

    // Métriques métier F1
    this.activeBets = new client.Gauge({
      name: 'f1_active_bets_total',
      help: 'Total number of active bets',
      labelNames: ['grand_prix'],
      registers: [this.register],
    });

    this.activeUsers = new client.Gauge({
      name: 'f1_active_users_total',
      help: 'Total number of active users',
      registers: [this.register],
    });

    this.leagueActivity = new client.Counter({
      name: 'f1_league_activity_total',
      help: 'Total league activities',
      labelNames: ['activity_type', 'league_id'],
      registers: [this.register],
    });

    this.betPlaced = new client.Counter({
      name: 'f1_bets_placed_total',
      help: 'Total number of bets placed',
      labelNames: ['grand_prix', 'user_id'],
      registers: [this.register],
    });

    // Métriques système
    this.memoryUsage = new client.Gauge({
      name: 'nodejs_memory_usage_bytes',
      help: 'Node.js memory usage in bytes',
      labelNames: ['type'],
      registers: [this.register],
    });

    this.cpuUsage = new client.Gauge({
      name: 'nodejs_cpu_usage_percent',
      help: 'Node.js CPU usage percentage',
      registers: [this.register],
    });

    // Mise à jour périodique des métriques système
    this.startSystemMetricsCollection();
  }

  // Méthodes pour les métriques HTTP
  recordHttpRequest(method: string, route: string, statusCode: number, duration: number) {
    this.httpRequestDuration.observe({ method, route, status_code: statusCode.toString() }, duration);
    this.httpRequestTotal.inc({ method, route, status_code: statusCode.toString() });
  }

  recordHttpError(method: string, route: string, errorType: string) {
    this.httpRequestErrors.inc({ method, route, error_type: errorType });
  }

  // Méthodes pour les métriques base de données
  recordDbQuery(operation: string, table: string, duration: number) {
    this.dbQueryDuration.observe({ operation, table }, duration);
  }

  setActiveDbConnections(count: number) {
    this.dbConnectionsActive.set(count);
  }

  // Méthodes pour les métriques métier F1
  setActiveBets(grandPrix: string, count: number) {
    this.activeBets.set({ grand_prix: grandPrix }, count);
  }

  setActiveUsers(count: number) {
    this.activeUsers.set(count);
  }

  recordLeagueActivity(activityType: string, leagueId: string) {
    this.leagueActivity.inc({ activity_type: activityType, league_id: leagueId });
  }

  recordBetPlaced(grandPrix: string, userId: string) {
    this.betPlaced.inc({ grand_prix: grandPrix, user_id: userId });
  }

  // Méthode pour obtenir toutes les métriques
  async getMetrics(): Promise<string> {
    return this.register.metrics();
  }

  // Collection des métriques système
  private startSystemMetricsCollection() {
    setInterval(() => {
      const memUsage = process.memoryUsage();
      this.memoryUsage.set({ type: 'rss' }, memUsage.rss);
      this.memoryUsage.set({ type: 'heapTotal' }, memUsage.heapTotal);
      this.memoryUsage.set({ type: 'heapUsed' }, memUsage.heapUsed);
      this.memoryUsage.set({ type: 'external' }, memUsage.external);

      // CPU usage (approximation)
      const cpuUsage = process.cpuUsage();
      const totalUsage = (cpuUsage.user + cpuUsage.system) / 1000000; // Convert to seconds
      this.cpuUsage.set(totalUsage);
    }, 5000); // Toutes les 5 secondes
  }
}
