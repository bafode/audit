#!/bin/bash

# Script de démarrage du monitoring P10
echo "🚀 Démarrage du système de monitoring P10..."

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Se déplacer dans le dossier monitoring
cd "$(dirname "$0")/../monitoring" || exit 1

# Vérifier si le fichier .env existe
if [ ! -f "../.env" ]; then
    echo "❌ Fichier .env non trouvé. Veuillez créer un fichier .env à la racine du projet."
    exit 1
fi

# Copier les variables d'environnement
cp ../.env .env

echo "📦 Construction et démarrage des conteneurs..."

# Arrêter les conteneurs existants s'ils existent
docker-compose -f docker-compose.monitoring.yml down

# Construire et démarrer les services
docker-compose -f docker-compose.monitoring.yml up -d --build

# Attendre que les services soient prêts
echo "⏳ Attente du démarrage des services..."
sleep 30

# Vérifier l'état des services
echo "🔍 Vérification de l'état des services..."

services=("prometheus" "grafana" "jaeger" "node-exporter")
for service in "${services[@]}"; do
    if docker-compose -f docker-compose.monitoring.yml ps | grep -q "$service.*Up"; then
        echo "✅ $service est démarré"
    else
        echo "❌ $service n'a pas pu démarrer"
    fi
done

echo ""
echo "🎉 Système de monitoring démarré avec succès!"
echo ""
echo "📊 Accès aux services:"
echo "   • Backend API: http://localhost:4500"
echo "   • Métriques: http://localhost:4500/metrics"
echo "   • Health Check: http://localhost:4500/metrics/health"
echo "   • Prometheus: http://localhost:9090"
echo "   • Grafana: http://localhost:3001 (admin/admin123)"
echo "   • Jaeger: http://localhost:16686"
echo ""
echo "📈 Dashboard Grafana principal: http://localhost:3001/d/p10-backend"
echo ""
echo "🛑 Pour arrêter le monitoring: ./scripts/stop-monitoring.sh"
