import { NextRequest, NextResponse } from 'next/server';
import clientPromise from '../../../../lib/mongodb';

export async function GET(req: NextRequest) {
  const client = await clientPromise;
  const db = client.db('KalabApp'); // Use your database name

  const patients = await db.collection('patients').find({}).toArray();

  return NextResponse.json(patients);
}
 