import { ObjectId } from "mongodb";
import clientPromise from "../../../../lib/mongodb";
import { NextResponse } from 'next/server';

// Handle GET requests
export async function GET() {
  const client = await clientPromise;
  const db = client.db("KalabApp");
  const doctors = await db.collection("doctors").find({}).toArray();
  return NextResponse.json(doctors, { status: 200 });
}

// Handle POST requests
export async function POST(req: Request) {
  const client = await clientPromise;
  const db = client.db("KalabApp");

  const body = await req.json();
  const newDoctor = body;
  
  await db.collection("doctors").insertOne(newDoctor);
  return NextResponse.json(newDoctor, { status: 201 });
}

// Handle DELETE requests
export async function DELETE(req: Request) {
  const client = await clientPromise;
  const db = client.db("KalabApp");

  const { searchParams } = new URL(req.url);
  const id = searchParams.get("id");

  await db.collection("doctors").deleteOne({ _id: new ObjectId(id as string) });

  // Return 204 with no content
  return new NextResponse(null, { status: 204 });
}