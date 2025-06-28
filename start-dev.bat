@echo off
echo 🏎️ Démarrage de la plateforme P10 F1 Audit - Environnement DEV
echo.

echo 📋 Arrêt des conteneurs existants...
docker-compose down

echo.
echo 🔧 Construction et démarrage des services...
docker-compose up -d --build

echo.
echo ⏳ Attente du démarrage des services...
timeout /t 10 /nobreak > nul

echo.
echo 📊 Vérification du statut des conteneurs...
docker-compose ps

echo.
echo ✅ Services disponibles:
echo   🚀 Backend API:          http://localhost:4500
echo   📊 Grafana Dashboards:   http://localhost:3001 (admin/admin123)
echo   📈 Prometheus:           http://localhost:9090
echo   🔍 Jaeger Tracing:       http://localhost:16686
echo   🖥️  Node Exporter:        http://localhost:9100/metrics
echo   🌐 Nginx Proxy:          http://localhost:80
echo.
echo 🏁 Plateforme P10 F1 Audit démarrée en mode développement !
echo.
pause
