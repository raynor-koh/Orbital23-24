import User from "../../models/user";
import UserPosition from "../../models/userPosition";

export const buyStockHandler = async (request: any, response: any) => {
  try {
    const userId = request.params.id;
    const buyStockPosition = request.body.position;
    const user = await User.findById(userId);
    if (!user) {
      return response.status(404).json({ message: "User not found" });
    }

    const userPositionData = await UserPosition.findOne({ userId: userId });
    if (!userPositionData) {
      return response.status(404).json({ message: "User position not found" });
    }
    // Parse DB data
    let accountBalance = userPositionData.accountBalance;
    let buyingPower = userPositionData.buyingPower;
    let accountPosition = userPositionData.accountPosition;

    // Check if buying power enough to execute buy order
    const buyCost = buyStockPosition.quantity * buyStockPosition.buyPrice;
    if (buyingPower < buyCost) {
      return response
        .status(400)
        .json({ message: "Insufficient buying power" });
    }

    // Check if stock exists in current portfolio
    const stockExists = accountPosition.find((position) => {
      position.name == buyStockPosition.name;
    });

    if (!stockExists) {
      // Add new stock to portfolio
      accountPosition.push(buyStockPosition);
      buyingPower -= buyCost;
    } else {
      // Update stock quantity
      stockExists.quantity += buyStockPosition.quantity;
      buyingPower -= buyCost;
      const totalBuyCost =
        stockExists.quantity * stockExists.buyPrice + buyCost;
      const newQuantity = stockExists.quantity + buyStockPosition.quantity;
      stockExists.buyPrice = totalBuyCost / newQuantity;
    }

    // Update database
    userPositionData.accountPosition = accountPosition;
    userPositionData.buyingPower = buyingPower;

    await userPositionData.save();
    return response
      .status(200)
      .json({ message: "Buy order executed successfully" });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    return;
  }
};
