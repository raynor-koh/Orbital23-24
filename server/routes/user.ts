import * as express from "express";

const userRouter = express.Router();

import { userPositionHandler } from "../handlers/userdata/userPositionHandler";

userRouter.get("/:id", userPositionHandler);

export default userRouter;
