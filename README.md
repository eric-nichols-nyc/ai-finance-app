# Next.js 14 Finance App with Prisma and Docker

This project is a Next.js 14 application with Prisma ORM and PostgreSQL, running in Docker containers.

## Prerequisites

- Docker and Docker Compose installed on your machine (for local development)
- Node.js 20.x or later
- Yarn package manager

## Getting Started

### Local Development with Docker

1. Clone the repository:
```bash
git clone <repository-url>
cd <project-directory>
```

2. Install dependencies:
```bash
yarn install
```

3. Start the Docker containers:
```bash
docker-compose up --build
```

4. Run the initial Prisma migration:
```bash
docker-compose exec app npx prisma migrate dev --name init
```

The application should now be running at [http://localhost:3000](http://localhost:3000)

## Deployment on Vercel

### Prerequisites for Vercel Deployment
- A Vercel account
- A PostgreSQL database (Vercel Postgres, Supabase, Railway, etc.)

### Steps for Vercel Deployment

1. Create a PostgreSQL database in your preferred provider

2. Add the following environment variables in your Vercel project settings:
   ```env
   DATABASE_URL="your-production-database-url"
   ```

3. Update Prisma schema for production:
   ```prisma
   datasource db {
     provider = "postgresql"
     url      = env("DATABASE_URL")
     // Add this if using Vercel Postgres
     // directUrl = env("POSTGRES_URL_NON_POOLING")
   }
   ```

4. Deploy to Vercel:
   ```bash
   vercel
   ```

5. Run migrations on the production database:
   ```bash
   vercel env pull .env.production
   npx prisma migrate deploy
   ```

### Local Development without Docker (for Vercel deployment testing)

1. Create a `.env.local` file:
   ```env
   DATABASE_URL="your-local-database-url"
   ```

2. Install dependencies:
   ```bash
   yarn install
   ```

3. Run migrations:
   ```bash
   npx prisma migrate dev
   ```

4. Start the development server:
   ```bash
   yarn dev
   ```

## Testing the Setup

You can test if everything is working correctly by visiting:
- [http://localhost:3000](http://localhost:3000) - Main application
- [http://localhost:3000/api/test](http://localhost:3000/api/test) - API endpoint that tests database connectivity

## Development Commands

```bash
# Start the application in development mode
docker-compose up

# Stop the application
docker-compose down

# View logs
docker-compose logs -f

# Run Prisma commands
docker-compose exec app npx prisma <command>

# Create a new migration
docker-compose exec app npx prisma migrate dev --name <migration-name>

# Reset the database
docker-compose exec app npx prisma migrate reset

# Generate Prisma Client
docker-compose exec app npx prisma generate
```

## Project Structure

```
.
├── src/
│   ├── app/              # Next.js app directory
│   ├── lib/              # Shared libraries
│   └── ...
├── prisma/
│   └── schema.prisma     # Database schema
├── docker-compose.yml    # Docker composition
├── Dockerfile           # Docker configuration
└── ...
```

## Environment Variables

### Development (Docker)
```env
DATABASE_URL="postgresql://postgres:postgres@db:5432/finance"
```

### Production (Vercel)
```env
DATABASE_URL="your-production-database-url"
# If using Vercel Postgres, you might also need:
# POSTGRES_URL_NON_POOLING="your-direct-connection-url"
```

## Troubleshooting

1. If you see database connection errors:
   - Ensure the database container is running: `docker-compose ps`
   - Check database logs: `docker-compose logs db`
   - Verify migrations are applied: `docker-compose exec app npx prisma migrate status`

2. If you need to reset everything:
   ```bash
   docker-compose down -v  # This will remove volumes too
   docker-compose up --build
   docker-compose exec app npx prisma migrate dev --name init
   ```

3. Vercel deployment issues:
   - Ensure environment variables are correctly set in Vercel
   - Check if migrations have been run on the production database
   - Verify database connection string format