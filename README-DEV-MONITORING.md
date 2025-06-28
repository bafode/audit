# 🔧 Monitoring en Mode Développement

Ce guide explique comment utiliser le monitoring P10 en mode développement local.

## 🚀 Démarrage Rapide

### 1. Démarrer les services de monitoring
```bash
# Windows
scripts\start-dev-monitoring.bat

# Linux/Mac
chmod +x scripts/start-dev-monitoring.sh
./scripts/start-dev-monitoring.sh
```

### 2. Démarrer le backend en mode développement
```bash
cd back
npm run start:dev
```

### 3. Accéder aux interfaces

- **Grafana**: http://localhost:3001 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686
- **Métriques Backend**: http://localhost:4500/metrics

## 📊 Services Disponibles

### Prometheus (Port 9090)
- Collecte automatique des métriques du backend local
- Interface de requête pour explorer les données
- Configuration adaptée au développement

### Grafana (Port 3001)
- Dashboards pré-configurés pour l'application F1
- Visualisation en temps réel des métriques
- Alertes de développement

### Jaeger (Port 16686)
- Tracing distribué des requêtes
- Analyse des performances
- Debugging des appels API

## 🔍 Métriques Disponibles

Le backend expose automatiquement :

### Métriques Application F1
- `p10_active_bets_total` - Nombre de paris actifs
- `p10_active_users_total` - Utilisateurs actifs
- `p10_league_activity_total` - Activité des ligues
- `p10_grandprix_bets_total` - Paris par Grand Prix

### Métriques Techniques
- `http_requests_total` - Requêtes HTTP
- `http_request_duration_seconds` - Durée des requêtes
- `nodejs_*` - Métriques Node.js (mémoire, CPU, etc.)

## 📝 Logs de Développement

Les logs sont configurés pour le développement :

### Console
- Niveau DEBUG activé
- Couleurs pour faciliter la lecture
- Format lisible avec contexte

### Fichiers
- `logs/error.log` - Erreurs uniquement
- `logs/combined.log` - Tous les logs
- Rotation automatique

## 🛠️ Configuration

### Variables d'environnement (.env)
```env
# Monitoring
METRICS_ENABLED=true
LOG_LEVEL=debug

# Ports
PORT=4500
METRICS_PORT=4500
```

### Personnalisation

Pour modifier la configuration :

1. **Prometheus** : `monitoring/prometheus/prometheus-dev.yml`
2. **Grafana** : `monitoring/grafana/provisioning/`
3. **Logs** : `back/src/monitoring/winston-dev.config.ts`

## 🔄 Workflow de Développement

### 1. Démarrage
```bash
# 1. Services monitoring
scripts\start-dev-monitoring.bat

# 2. Backend
cd back && npm run start:dev

# 3. Frontend (optionnel)
cd front && npm run dev
```

### 2. Développement
- Les métriques sont collectées automatiquement
- Les logs apparaissent en console avec couleurs
- Grafana se met à jour en temps réel

### 3. Debugging
- Utilisez Jaeger pour tracer les requêtes lentes
- Consultez Prometheus pour les métriques détaillées
- Vérifiez les logs dans la console ou fichiers

### 4. Arrêt
```bash
# Arrêter le monitoring
scripts\stop-dev-monitoring.bat

# Le backend s'arrête avec Ctrl+C
```

## 🎯 Cas d'Usage Typiques

### Analyser les Performances
1. Ouvrir Grafana → Dashboard P10
2. Surveiller les graphiques de réponse
3. Identifier les requêtes lentes dans Jaeger

### Débugger une Erreur
1. Consulter les logs console (couleurs)
2. Vérifier `logs/error.log` pour les détails
3. Tracer la requête dans Jaeger

### Tester les Métriques
1. Faire des requêtes à l'API
2. Vérifier http://localhost:4500/metrics
3. Observer les changements dans Grafana

## 🚫 Arrêt et Nettoyage

### Arrêt Normal
```bash
scripts\stop-dev-monitoring.bat
```

### Nettoyage Complet (supprime les données)
```bash
docker-compose -f docker-compose.dev.yml down -v
```

### Redémarrage Propre
```bash
scripts\stop-dev-monitoring.bat
scripts\start-dev-monitoring.bat
```

## 🔧 Dépannage

### Le backend ne démarre pas
- Vérifiez que le port 4500 est libre
- Consultez les logs d'erreur
- Vérifiez la configuration .env

### Prometheus ne collecte pas les métriques
- Vérifiez que le backend expose /metrics
- Testez : `curl http://localhost:4500/metrics`
- Vérifiez la config `prometheus-dev.yml`

### Grafana ne montre pas de données
- Vérifiez que Prometheus collecte les données
- Attendez quelques minutes pour l'initialisation
- Rechargez le dashboard

## 📚 Ressources

- [Documentation Prometheus](https://prometheus.io/docs/)
- [Documentation Grafana](https://grafana.com/docs/)
- [Documentation Jaeger](https://www.jaegertracing.io/docs/)
- [Winston Logging](https://github.com/winstonjs/winston)
