@echo off
echo Starting P10 Development Monitoring Stack...
echo.

echo Starting monitoring services (Prometheus, Grafana, Jaeger)...
docker-compose -f docker-compose.dev.yml up -d

echo.
echo Waiting for services to start...
timeout /t 10 /nobreak > nul

echo.
echo ========================================
echo   P10 Development Monitoring Started
echo ========================================
echo.
echo Services available at:
echo   - Prometheus: http://localhost:9090
echo   - Grafana:    http://localhost:3001 (admin/admin)
echo   - Jaeger:     http://localhost:16686
echo.
echo Backend metrics will be available at:
echo   - http://localhost:4500/metrics (when backend is running)
echo.
echo To start the backend in development mode:
echo   cd back
echo   npm run start:dev
echo.
echo To stop monitoring: scripts\stop-dev-monitoring.bat
echo ========================================
