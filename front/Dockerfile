# Multi-stage build pour optimiser la taille de l'image
FROM node:18-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm ci --only=production && npm cache clean --force

# Copier le code source
COPY . .

# Construire l'application Next.js
RUN npm run build

# Stage de production
FROM node:18-alpine AS production

# Installer dumb-init pour une gestion correcte des signaux
RUN apk add --no-cache dumb-init

# Créer un utilisateur non-root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires depuis le stage builder
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Exposer le port de l'application
EXPOSE 3000

# Changer vers l'utilisateur non-root
USER nextjs

# Variables d'environnement par défaut
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Commande de santé
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Utiliser dumb-init pour une gestion correcte des signaux
ENTRYPOINT ["dumb-init", "--"]

# Commande de démarrage
CMD ["node", "server.js"]
