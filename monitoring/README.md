# 📊 Système de Monitoring P10 F1

Ce système de monitoring complet pour l'application P10 F1 utilise **Prometheus**, **Grafana**, **Winston**, **OpenTelemetry** et **Docker** pour fournir une observabilité complète de votre backend NestJS.

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Backend P10   │───▶│   Prometheus    │───▶│    Grafana      │
│   (NestJS)      │    │  (Métriques)    │    │ (Visualisation) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Winston     │    │  Node Exporter  │    │     Jaeger      │
│   (Logging)     │    │ (Sys Metrics)   │    │   (Tracing)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Démarrage Rapide

### Prérequis
- Docker & Docker Compose installés
- Fichier `.env` configuré à la racine du projet

### Installation
```bash
# Rendre les scripts exécutables
chmod +x scripts/start-monitoring.sh
chmod +x scripts/stop-monitoring.sh

# Démarrer le monitoring
./scripts/start-monitoring.sh
```

### Accès aux Services
- **Backend API**: http://localhost:4500
- **Métriques**: http://localhost:4500/metrics
- **Health Check**: http://localhost:4500/metrics/health
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin123)
- **Jaeger**: http://localhost:16686

## 📈 Dashboards Grafana

### Dashboard Principal P10
- **URL**: http://localhost:3001/d/p10-backend
- **Métriques incluses**:
  - Taux de requêtes HTTP
  - Temps de réponse (percentiles)
  - Utilisation mémoire
  - Statut des services
  - Métriques métier F1 (utilisateurs actifs, paris, ligues)

## 🔍 Métriques Disponibles

### Métriques HTTP
- `http_requests_total` - Nombre total de requêtes HTTP
- `http_request_duration_seconds` - Durée des requêtes HTTP
- `http_request_errors_total` - Nombre d'erreurs HTTP

### Métriques Base de Données
- `db_query_duration_seconds` - Durée des requêtes DB
- `db_connections_active` - Connexions DB actives

### Métriques Métier F1
- `f1_active_users_total` - Utilisateurs actifs
- `f1_active_bets_total` - Paris actifs par Grand Prix
- `f1_bets_placed_total` - Paris placés
- `f1_league_activity_total` - Activités de ligue

### Métriques Système
- `nodejs_memory_usage_bytes` - Utilisation mémoire Node.js
- `nodejs_cpu_usage_percent` - Utilisation CPU
- Métriques système via Node Exporter

## 🚨 Alertes Configurées

### Alertes Critiques
- **BackendDown**: Application hors service > 1min
- **HighSystemMemoryUsage**: Mémoire système > 90%

### Alertes Warning
- **HighErrorRate**: Taux d'erreur > 10%
- **HighLatency**: Latence P95 > 2s
- **HighMemoryUsage**: Mémoire heap > 90%
- **HighDatabaseConnections**: Connexions DB > 50

## 📝 Logging avec Winston

### Configuration
- **Niveaux**: error, warn, info, debug, verbose
- **Rotation**: Fichiers journaliers avec rétention 14 jours
- **Formats**: JSON structuré + console colorée

### Fichiers de logs
```
back/logs/
├── combined-YYYY-MM-DD.log    # Tous les logs
├── error-YYYY-MM-DD.log       # Erreurs uniquement
├── exceptions-YYYY-MM-DD.log  # Exceptions non gérées
└── rejections-YYYY-MM-DD.log  # Promesses rejetées
```

### Utilisation dans le code
```typescript
import { LoggerService } from './monitoring/logger.service';

constructor(private logger: LoggerService) {}

// Logs génériques
this.logger.info('Message info', 'ContextName');
this.logger.error('Erreur', trace, 'ContextName');

// Logs métier F1
this.logger.logBetPlaced(userId, betId, grandPrixId);
this.logger.logUserAction(userId, 'login', { ip: '127.0.0.1' });
```

## 🔧 OpenTelemetry

### Traces Automatiques
- Requêtes HTTP/Express
- Requêtes GraphQL
- Requêtes base de données
- Appels API externes

### Métriques Exportées
- Port 9464 pour Prometheus
- Traces vers Jaeger (port 14268)

## 🐳 Configuration Docker

### Services
- **backend**: Application NestJS avec monitoring
- **prometheus**: Collecte des métriques
- **grafana**: Visualisation et dashboards
- **jaeger**: Tracing distribué
- **node-exporter**: Métriques système

### Volumes Persistants
- `prometheus_data`: Données Prometheus
- `grafana_data`: Configuration et dashboards Grafana
- `../back/logs`: Logs de l'application

## 🛠️ Maintenance

### Arrêter le monitoring
```bash
./scripts/stop-monitoring.sh
```

### Supprimer toutes les données
```bash
cd monitoring
docker-compose -f docker-compose.monitoring.yml down -v
```

### Voir les logs en temps réel
```bash
cd monitoring
docker-compose -f docker-compose.monitoring.yml logs -f backend
```

### Redémarrer un service spécifique
```bash
cd monitoring
docker-compose -f docker-compose.monitoring.yml restart grafana
```

## 📊 Métriques Personnalisées

### Ajouter une nouvelle métrique
```typescript
// Dans metrics.service.ts
private readonly customMetric = new client.Counter({
  name: 'custom_metric_total',
  help: 'Description de la métrique',
  labelNames: ['label1', 'label2'],
  registers: [this.register],
});

// Utilisation
this.customMetric.inc({ label1: 'value1', label2: 'value2' });
```

## 🔐 Sécurité

### Grafana
- Utilisateur par défaut: `admin`
- Mot de passe par défaut: `admin123`
- **⚠️ Changez le mot de passe en production!**

### Endpoints publics
- `/metrics` - Métriques Prometheus (non authentifié)
- `/metrics/health` - Health check (non authentifié)

## 🚀 Production

### Variables d'environnement importantes
```env
NODE_ENV=production
LOG_LEVEL=info
JAEGER_ENDPOINT=http://jaeger:14268/api/traces
```

### Recommandations
1. Utilisez un reverse proxy (nginx) devant Grafana
2. Configurez HTTPS pour tous les services
3. Limitez l'accès aux métriques par IP
4. Configurez des alertes par email/Slack
5. Sauvegardez régulièrement les dashboards Grafana

## 📞 Support

Pour toute question ou problème:
1. Vérifiez les logs: `docker-compose logs -f`
2. Consultez le health check: http://localhost:4500/metrics/health
3. Vérifiez l'état des services: `docker-compose ps`

---

**🏎️ Bon monitoring avec P10 F1! 🏁**
