import * as dotenv from "dotenv";
import express from "express";
import mongoose from "mongoose";
import authRouter from "./routes/auth";
import userRouter from "./routes/user";
import transactionRouter from "./routes/transaction";
import cors from "cors";

dotenv.config({ path: "../.env" });

const PORT = parseInt(process.env.PORT as string, 10) || 3000;
const app = express();
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use("/user", userRouter);
app.use("/transaction", transactionRouter);

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

app.use(express.json());
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});

// Centralised error handling middleware
app.use(
  (
    error: any,
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ) => {
    console.error(error.stack);
    res.status(error.status || 500).json({
      error: {
        message: error.message || "Internal Server Error",
      },
    });
  }
);
