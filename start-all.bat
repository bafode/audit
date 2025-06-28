@echo off
echo 🚀 Démarrage complet de l'application P10 F1 avec monitoring...

REM Vérifier si Docker est installé
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker n'est pas installé. Veuillez l'installer avant de continuer.
    pause
    exit /b 1
)

REM Vérifier si Docker Compose est installé
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose n'est pas installé. Veuillez l'installer avant de continuer.
    pause
    exit /b 1
)

REM Vérifier si le fichier .env existe
if not exist ".env" (
    echo ❌ Fichier .env non trouvé. Veuillez créer un fichier .env à la racine du projet.
    echo 💡 Vous pouvez copier monitoring\.env.example vers .env et l'adapter
    pause
    exit /b 1
)

echo 📦 Arrêt des conteneurs existants...
docker-compose down

echo 🔨 Construction et démarrage de tous les services...
docker-compose up -d --build

echo ⏳ Attente du démarrage des services...
timeout /t 45 /nobreak >nul

echo 🔍 Vérification de l'état des services...

REM Vérifier les services principaux
docker ps | findstr "p10-backend" >nul && echo ✅ p10-backend est démarré || echo ❌ p10-backend n'a pas pu démarrer
docker ps | findstr "p10-prometheus" >nul && echo ✅ p10-prometheus est démarré || echo ❌ p10-prometheus n'a pas pu démarrer
docker ps | findstr "p10-grafana" >nul && echo ✅ p10-grafana est démarré || echo ❌ p10-grafana n'a pas pu démarrer
docker ps | findstr "p10-jaeger" >nul && echo ✅ p10-jaeger est démarré || echo ❌ p10-jaeger n'a pas pu démarrer
docker ps | findstr "p10-node-exporter" >nul && echo ✅ p10-node-exporter est démarré || echo ❌ p10-node-exporter n'a pas pu démarrer

REM Vérifier le frontend s'il est activé
docker ps | findstr "p10-frontend" >nul && echo ✅ p10-frontend est démarré

echo.
echo 🎉 Application P10 F1 démarrée avec succès!
echo.
echo 📊 Accès aux services:
echo    • 🏎️  Frontend: http://localhost:3000
echo    • 🔧 Backend API: http://localhost:4500
echo    • 📊 Métriques: http://localhost:4500/metrics
echo    • ❤️  Health Check: http://localhost:4500/metrics/health
echo    • 📈 Prometheus: http://localhost:9090
echo    • 📊 Grafana: http://localhost:3001 (admin/admin123)
echo    • 🔍 Jaeger: http://localhost:16686
echo    • 💾 Redis: localhost:6379
echo.
echo 📈 Dashboard Grafana principal: http://localhost:3001/d/p10-backend
echo.
echo 🛑 Pour arrêter l'application: docker-compose down
echo 🗑️  Pour supprimer toutes les données: docker-compose down -v
echo.
echo 📝 Logs en temps réel: docker-compose logs -f
echo 📝 Logs d'un service: docker-compose logs -f [service-name]
echo.
pause
