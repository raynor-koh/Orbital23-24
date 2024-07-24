import User from "../../models/user";
import UserPosition from "../../models/userPosition";

export const getUserPositionHandler = async (request: any, response: any) => {
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
};
