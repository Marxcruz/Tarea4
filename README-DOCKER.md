# Documentación de Contenedores - Aplicación de Foro

## 📋 Descripción del Proyecto

Esta es una aplicación de foro completa desarrollada con:
- **Frontend**: Next.js 14 con TypeScript
- **Backend**: API Routes de Next.js
- **Base de datos**: PostgreSQL (AWS RDS o local con Docker)
- **ORM**: Prisma
- **Autenticación**: NextAuth.js
- **Estilos**: Tailwind CSS

## 🐳 Configuración de Contenedores

### Archivos de Configuración

1. **Dockerfile**: Contiene la configuración para crear la imagen de la aplicación Next.js
2. **docker-compose.yml**: Orquesta múltiples contenedores (app + PostgreSQL + Adminer)
3. **.dockerignore**: Define qué archivos excluir del contexto de Docker
4. **.env.docker**: Variables de entorno específicas para contenedores

### Estructura de Contenedores

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   foro-app      │    │  foro-postgres  │    │  foro-adminer   │
│   (Next.js)     │◄──►│   (PostgreSQL)  │◄──►│   (Admin DB)    │
│   Puerto: 3000  │    │   Puerto: 5432  │    │   Puerto: 8080  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Comandos de Despliegue

### 1. Construcción y Ejecución Completa
```bash
# Construir y ejecutar todos los contenedores
docker-compose up --build -d

# Ver logs en tiempo real
docker-compose logs -f

# Parar todos los contenedores
docker-compose down
```

### 2. Comandos Individuales
```bash
# Solo construir la imagen
docker build -t foro-app .

# Ejecutar solo la aplicación (requiere BD externa)
docker run -p 3000:3000 --env-file .env.docker foro-app

# Ejecutar solo PostgreSQL
docker-compose up postgres -d
```

### 3. Gestión de Base de Datos
```bash
# Ejecutar migraciones de Prisma
docker-compose exec app npx prisma migrate deploy

# Ejecutar seed de datos
docker-compose exec app npx prisma db seed

# Acceder a la consola de PostgreSQL
docker-compose exec postgres psql -U postgres -d foro_db
```

## 🔧 Variables de Entorno

### Para Desarrollo Local con Docker
```env
DATABASE_URL="postgresql://postgres:postgres123@postgres:5432/foro_db?schema=public"
NEXTAUTH_SECRET="tu-secreto-super-seguro-para-docker"
NEXTAUTH_URL="http://localhost:3000"
NODE_ENV="production"
```

### Para Producción con AWS RDS
```env
DATABASE_URL="postgresql://postgres:Ddli%242024@database-1.cwni8qkeq51c.us-east-1.rds.amazonaws.com:5432/proyecto-aws?schema=public&sslmode=require"
NEXTAUTH_SECRET="secreto-muy-seguro-para-produccion"
NEXTAUTH_URL="https://tu-dominio.com"
NODE_ENV="production"
```

## 📱 Acceso a la Aplicación

Una vez ejecutado `docker-compose up`, podrás acceder a:

- **Aplicación Principal**: http://localhost:3000
- **Adminer (Gestión BD)**: http://localhost:8080
  - Sistema: PostgreSQL
  - Servidor: postgres
  - Usuario: postgres
  - Contraseña: postgres123
  - Base de datos: foro_db

## 🔍 Funcionalidades de la Aplicación

### Características Principales
- ✅ Sistema de autenticación completo
- ✅ Gestión de usuarios con roles (USUARIO/ADMIN)
- ✅ CRUD completo de publicaciones
- ✅ Sistema de comentarios con moderación
- ✅ Sistema de likes y compartir
- ✅ Etiquetas y búsqueda avanzada
- ✅ Panel de administración
- ✅ Registro de auditoría
- ✅ Diseño responsive

### Usuarios de Prueba
- **Admin**: admin@test.com / admin123
- **Usuario**: usuario@test.com / user123

## 🛠️ Desarrollo y Debugging

### Ver logs de contenedores específicos
```bash
# Logs de la aplicación
docker-compose logs -f app

# Logs de PostgreSQL
docker-compose logs -f postgres

# Logs de Adminer
docker-compose logs -f adminer
```

### Acceder al contenedor de la aplicación
```bash
# Bash interactivo en el contenedor
docker-compose exec app sh

# Ejecutar comandos de Prisma
docker-compose exec app npx prisma studio
```

### Reiniciar servicios específicos
```bash
# Reiniciar solo la aplicación
docker-compose restart app

# Reiniciar solo la base de datos
docker-compose restart postgres
```

## 📦 Volúmenes y Persistencia

- **postgres_data**: Persiste los datos de PostgreSQL
- **./uploads**: Directorio para archivos subidos (si aplica)

## 🔒 Consideraciones de Seguridad

1. **Cambiar contraseñas por defecto** en producción
2. **Usar HTTPS** en producción
3. **Configurar firewall** apropiadamente
4. **Variables de entorno seguras** (no hardcodeadas)
5. **Actualizar dependencias** regularmente

## 📋 Checklist de Despliegue

- [ ] Docker y Docker Compose instalados
- [ ] Variables de entorno configuradas
- [ ] Puerto 3000 disponible
- [ ] Puerto 5432 disponible (si usas PostgreSQL local)
- [ ] Puerto 8080 disponible (para Adminer)
- [ ] Ejecutar `docker-compose up --build -d`
- [ ] Verificar que todos los contenedores estén corriendo
- [ ] Acceder a http://localhost:3000
- [ ] Probar login con usuarios de prueba

## 🆘 Solución de Problemas

### Error de conexión a base de datos
```bash
# Verificar que PostgreSQL esté corriendo
docker-compose ps postgres

# Reiniciar PostgreSQL
docker-compose restart postgres
```

### Error de build de Next.js
```bash
# Limpiar cache y reconstruir
docker-compose down
docker system prune -f
docker-compose up --build
```

### Puerto ocupado
```bash
# Ver qué proceso usa el puerto 3000
netstat -tlnp | grep :3000

# Cambiar puerto en docker-compose.yml si es necesario
```

## 📞 Soporte

Para problemas o preguntas sobre la configuración de contenedores, revisa:
1. Los logs de Docker: `docker-compose logs`
2. El estado de los contenedores: `docker-compose ps`
3. La documentación de Next.js y Prisma
