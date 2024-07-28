import * as dotenv from "dotenv";
import mongoose from "mongoose";
import { createApp } from "./createApp";

dotenv.config({ path: "../.env" });

const app = createApp();
const PORT = parseInt(process.env.PORT as string, 10) || 3000;

const DB = process.env.MONGODB_DATABASE as string;

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successful");
  })
  .catch((error) => {
    console.error("Database connection error: ", error);
    process.exit(1); // Exit process with failure code.
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
