import * as express from "express";

const userRouter = express.Router();

import {
  getUserPositionHandler,
  buyStockHandler,
  sellStockHandler,
  resetBalanceHandler,
} from "../handlers/userdata";

// Get User Position
userRouter.get("/:id", getUserPositionHandler);

// Buy Stocks (Add position)
userRouter.post("/buyStock/:id", buyStockHandler);

// Sell Stocks (Sell position)
userRouter.post("/sellStock/:id", sellStockHandler);

// Reset Balance
userRouter.post("/resetBalance/:id", resetBalanceHandler);

export default userRouter;
