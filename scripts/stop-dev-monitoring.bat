@echo off
echo Stopping P10 Development Monitoring Stack...
echo.

docker-compose -f docker-compose.dev.yml down

echo.
echo ========================================
echo   P10 Development Monitoring Stopped
echo ========================================
echo.
echo All monitoring services have been stopped.
echo Data volumes are preserved for next startup.
echo.
echo To remove all data volumes (reset):
echo   docker-compose -f docker-compose.dev.yml down -v
echo ========================================
