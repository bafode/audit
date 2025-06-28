# 🏎️ Guide de Configuration - Monitoring P10 F1 Audit Platform (DEV)

## ✅ Configuration Terminée - Environnement Unifié

Félicitations ! La plateforme a été consolidée en un seul environnement de développement avec un docker-compose.yml unique. Voici comment utiliser votre plateforme.

## 🚀 Démarrage Rapide

### Option 1: Script automatique (Recommandé)
```bash
# Démarrer la plateforme complète
./start-dev.bat

# Arrêter la plateforme
./stop-dev.bat
```

### Option 2: Commandes manuelles
```bash
# Démarrer tous les services
docker-compose up -d --build

# Vérifier le statut
docker-compose ps

# Arrêter tous les services
docker-compose down
```

## 🌐 Accès aux Services

### 📊 Grafana - Dashboards Visuels
- **URL**: http://localhost:3001
- **Identifiants par défaut**:
  - Username: `admin`
  - Password: `admin` (vous serez invité à le changer)

### 📈 Prometheus - Métriques Brutes
- **URL**: http://localhost:9090
- **Interface de requête PromQL disponible**

### 🔍 Jaeger - Tracing Distribué
- **URL**: http://localhost:16686
- **Interface de recherche de traces**

### 🖥️ Node Exporter - Métriques Système
- **URL**: http://localhost:9100/metrics
- **Métriques système en format Prometheus**

## 📊 Dashboards Disponibles

### 1. 🏎️ P10 F1 Enhanced Dashboard (Nouveau)
**UID**: `p10-enhanced`

**Sections disponibles**:
- **🏎️ Vue d'ensemble**: Status des services, utilisateurs actifs, paris actifs, requêtes/sec
- **🌐 Performance HTTP & API**: 
  - Taux de requêtes par méthode
  - Temps de réponse (percentiles 50, 95, 99)
  - Codes de statut HTTP
  - Performance base de données
- **🏁 Métriques Métier F1**:
  - Activité F1 en temps réel (paris, ligues)
  - Métriques cumulatives
- **🖥️ Ressources Système**:
  - Utilisation mémoire Node.js
  - CPU et connexions DB

### 2. 📈 P10 F1 Backend Dashboard (Original)
**UID**: `p10-backend`

Dashboard de base avec métriques essentielles.

## 🔧 Configuration Prometheus Améliorée

### Nouveaux Jobs de Scraping:
- `p10-backend`: Métriques principales (10s)
- `p10-backend-health`: Health checks (30s)
- `node-exporter`: Métriques système (5s)
- `redis`: Métriques Redis (15s)
- `nginx`: Métriques Nginx (30s)
- `otel-metrics`: OpenTelemetry (10s)

### Métriques Collectées:

#### 🌐 HTTP/API
- `http_requests_total`: Nombre total de requêtes
- `http_request_duration_seconds`: Temps de réponse
- `http_request_errors_total`: Erreurs HTTP

#### 🗄️ Base de Données
- `db_query_duration_seconds`: Temps de requête DB
- `db_connections_active`: Connexions actives

#### 🏁 Métier F1
- `f1_active_bets_total`: Paris actifs par Grand Prix
- `f1_active_users_total`: Utilisateurs actifs
- `f1_league_activity_total`: Activités de ligue
- `f1_bets_placed_total`: Paris placés

#### 🖥️ Système
- `nodejs_memory_usage_bytes`: Utilisation mémoire
- `nodejs_cpu_usage_percent`: Utilisation CPU
- Métriques Node Exporter (CPU, mémoire, disque, réseau)

## 🚀 Comment Utiliser

### 1. Accéder à Grafana
```bash
# Ouvrir dans le navigateur
http://localhost:3001
```

### 2. Se connecter
- Username: `admin`
- Password: `admin`
- Changer le mot de passe lors de la première connexion

### 3. Naviguer vers les Dashboards
- Cliquer sur "Dashboards" dans le menu latéral
- Sélectionner "P10 F1 Enhanced Dashboard" pour la vue complète
- Ou "P10 F1 Backend Dashboard" pour la vue basique

### 4. Personnaliser les Vues
- **Période de temps**: Modifier en haut à droite (1h, 6h, 24h, etc.)
- **Rafraîchissement**: Auto-refresh configurable
- **Variables**: Filtrer par service, environnement, etc.

## 📊 Requêtes PromQL Utiles

### Performance HTTP
```promql
# Taux de requêtes par seconde
rate(http_requests_total[5m])

# Temps de réponse 95e percentile
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Taux d'erreur
rate(http_request_errors_total[5m]) / rate(http_requests_total[5m]) * 100
```

### Métriques F1
```promql
# Paris actifs par Grand Prix
f1_active_bets_total

# Activité des ligues
rate(f1_league_activity_total[5m])

# Utilisateurs actifs
f1_active_users_total
```

### Système
```promql
# Utilisation CPU
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Utilisation mémoire
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

## 🔧 Maintenance

### Redémarrer les Services
```bash
# Redémarrer Prometheus
docker-compose restart prometheus

# Redémarrer Grafana
docker-compose restart grafana

# Redémarrer tous les services de monitoring
docker-compose restart prometheus grafana jaeger node-exporter
```

### Vérifier les Logs
```bash
# Logs Prometheus
docker-compose logs prometheus --tail=20

# Logs Grafana
docker-compose logs grafana --tail=20
```

## 🎯 Alertes et Notifications

Les règles d'alerte sont configurées dans `monitoring/prometheus/alert_rules.yml`. Vous pouvez:
- Ajouter de nouvelles règles d'alerte
- Configurer Alertmanager pour les notifications
- Intégrer avec Slack, email, etc.

## 📈 Prochaines Étapes

1. **Personnaliser les dashboards** selon vos besoins spécifiques
2. **Configurer des alertes** pour les métriques critiques
3. **Ajouter des métriques métier** supplémentaires
4. **Intégrer avec des outils externes** (Slack, PagerDuty, etc.)

---

🏁 **Votre plateforme de monitoring F1 est maintenant opérationnelle !**

Pour toute question ou personnalisation supplémentaire, consultez la documentation Grafana et Prometheus.
