import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    console.log('Testing database connection...');
    console.log('DATABASE_URL:', process.env.DATABASE_URL);
    
    // First try to query something simple
    const count = await prisma.$queryRaw`SELECT 1+1 as result`;
    console.log('Basic query result:', count);
    
    // Then try to create a record
    const test = await prisma.example.create({
      data: {
        name: 'Test Entry'
      }
    });

    return NextResponse.json({ message: 'Database is connected!', data: test });
  } catch (error) {
    console.error('Database connection error details:', error);
    return NextResponse.json(
      { 
        error: 'Failed to connect to database', 
        details: error instanceof Error ? error.message : 'Unknown error'
      },
      { status: 500 }
    );
  }
} 