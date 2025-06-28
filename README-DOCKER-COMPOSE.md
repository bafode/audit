# 🐳 P10 F1 - Déploiement Docker Compose Complet

## 🚀 Démarrage Rapide avec Docker Compose

Ce projet utilise un fichier `docker-compose.yml` unique pour lancer l'ensemble de l'application P10 F1 avec son système de monitoring complet.

### 📋 Prérequis

- **Docker** et **Docker Compose** installés
- **Fichier .env** configuré à la racine du projet

### ⚡ Démarrage Ultra-Rapide

**Windows :**
```bash
start-all.bat
```

**Linux/Mac :**
```bash
chmod +x start-all.sh
./start-all.sh
```

**Ou directement avec Docker Compose :**
```bash
docker-compose up -d --build
```

## 🏗️ Architecture Complète

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Prometheus    │
│   (Next.js)     │───▶│   (NestJS)      │───▶│   (Métriques)   │
│   Port: 3000    │    │   Port: 4500    │    │   Port: 9090    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Nginx       │    │     Jaeger      │    │    Grafana      │
│  (Reverse Proxy)│    │   (Tracing)     │    │ (Visualisation) │
│   Port: 80/443  │    │   Port: 16686   │    │   Port: 3001    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Redis       │    │  Node Exporter  │    │   PostgreSQL    │
│   (Cache)       │    │ (Sys Metrics)   │    │  (Base de données)
│   Port: 6379    │    │   Port: 9100    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🔧 Services Inclus

### 🎯 Application Principale
- **Frontend** (Next.js) : Interface utilisateur F1
- **Backend** (NestJS) : API GraphQL avec monitoring intégré
- **PostgreSQL** : Base de données (optionnel, peut utiliser une DB externe)
- **Redis** : Cache et sessions

### 📊 Stack de Monitoring
- **Prometheus** : Collecte des métriques
- **Grafana** : Dashboards et visualisation
- **Jaeger** : Tracing distribué
- **Node Exporter** : Métriques système

### 🔧 Infrastructure
- **Nginx** : Reverse proxy et load balancer
- **Réseau Docker** : Communication inter-services

## 🌐 Accès aux Services

| Service | URL | Credentials |
|---------|-----|-------------|
| 🏎️ **Frontend** | http://localhost:3000 | - |
| 🔧 **Backend API** | http://localhost:4500 | - |
| 📊 **Métriques** | http://localhost:4500/metrics | - |
| ❤️ **Health Check** | http://localhost:4500/metrics/health | - |
| 📈 **Prometheus** | http://localhost:9090 | - |
| 📊 **Grafana** | http://localhost:3001 | admin/admin123 |
| 🔍 **Jaeger** | http://localhost:16686 | - |
| 💾 **Redis** | localhost:6379 | - |
| 🗄️ **PostgreSQL** | localhost:5432 | Voir .env |

## ⚙️ Configuration

### 1. Fichier .env
Créez un fichier `.env` à la racine du projet :

```bash
# Copier l'exemple
cp monitoring/.env.example .env

# Éditer selon vos besoins
nano .env
```

### 2. Variables d'environnement importantes
```env
# Application
NODE_ENV=production
PORT=4500
LOG_LEVEL=info

# Base de données
DATABASE_URL=postgresql://user:password@host:port/database

# Authentification
CLERK_SECRET_KEY=your_clerk_secret_key
CLERK_SIGNING_KEY=your_clerk_signing_key

# Frontend
CORS_FRONTEND_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:4500

# Monitoring
JAEGER_ENDPOINT=http://p10-jaeger:14268/api/traces

# Grafana
GF_SECURITY_ADMIN_PASSWORD=admin123
```

## 🚀 Commandes Utiles

### Démarrage et Arrêt
```bash
# Démarrer tous les services
docker-compose up -d --build

# Arrêter tous les services
docker-compose down

# Arrêter et supprimer les volumes
docker-compose down -v
```

