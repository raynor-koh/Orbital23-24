import User from "../../models/user";
import UserPosition from "../../models/userPosition";

export const sellStockHandler = async (request: any, response: any) => {
  try {
    const userId = request.params.id;
    const symbol = request.body.symbol;
    const name = request.body.name;
    const quantity = request.body.quantity;
    const price = request.body.price;
    const user = await User.findById(userId);

    if (!user) {
      return response.status(404).json({ message: "User not found" });
    }
    const userPositionSearch = await UserPosition.find({ userId: userId });
    if (!userPositionSearch) {
      return response.status(404).json({ message: "User Position not found" });
    }

    // Parse DB data
    let userPositionData = userPositionSearch[0];
    let accountBalance = userPositionData.accountBalance;
    let buyingPower = userPositionData.buyingPower;
    let accountPosition = userPositionData.accountPosition;

    // Check if stock exists
    const stockExists = accountPosition.find((position) => {
      position.name === name && position.symbol === symbol;
    });

    if (!stockExists) {
      return response
        .status(404)
        .json({ message: "You do not own this stock" });
    }

    // Check if sufficient quantity owned
    const stockQuantity = stockExists.quantity;
    if (stockQuantity < quantity) {
      return response
        .status(404)
        .json({ message: "You do not own sufficient quantity of this" });
    }

    buyingPower += quantity * price;

    const remainingQuantity = stockQuantity - quantity;
    // If no stock remaining, remove from position
    if (remainingQuantity == 0) {
      accountPosition.pull(stockExists);
    } else {
      // Else, update quantity
      const totalBuyCost = stockExists.quantity * stockExists.price;
      const newBuyCost = totalBuyCost - quantity * price;
      const newBuyPrice = newBuyCost / remainingQuantity;
      stockExists.quantity = remainingQuantity;
      stockExists.price = newBuyPrice;
    }
    userPositionData.buyingPower = buyingPower;
    await userPositionData.save();
    return response
      .status(200)
      .json({ message: "Sell order successfully executed" });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    return;
  }
};
