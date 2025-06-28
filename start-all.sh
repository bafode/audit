#!/bin/bash

echo "🚀 Démarrage complet de l'application P10 F1 avec monitoring..."

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

# Vérifier si le fichier .env existe
if [ ! -f ".env" ]; then
    echo "❌ Fichier .env non trouvé. Veuillez créer un fichier .env à la racine du projet."
    echo "💡 Vous pouvez copier monitoring/.env.example vers .env et l'adapter"
    exit 1
fi

echo "📦 Arrêt des conteneurs existants..."
docker-compose down

echo "🔨 Construction et démarrage de tous les services..."
docker-compose up -d --build

echo "⏳ Attente du démarrage des services..."
sleep 45

echo "🔍 Vérification de l'état des services..."

# Vérifier les services principaux
services=("p10-backend" "p10-prometheus" "p10-grafana" "p10-jaeger" "p10-node-exporter")
for service in "${services[@]}"; do
    if docker ps | grep -q "$service"; then
        echo "✅ $service est démarré"
    else
        echo "❌ $service n'a pas pu démarrer"
    fi
done

# Vérifier le frontend s'il est activé
if docker ps | grep -q "p10-frontend"; then
    echo "✅ p10-frontend est démarré"
fi

echo ""
echo "🎉 Application P10 F1 démarrée avec succès!"
echo ""
echo "📊 Accès aux services:"
echo "   • 🏎️  Frontend: http://localhost:3000"
echo "   • 🔧 Backend API: http://localhost:4500"
echo "   • 📊 Métriques: http://localhost:4500/metrics"
echo "   • ❤️  Health Check: http://localhost:4500/metrics/health"
echo "   • 📈 Prometheus: http://localhost:9090"
echo "   • 📊 Grafana: http://localhost:3001 (admin/admin123)"
echo "   • 🔍 Jaeger: http://localhost:16686"
echo "   • 💾 Redis: localhost:6379"
echo ""
echo "📈 Dashboard Grafana principal: http://localhost:3001/d/p10-backend"
echo ""
echo "🛑 Pour arrêter l'application: docker-compose down"
echo "🗑️  Pour supprimer toutes les données: docker-compose down -v"
echo ""
echo "📝 Logs en temps réel: docker-compose logs -f"
echo "📝 Logs d'un service: docker-compose logs -f [service-name]"