### Monitoring et Debug
```bash
# Voir l'état des services
docker-compose ps

# Logs en temps réel de tous les services
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f p10-backend
docker-compose logs -f p10-grafana

# Redémarrer un service
docker-compose restart p10-backend

# Reconstruire un service
docker-compose up -d --build p10-backend
```

### Maintenance
```bash
# Nettoyer les images non utilisées
docker image prune -f

# Nettoyer tout (attention : supprime tout)
docker system prune -a --volumes

# Voir l'utilisation des ressources
docker stats
```

## 🔧 Personnalisation

### Désactiver des Services

Pour désactiver un service, commentez-le dans `docker-compose.yml` :

```yaml
# Frontend (si vous n'en avez pas besoin)
# frontend:
#   build:
#     context: ./front
#   ...

# PostgreSQL (si vous utilisez une DB externe)
# postgres:
#   image: postgres:15-alpine
#   ...
```

### Modifier les Ports

Changez les ports dans `docker-compose.yml` :

```yaml
services:
  backend:
    ports:
      - "8080:4500"  # Utiliser le port 8080 au lieu de 4500
```

### Ajouter des Variables d'Environnement

Ajoutez dans la section `environment` du service :

```yaml
services:
  backend:
    environment:
      - CUSTOM_VAR=custom_value
      - ANOTHER_VAR=${ANOTHER_VAR}
```

## 📊 Monitoring Avancé

### Dashboards Grafana Disponibles
- **P10 Backend Dashboard** : Vue d'ensemble de l'application
- **System Metrics** : Métriques système (CPU, mémoire, disque)
- **Business Metrics** : KPIs spécifiques F1

### Métriques Personnalisées
Le backend expose automatiquement :
- Métriques HTTP (requêtes, latence, erreurs)
- Métriques base de données
- Métriques métier F1 (utilisateurs, paris, ligues)
- Métriques système Node.js

### Alertes Configurées
- Application hors service
- Taux d'erreur élevé
- Latence excessive
- Utilisation mémoire critique

## 🔐 Sécurité

### Production
1. **Changez les mots de passe par défaut** dans `.env`
2. **Configurez HTTPS** avec des certificats SSL
3. **Limitez l'accès** aux services de monitoring
4. **Utilisez des secrets Docker** pour les données sensibles
5. **Configurez un firewall** approprié

### Secrets Docker (Recommandé pour la production)
```yaml
secrets:
  db_password:
    file: ./secrets/db_password.txt
  
services:
  backend:
    secrets:
      - db_password
```

## 🚨 Dépannage

### Problèmes Courants

**Services ne démarrent pas :**
```bash
# Vérifier les logs
docker-compose logs

# Vérifier l'espace disque
df -h

# Vérifier les ports utilisés
netstat -tulpn | grep :4500
```

**Métriques manquantes :**
```bash
# Vérifier la configuration Prometheus
curl http://localhost:9090/api/v1/targets

# Vérifier les métriques du backend
curl http://localhost:4500/metrics
```

**Problèmes de réseau :**
```bash
# Vérifier le réseau Docker
docker network ls
docker network inspect audit-p10_p10-network
```

## 📈 Scaling

### Scaling Horizontal
```bash
# Lancer plusieurs instances du backend
docker-compose up -d --scale backend=3

# Avec load balancer
docker-compose up -d --scale backend=3 nginx
```

### Optimisation des Ressources
```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

## 🎯 Prochaines Étapes

1. **CI/CD** : Intégration avec GitHub Actions
2. **Kubernetes** : Migration vers K8s pour la production
3. **Monitoring avancé** : Alertes par email/Slack
4. **Backup automatique** : Sauvegarde des données
5. **SSL/TLS** : Certificats automatiques avec Let's Encrypt

---

**🏁 Bon déploiement avec P10 F1! 🏎️**
