import * as express from "express";

const userRouter = express.Router();

import User from "../models/user";
import UserPosition from "../models/userPosition";

userRouter.get("/:id", async (request, response) => {
  const userId = request.params.id;
  const user = await User.findById(userId);
  if (!user) {
    return response.status(404).json({ error: "User not found" });
  }
  const userPosition = await UserPosition.find({ userId: userId });
  if (!userPosition) {
    return response.status(404).json({ error: "User position not found" });
  }
  response.status(200).json({ userPosition: userPosition[0] });
});

export default userRouter;
