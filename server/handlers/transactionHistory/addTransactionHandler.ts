import { Transaction, User } from "../../models";

export const addTransactionHandler = async (request: any, response: any) => {
  const userId = request.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return response.status(404).json({ message: "User not found" });
    }

    const symbol = request.body.symbol;
    const name = request.body.name;
    const quantity = request.body.quantity;
    const price = request.body.price;
    const timeStamp = request.body.timeStamp;

    // Create Transaction Object
    let transaction = new Transaction({
      userId: userId,
      symbol: symbol,
      name: name,
      quantity: quantity,
      price: price,
      timeStamp: timeStamp,
    });

    // Save user and retrieve documentId
    transaction = await transaction.save();
    return response
      .status(200)
      .json({ message: "Transaction added to database" });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
  }
};
