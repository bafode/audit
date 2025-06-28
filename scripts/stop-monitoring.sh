#!/bin/bash

# Script d'arrêt du monitoring P10
echo "🛑 Arrêt du système de monitoring P10..."

# Se déplacer dans le dossier monitoring
cd "$(dirname "$0")/../monitoring" || exit 1

# Arrêter et supprimer les conteneurs
echo "📦 Arrêt des conteneurs..."
docker-compose -f docker-compose.monitoring.yml down

# Optionnel: supprimer les volumes (décommenter si nécessaire)
# echo "🗑️ Suppression des volumes..."
# docker-compose -f docker-compose.monitoring.yml down -v

# Nettoyer les images non utilisées (optionnel)
echo "🧹 Nettoyage des images non utilisées..."
docker image prune -f

echo ""
echo "✅ Système de monitoring arrêté avec succès!"
echo ""
echo "💡 Pour redémarrer le monitoring: ./scripts/start-monitoring.sh"
echo "💡 Pour supprimer complètement les données: docker-compose -f monitoring/docker-compose.monitoring.yml down -v"
