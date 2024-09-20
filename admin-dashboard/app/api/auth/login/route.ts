// app/api/auth/login/route.ts
import { NextRequest, NextResponse } from 'next/server';
import clientPromise from '../../../../lib/mongodb';

export async function POST(req: NextRequest) {
  const { email, password } = await req.json();

  const client = await clientPromise;
  const db = client.db('KalabApp'); // Use your database name

  const user = await db.collection('users').findOne({ email });

  if (user && user.password === password) {
    return NextResponse.json({ message: 'Login successful', role: user.role });
  } else {
    return NextResponse.json({ message: 'Invalid email or password' }, { status: 401 });
  }
}
