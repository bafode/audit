@echo off
echo 🛑 Arrêt du système de monitoring P10...

REM Se déplacer dans le dossier monitoring
cd /d "%~dp0\..\monitoring"

REM Arrêter et supprimer les conteneurs
echo 📦 Arrêt des conteneurs...
docker-compose -f docker-compose.monitoring.yml down

REM Nettoyer les images non utilisées (optionnel)
echo 🧹 Nettoyage des images non utilisées...
docker image prune -f

echo.
echo ✅ Système de monitoring arrêté avec succès!
echo.
echo 💡 Pour redémarrer le monitoring: scripts\start-monitoring.bat
echo 💡 Pour supprimer complètement les données: 
echo    cd monitoring
echo    docker-compose -f docker-compose.monitoring.yml down -v
echo.
pause
