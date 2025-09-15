# Dockerfile para aplicación Next.js con Prisma
FROM node:18-alpine AS base

# Instalar dependencias necesarias para Prisma
RUN apk add --no-cache libc6-compat openssl

WORKDIR /app

# Copiar archivos de configuración de dependencias
COPY package*.json ./
COPY prisma ./prisma/

# Instalar dependencias
RUN npm ci --only=production && npm cache clean --force

# Generar cliente de Prisma
RUN npx prisma generate

# Copiar código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Etapa de producción
FROM node:18-alpine AS runner
WORKDIR /app

# Crear usuario no-root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copiar archivos necesarios desde la etapa de build
COPY --from=base /app/public ./public
COPY --from=base /app/.next/standalone ./
COPY --from=base /app/.next/static ./.next/static
COPY --from=base /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=base /app/prisma ./prisma

# Cambiar permisos
RUN chown -R nextjs:nodejs /app
USER nextjs

# Exponer puerto
EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# Comando para ejecutar la aplicación
CMD ["node", "server.js"]
