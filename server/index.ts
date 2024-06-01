import * as dotenv from "dotenv";
import express from "express";
import mongoose from "mongoose";
import authRouter from "./routes/auth";

dotenv.config({ path: "../.env" });

const PORT = parseInt(process.env.PORT as string, 10) || 3000;
const app = express();
app.use(express.json());
app.use(authRouter);

const DB = process.env.MONGODB_DATABASE as string;

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successful");
  })
  .catch((error) => {
    console.log(error);
  });

app.use(express.json());
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
