/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuración para contenedores Docker
  output: 'standalone',
  
  // Configuración de imágenes para Docker
  images: {
    domains: ['localhost'],
    unoptimized: true
  },
  
  // Variables de entorno públicas
  env: {
    NEXTAUTH_URL: process.env.NEXTAUTH_URL,
  },
  
  experimental: {
    appDir: true,
  },
  typescript: {
    ignoreBuildErrors: false,
  },
  eslint: {
    ignoreDuringBuilds: false,
  },
}

module.exports = nextConfig
