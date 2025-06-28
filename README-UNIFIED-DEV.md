# 🏎️ P10 F1 Audit Platform - Environnement de Développement Unifié

## 📋 Vue d'ensemble

Cette plateforme a été consolidée en un seul environnement de développement avec un `docker-compose.yml` unique pour simplifier la gestion et le déploiement.

## 🚀 Démarrage Rapide

### Option 1: Scripts automatiques (Recommandé)
```bash
# Démarrer la plateforme complète
./start-dev.bat

# Arrêter la plateforme
./stop-dev.bat
```

### Option 2: Commandes Docker Compose
```bash
# Démarrer tous les services
docker-compose up -d --build

# Vérifier le statut
docker-compose ps

# Voir les logs
docker-compose logs -f

# Arrêter tous les services
docker-compose down

# Arrêter et supprimer les volumes
docker-compose down -v
```

## 🌐 Services Disponibles

| Service | URL | Description | Identifiants |
|---------|-----|-------------|--------------|
| **Backend API** | http://localhost:4500 | API NestJS principale | - |
| **Grafana** | http://localhost:3001 | Dashboards de monitoring | admin/admin123 |
| **Prometheus** | http://localhost:9090 | Collecte de métriques | - |
| **Jaeger** | http://localhost:16686 | Tracing distribué | - |
| **Node Exporter** | http://localhost:9100/metrics | Métriques système | - |
| **Redis** | localhost:6379 | Cache et sessions | - |
| **Nginx** | http://localhost:80 | Reverse proxy | - |

## 📊 Dashboards Grafana

### 1. 🏎️ P10 F1 Enhanced Dashboard
- **UID**: `p10-enhanced`
- **Sections**:
  - Vue d'ensemble F1 (paris, utilisateurs, ligues)
  - Performance HTTP & API
  - Métriques métier F1
  - Ressources système

### 2. 📈 P10 F1 Backend Dashboard
- **UID**: `p10-backend`
- Dashboard de base avec métriques essentielles

## 🔧 Configuration

### Structure des fichiers
```
audit-p10/
├── docker-compose.yml          # Configuration unifiée
├── start-dev.bat              # Script de démarrage
├── stop-dev.bat               # Script d'arrêt
├── back/                      # Backend NestJS
├── front/                     # Frontend Next.js
├── monitoring/
│   ├── prometheus/
│   │   ├── prometheus-dev.yml # Config Prometheus DEV
│   │   └── alert_rules.yml    # Règles d'alerte
│   └── grafana/
│       ├── dashboards/        # Dashboards JSON
│       └── provisioning/      # Configuration auto
└── nginx/
    └── nginx.conf            # Configuration Nginx
```

### Variables d'environnement
Copiez `.env.template` vers `.env` et configurez :
```bash
DATABASE_URL=your_database_url
CLERK_SECRET_KEY=your_clerk_secret
CLERK_SIGNING_KEY=your_clerk_signing_key
CORS_FRONTEND_URL=http://localhost:3000
```

## 🔍 Monitoring et Métriques

### Métriques collectées
- **HTTP/API**: Requêtes, temps de réponse, erreurs
- **Base de données**: Temps de requête, connexions
- **Métier F1**: Paris actifs, utilisateurs, ligues
- **Système**: CPU, mémoire, disque, réseau

### Intervalles de collecte
- Backend principal: 10s
- Node Exporter: 15s
- Redis: 30s
- OpenTelemetry: 10s
- Jaeger: 30s

## 🛠️ Développement

### Hot Reload
Le backend est configuré avec hot reload pour le développement :
```yaml
volumes:
  - ./back/src:/app/src  # Hot reload
```

### Logs
```bash
# Logs en temps réel
docker-compose logs -f backend

# Logs spécifiques
docker-compose logs prometheus
docker-compose logs grafana
```

### Debugging
```bash
# Accéder au conteneur backend
docker-compose exec backend sh

# Vérifier la santé des services
docker-compose ps
```

## 🔧 Maintenance

### Redémarrer un service
```bash
docker-compose restart prometheus
docker-compose restart grafana
docker-compose restart backend
```

### Mise à jour des images
```bash
docker-compose pull
docker-compose up -d --build
```

### Nettoyage
```bash
# Supprimer les conteneurs arrêtés
docker container prune

# Supprimer les images inutilisées
docker image prune

# Nettoyage complet
docker system prune -a
```

## 📈 Alertes et Notifications

Les règles d'alerte sont configurées dans `monitoring/prometheus/alert_rules.yml`.

### Ajouter une nouvelle alerte
```yaml
groups:
  - name: p10-alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_request_errors_total[5m]) > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Taux d'erreur élevé détecté"
```

## 🎯 Prochaines étapes

1. **Personnaliser les dashboards** selon vos besoins
2. **Configurer des alertes** pour les métriques critiques
3. **Ajouter des métriques métier** supplémentaires
4. **Intégrer avec des outils externes** (Slack, email, etc.)
5. **Configurer un environnement de production** séparé

## 🆘 Dépannage

### Problèmes courants

#### Conteneur qui ne démarre pas
```bash
# Vérifier les logs
docker-compose logs [service-name]

# Reconstruire l'image
docker-compose build [service-name]
docker-compose up -d [service-name]
```

#### Problème de réseau
```bash
# Recréer le réseau
docker-compose down
docker network prune
docker-compose up -d
```

#### Problème de volumes
```bash
# Supprimer et recréer les volumes
docker-compose down -v
docker volume prune
docker-compose up -d
```

#### Grafana ne charge pas les dashboards
```bash
# Redémarrer Grafana
docker-compose restart grafana

# Vérifier les permissions
docker-compose logs grafana
```

## 📚 Documentation

- [Guide de Configuration Monitoring](./GUIDE-CONFIGURATION-MONITORING.md)
- [Documentation Grafana](https://grafana.com/docs/)
- [Documentation Prometheus](https://prometheus.io/docs/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)

---

🏁 **Votre plateforme P10 F1 Audit est maintenant prête pour le développement !**
