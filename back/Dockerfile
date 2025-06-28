# Multi-stage build pour optimiser la taille de l'image
FROM node:18-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./
COPY tsconfig*.json ./
COPY nest-cli.json ./

# Installer toutes les dépendances (dev + prod pour le build)
RUN npm ci && npm cache clean --force

# Copier le code source
COPY src/ ./src/
COPY prisma/ ./prisma/

# Générer le client Prisma
RUN npx prisma generate

# Construire l'application
RUN npm run build

# Stage de production
FROM node:18-alpine AS production

# Installer dumb-init pour une gestion correcte des signaux
RUN apk add --no-cache dumb-init

# Créer un utilisateur non-root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nestjs -u 1001

# Définir le répertoire de travail
WORKDIR /app

# Installer seulement les dépendances de production
COPY --from=builder --chown=nestjs:nodejs /app/package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copier les fichiers construits
COPY --from=builder --chown=nestjs:nodejs /app/dist ./dist

# Copier le client Prisma généré
COPY --from=builder --chown=nestjs:nodejs /app/generated ./generated

# Créer le dossier pour les logs
RUN mkdir -p /app/logs && chown -R nestjs:nodejs /app/logs

# Exposer le port de l'application
EXPOSE 4500

# Exposer le port pour les métriques OpenTelemetry
EXPOSE 9464

# Changer vers l'utilisateur non-root
USER nestjs

# Variables d'environnement par défaut
ENV NODE_ENV=production
ENV PORT=4500
ENV LOG_LEVEL=info

# Commande de santé
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:4500/metrics/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Utiliser dumb-init pour une gestion correcte des signaux
ENTRYPOINT ["dumb-init", "--"]

# Commande de démarrage
CMD ["node", "dist/main.js"]
