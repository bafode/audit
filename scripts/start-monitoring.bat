@echo off
echo 🚀 Démarrage du système de monitoring P10...

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

REM Se déplacer dans le dossier monitoring
cd /d "%~dp0\..\monitoring"

REM Vérifier si le fichier .env existe
if not exist "..\\.env" (
    echo ❌ Fichier .env non trouvé. Veuillez créer un fichier .env à la racine du projet.
    pause
    exit /b 1
)

REM Copier les variables d'environnement
copy "..\\.env" ".env" >nul

echo 📦 Construction et démarrage des conteneurs...

REM Arrêter les conteneurs existants s'ils existent
docker-compose -f docker-compose.monitoring.yml down

REM Construire et démarrer les services
docker-compose -f docker-compose.monitoring.yml up -d --build

REM Attendre que les services soient prêts
echo ⏳ Attente du démarrage des services...
timeout /t 30 /nobreak >nul

echo.
echo 🎉 Système de monitoring démarré avec succès!
echo.
echo 📊 Accès aux services:
echo    • Backend API: http://localhost:4500
echo    • Métriques: http://localhost:4500/metrics
echo    • Health Check: http://localhost:4500/metrics/health
echo    • Prometheus: http://localhost:9090
echo    • Grafana: http://localhost:3001 (admin/admin123)
echo    • Jaeger: http://localhost:16686
echo.
echo 📈 Dashboard Grafana principal: http://localhost:3001/d/p10-backend
echo.
echo 🛑 Pour arrêter le monitoring: scripts\stop-monitoring.bat
echo.
pause
