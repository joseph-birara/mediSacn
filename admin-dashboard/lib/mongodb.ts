import { MongoClient } from 'mongodb';

// Use a string literal type for the MongoDB URI
const uri: string = process.env.MONGODB_URI || '';
const options = {};

let client: MongoClient;
let clientPromise: Promise<MongoClient>;

if (typeof globalThis._mongoClientPromise === 'undefined') {
  client = new MongoClient(uri, options);
  globalThis._mongoClientPromise = client.connect();
}

clientPromise = globalThis._mongoClientPromise;

export default clientPromise;
