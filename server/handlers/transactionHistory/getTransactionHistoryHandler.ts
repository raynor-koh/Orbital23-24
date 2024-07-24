import { User, Transaction } from "../../models";
export const getTransactionHistoryHandler = async (
  request: any,
  response: any
) => {
  const userId = request.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return response.status(404).json({ message: "User not found" });
    }
    const transactions = await Transaction.find({ userId: userId }).sort({
      timeStamp: -1,
    });
    return response.status(200).json({ transactions: transactions });
  } catch (error) {
    console.error("Error fetching transaction history: ", error);
    response.status(500).json({ error: "Error fetching transaction history" });
    return;
  }
};
