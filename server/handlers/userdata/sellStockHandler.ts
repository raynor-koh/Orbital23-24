import User from "../../models/user";
import UserPosition from "../../models/userPosition";

export const sellStockHandler = async (request: any, response: any) => {
  try {
    const userId = request.params.id;
    const sellStockPosition = request.body.sellStockPosition;
    const sellStockName = request.body.name;
    const sellStockLabel = request.body.label;
    const sellStockPrice = request.body.price;
    const sellStockQuantity = request.body.quantity;
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
      position.name === sellStockPosition.name;
    });

    if (!stockExists) {
      return response
        .status(404)
        .json({ message: "You do not own this stock" });
    }

    // Check if sufficient quantity owned
    const stockQuantity = stockExists.quantity;
    if (stockQuantity < sellStockPosition.quantity) {
      return response
        .status(404)
        .json({ message: "You do not own sufficient quantity of this" });
    }

    buyingPower += sellStockPosition.quantity * sellStockPosition.buyPrice;

    const remainingQuantity = stockQuantity - sellStockPosition.quantity;
    // If no stock remaining, remove from position
    if (remainingQuantity == 0) {
      accountPosition.pull(stockExists);
    } else {
      // Else, update quantity
      const totalBuyCost = stockExists.quantity * stockExists.buyPrice;
      const newBuyCost =
        totalBuyCost - sellStockPosition.quantity * sellStockPosition.buyPrice;
      const newBuyPrice = newBuyCost / remainingQuantity;
      stockExists.quantity = remainingQuantity;
      stockExists.buyPrice = newBuyPrice;
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
