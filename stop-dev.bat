@echo off
echo 🏎️ Arrêt de la plateforme P10 F1 Audit - Environnement DEV
echo.

echo 📋 Arrêt des conteneurs...
docker-compose down

echo.
echo 🧹 Nettoyage des ressources (optionnel)...
echo Voulez-vous supprimer les volumes de données ? (y/N)
set /p cleanup="Réponse: "

if /i "%cleanup%"=="y" (
    echo 🗑️ Suppression des volumes...
    docker-compose down -v
    docker system prune -f
    echo ✅ Nettoyage terminé
) else (
    echo ✅ Volumes conservés
)

echo.
echo 🏁 Plateforme P10 F1 Audit arrêtée !
echo.
pause
