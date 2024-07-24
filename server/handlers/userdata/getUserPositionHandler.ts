import { User, UserPosition } from "../../models";

export const getUserPositionHandler = async (request: any, response: any) => {
  const userId = request.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return response.status(404).json({ error: "User not found" });
    }
    const userPosition = await UserPosition.find({ userId: userId });
    if (!userPosition) {
      return response.status(404).json({ error: "User position not found" });
    }
    response.status(200).json({ userPosition: userPosition[0] });
    return;
  } catch (error) {
    console.error("Error fetching user position: ", error);
    response.status(500).json({ error: "Error fetching user position" });
    return;
  }
};
