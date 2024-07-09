import User from "../../models/user";
import UserPosition from "../../models/userPosition";

export const resetBalanceHandler = async (request: any, response: any) => {
  try {
    const userId = request.params.id;
    const resetAmount = request.body.amount;
    const user = await User.findById(userId);
    if (!user) {
      return response.status(404).json({ message: "User not found" });
    }

    // Find userPosition document
    const userPosition = await UserPosition.findOne({ userId: userId });
    if (!userPosition) {
      return response.status(404).json({ message: "UserPosition not found" });
    }

    // Reset balance
    const result = await UserPosition.updateOne(
      { userId: userId },
      {
        $set: {
          accountBalance: resetAmount,
          accountPosition: [],
          buyingPower: resetAmount,
        },
      }
    );

    if (result.modifiedCount == 0) {
      return response
        .status(400)
        .json({ message: "No changes were made to the UserPosition" });
    }
    return response
      .status(200)
      .json({ message: `UserPosition resetted to ${resetAmount}` });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    return;
  }
};
