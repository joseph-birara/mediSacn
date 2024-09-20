import { ObjectId } from "mongodb";
import clientPromise from "../../../../lib/mongodb";
import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const client = await clientPromise;
  const db = client.db("KalabApp");

  switch (req.method) {
    case "GET":
      const doctors = await db.collection("doctors").find({}).toArray();
      res.status(200).json(doctors);
      break;
    case "POST":
      const newDoctor = req.body;
      await db.collection("doctors").insertOne(newDoctor);
      res.status(201).json(newDoctor);
      break;
    case "DELETE":
      const { id } = req.query;
      await db.collection("doctors").deleteOne({ _id: new ObjectId(id as string) });
      res.status(204).end();
      break;
    default:
      res.setHeader("Allow", ["GET", "POST", "DELETE"]);
      res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}
