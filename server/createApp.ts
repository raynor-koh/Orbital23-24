import express from "express";
import authRouter from "./routes/auth";
import userRouter from "./routes/user";
import transactionRouter from "./routes/transaction";
import cors from "cors";

export function createApp() {
  const app = express();
  app.use(cors());
  app.use(express.json());
  app.use(authRouter);
  app.use("/user", userRouter);
  app.use("/transaction", transactionRouter);
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

  return app;
}
