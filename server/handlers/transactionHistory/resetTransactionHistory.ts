import { User, Transaction } from "../../models";

export const resetTransactionHistoryHandler = async (
  request: any,
  response: any
) => {
  const userId = request.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return response.status(404).json({ message: "User not found" });
    }

    // Delete all transaction documents belonging to user
    await Transaction.deleteMany({ userId: userId });

    return response.status(200).json({ message: "Transaction history reset" });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    return;
  }
};
