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

```mermaid
# Credit Card Management System Database Schema

This project implements a comprehensive database schema for managing credit cards, transactions, and related financial data. The system supports AI-powered transaction categorization, notification preferences, and detailed tracking of credit card activities.

## 📊 Database Schema Diagram

```mermaid
erDiagram
    User ||--o{ CreditCard : has
    User ||--o{ Category : creates
    User ||--o{ Tag : creates
    User ||--|| NotificationPreference : has

    CreditCard ||--o{ Transaction : contains
    CreditCard ||--o{ RecurringCharge : has
    CreditCard ||--o{ InterestCharge : tracks
    CreditCard ||--o{ Note : has

    Transaction }o--o| Category : categorized_in
    Transaction }o--o{ Tag : tagged_with
    
    User {
        string id PK
        string email UK
        string name
        datetime createdAt
        datetime updatedAt
    }

    CreditCard {
        string id PK
        string userId FK
        string name
        string lastFourDigits
        float currentBalance
        float creditLimit
        float apr
        int dueDate
        boolean isActive
        float rewardRate
        int statementDate
        float minimumPayment
        datetime createdAt
        datetime updatedAt
    }

    Transaction {
        string id PK
        string creditCardId FK
        float amount
        string description
        datetime date
        string categoryId FK
        boolean isRecurring
        string originalText
        boolean aiProcessed
        float aiConfidence
        json aiSuggestions
        datetime createdAt
        datetime updatedAt
    }

    Category {
        string id PK
        string userId FK
        string name
        string color
        string icon
        datetime createdAt
        datetime updatedAt
    }

    Tag {
        string id PK
        string userId FK
        string name
    }

    InterestCharge {
        string id PK
        string creditCardId FK
        float amount
        datetime date
        datetime createdAt
    }

    RecurringCharge {
        string id PK
        string creditCardId FK
        float amount
        string description
        int dayOfMonth
        boolean isActive
        datetime lastCharged
        datetime nextDueDate
        datetime createdAt
        datetime updatedAt
    }

    Note {
        string id PK
        string creditCardId FK
        string content
        boolean isPinned
        datetime createdAt
        datetime updatedAt
    }

    NotificationPreference {
        string id PK
        string userId FK
        boolean paymentReminders
        int daysBeforeDue
        boolean statementReminders
        boolean highBalanceAlert
        float highBalanceThreshold
        boolean unusualActivity
        datetime createdAt
        datetime updatedAt
    }

    ProcessedDocument {
        string id PK
        string fileName
        string originalName
        string status
        string errorMessage
        int pageCount
        string mimeType
        datetime processedAt
        datetime createdAt
        datetime updatedAt
    }
```

## 🗄️ Core Models

### User
- Central user model with authentication and profile information
- One-to-many relationship with credit cards, categories, and tags
- One-to-one relationship with notification preferences

### CreditCard
- Stores credit card details including balance, limit, and APR
- Tracks statement dates and minimum payments
- Contains reward rate information
- Links to transactions, recurring charges, and interest charges

### Transaction
- Records individual credit card transactions
- Supports AI-powered categorization with confidence scoring
- Can be tagged for flexible organization
- Maintains original transaction text for reference

### Category & Tag
- Flexible categorization system
- Categories include visual elements (color and icon)
- Tags allow for additional transaction organization
- Many-to-many relationship between transactions and tags

## 🔔 Notification System

The `NotificationPreference` model supports:
- Payment due date reminders
- Statement closing date alerts
- High balance warnings
- Unusual activity detection

## 📝 Notes & Documentation

- `Note` model for card-specific annotations
- `ProcessedDocument` tracks uploaded statements
- Support for AI processing status and error handling

## 🤖 AI Integration

The schema supports AI-powered features:
- Transaction categorization
- Confidence scoring
- Multiple category suggestions
- Original text preservation
- Processing status tracking

## 🛠️ Technical Implementation

This schema is implemented using:
- Prisma as the ORM
- PostgreSQL as the database
- TypeScript for type safety
- NextJS for the application framework

## Getting Started

1. Install dependencies:
```bash
npm install
```

2. Set up your database URL in `.env`:
```
DATABASE_URL="postgresql://user:password@localhost:5432/dbname"
```

3. Run migrations:
```bash
npx prisma migrate dev
```

4. Generate Prisma Client:
```bash
npx prisma generate
```

## License

[Your License Here]
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