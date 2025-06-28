# 🏎️ P10 F1 - Système de Monitoring Complet

## 📋 Vue d'ensemble

Ce projet implémente un système de monitoring complet pour l'application P10 F1 utilisant les technologies suivantes :

- **🔍 Winston** : Logging structuré avec rotation des fichiers
- **📊 OpenTelemetry** : Instrumentation automatique et métriques
- **📈 Prometheus** : Collecte et stockage des métriques
- **📊 Grafana** : Visualisation et dashboards
- **🔍 Jaeger** : Tracing distribué
- **🐳 Docker** : Orchestration des services

## 🚀 Démarrage Rapide

### 1. Installation des dépendances
```bash
cd back
npm install
```

### 2. Configuration
Copiez le fichier d'environnement :
```bash
cp monitoring/.env.example .env
```

### 3. Démarrage du monitoring
```bash
# Rendre les scripts exécutables (Linux/Mac)
chmod +x scripts/start-monitoring.sh
chmod +x scripts/stop-monitoring.sh

# Démarrer le système complet
./scripts/start-monitoring.sh
```

### 4. Accès aux services
- **API Backend** : http://localhost:4500
- **Métriques** : http://localhost:4500/metrics
- **Health Check** : http://localhost:4500/metrics/health
- **Prometheus** : http://localhost:9090
- **Grafana** : http://localhost:3001 (admin/admin123)
- **Jaeger** : http://localhost:16686

## 📊 Fonctionnalités Implémentées

### 🔍 Logging avec Winston
- **Niveaux** : error, warn, info, debug, verbose
- **Rotation** : Fichiers journaliers avec rétention 14 jours
- **Formats** : JSON structuré + console colorée
- **Logs métier** : Actions utilisateurs, paris, activités ligues

### 📈 Métriques Prometheus
- **HTTP** : Requêtes, durée, erreurs
- **Base de données** : Durée des requêtes, connexions actives
- **Système** : CPU, mémoire, disque
- **Métier F1** : Utilisateurs actifs, paris, activités ligues

### 📊 Dashboards Grafana
- **Dashboard principal** : Vue d'ensemble de l'application
- **Métriques système** : Performance infrastructure
- **Métriques métier** : KPIs spécifiques F1
- **Alertes** : Notifications automatiques

### 🔍 Tracing OpenTelemetry
- **Traces automatiques** : HTTP, GraphQL, base de données
- **Corrélation** : Logs et traces liés
- **Performance** : Identification des goulots d'étranglement

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Backend P10   │───▶│   Prometheus    │───▶│    Grafana      │
│   (NestJS)      │    │  (Métriques)    │    │ (Visualisation) │
│   + Winston     │    │                 │    │                 │
│   + OpenTel     │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Logs        │    │  Node Exporter  │    │     Jaeger      │
│   (Fichiers)    │    │ (Sys Metrics)   │    │   (Tracing)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📁 Structure des Fichiers

```
audit-p10/
├── back/
│   ├── src/monitoring/          # Module de monitoring
│   │   ├── monitoring.module.ts
│   │   ├── logger.service.ts
│   │   ├── metrics.service.ts
│   │   ├── telemetry.service.ts
│   │   ├── metrics.controller.ts
│   │   └── winston.config.ts
│   ├── logs/                    # Logs de l'application
│   ├── Dockerfile              # Image Docker backend
│   └── .dockerignore
├── monitoring/
│   ├── docker-compose.monitoring.yml
│   ├── prometheus/
│   │   ├── prometheus.yml
│   │   └── alert_rules.yml
│   ├── grafana/
│   │   ├── provisioning/
│   │   └── dashboards/
│   ├── .env.example
│   └── README.md
└── scripts/
    ├── start-monitoring.sh
    └── stop-monitoring.sh
```

## 🔧 Configuration

### Variables d'environnement
```env
# Application
NODE_ENV=production
PORT=4500
LOG_LEVEL=info

# Monitoring
JAEGER_ENDPOINT=http://jaeger:14268/api/traces

# Base de données
DATABASE_URL=postgresql://...

# Authentification
CLERK_SECRET_KEY=...
```

### Métriques personnalisées
```typescript
// Exemple d'utilisation dans un service
constructor(
  private metricsService: MetricsService,
  private logger: LoggerService
) {}

// Enregistrer une métrique
this.metricsService.recordBetPlaced('monaco-gp', 'user123');

// Logger une action
this.logger.logUserAction('user123', 'place_bet', { amount: 100 });
```

## 🚨 Alertes Configurées

### Critiques
- Application hors service > 1 minute
- Mémoire système > 90%

### Warnings
- Taux d'erreur > 10%
- Latence P95 > 2 secondes
- Mémoire heap > 90%
- Connexions DB > 50

## 🛠️ Maintenance

### Commandes utiles
```bash
# Voir les logs en temps réel
cd monitoring
docker-compose -f docker-compose.monitoring.yml logs -f backend

# Redémarrer un service
docker-compose -f docker-compose.monitoring.yml restart grafana

# Arrêter complètement
./scripts/stop-monitoring.sh

# Supprimer toutes les données
cd monitoring
docker-compose -f docker-compose.monitoring.yml down -v
```

### Sauvegarde
- **Grafana** : Exporter les dashboards depuis l'interface
- **Prometheus** : Sauvegarder le volume `prometheus_data`
- **Logs** : Archiver le dossier `back/logs/`

## 📈 Métriques Métier F1

### Utilisateurs
- `f1_active_users_total` : Nombre d'utilisateurs actifs
- Logs des connexions et actions utilisateurs

### Paris
- `f1_active_bets_total` : Paris actifs par Grand Prix
- `f1_bets_placed_total` : Nombre de paris placés
- Logs détaillés des paris

### Ligues
- `f1_league_activity_total` : Activités par ligue
- Logs des créations/modifications de ligues

## 🔐 Sécurité

### Production
1. Changer le mot de passe Grafana par défaut
2. Configurer HTTPS pour tous les services
3. Limiter l'accès aux métriques par IP
4. Utiliser des secrets Docker pour les mots de passe
5. Configurer un reverse proxy (nginx)

### Endpoints publics
- `/metrics` : Métriques Prometheus (non authentifié)
- `/metrics/health` : Health check (non authentifié)

## 📞 Support et Dépannage

### Problèmes courants
1. **Services ne démarrent pas** : Vérifier Docker et les ports
2. **Métriques manquantes** : Vérifier la configuration Prometheus
3. **Dashboards vides** : Attendre quelques minutes pour les données

### Logs de débogage
```bash
# Vérifier l'état des services
docker-compose -f monitoring/docker-compose.monitoring.yml ps

# Voir les logs d'un service spécifique
docker-compose -f monitoring/docker-compose.monitoring.yml logs prometheus

# Health check de l'application
curl http://localhost:4500/metrics/health
```

## 🎯 Prochaines Étapes

1. **Alertes avancées** : Configuration email/Slack
2. **Métriques business** : KPIs spécifiques F1
3. **Dashboards personnalisés** : Par équipe/utilisateur
4. **Intégration CI/CD** : Monitoring des déploiements
5. **Scaling** : Configuration multi-instance

---

**🏁 Bon monitoring avec P10 F1! 🏎️**
