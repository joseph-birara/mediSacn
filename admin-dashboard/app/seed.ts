import { MongoClient } from 'mongodb';

const uri: string = process.env.MONGODB_URI || '';
const options = {};

const client = new MongoClient(uri, options);

async function main() {
  try {
    await client.connect();
    const db = client.db('your-database-name'); // Replace with your actual database name

    // Define your seed data
    const adminData = {
      name: 'Admin User',
      email: 'admin@example.com',
      password: 'hashed_password', // Use a real hashed password here
    };

    // Insert admin user into the collection
    await db.collection('users').insertOne(adminData);

    console.log('Seeding completed');
  } catch (e) {
    console.error(e);
  } finally {
    await client.close();
  }
}

main();
