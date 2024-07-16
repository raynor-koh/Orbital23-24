import * as express from "express";

const transactionRouter = express.Router();

import {
  addTransactionHandler,
  getTransactionHistoryHandler,
  resetTransactionHistoryHandler,
} from "../handlers/transactionHistory";

// Get Transaction History
transactionRouter.get("/:id", getTransactionHistoryHandler);

// Reset Transaction History
transactionRouter.get("/reset/:id", resetTransactionHistoryHandler);

// Add Transaction
transactionRouter.post("/add/:id", addTransactionHandler);

export default transactionRouter;
