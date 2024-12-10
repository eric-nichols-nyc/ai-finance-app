FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Add build dependencies for Prisma
RUN apk add --no-cache libc6-compat openssl
WORKDIR /app

# Install dependencies
COPY package.json yarn.lock* ./
RUN yarn --frozen-lockfile
# Generate Prisma Client
COPY prisma ./prisma
RUN npx prisma generate

# Development image, copy all the files and run next dev
FROM base AS development
WORKDIR /app
# Add openssl for Prisma in development
RUN apk add --no-cache openssl
COPY --from=deps /app/node_modules ./node_modules
COPY . .
CMD ["yarn", "dev"]

# Production image, copy all the files and run next build
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build

# Production image, copy only the necessary files
FROM base AS production
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Add openssl for Prisma in production
RUN apk add --no-cache openssl

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
# Copy Prisma schema and generated client
COPY --from=builder /app/prisma ./prisma
COPY --from=deps /app/node_modules/.prisma ./node_modules/.prisma

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME localhost

CMD ["node", "server.js"] 