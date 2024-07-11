import User from "../../models/user";
import UserPosition from "../../models/userPosition";

export const buyStockHandler = async (request: any, response: any) => {
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

    const userPositionData = await UserPosition.findOne({ userId: userId });
    if (!userPositionData) {
      return response.status(404).json({ message: "User position not found" });
    }
    // Parse DB data
    let accountBalance = userPositionData.accountBalance;
    console.log(userPositionData.buyingPower);
    let buyingPower = userPositionData.buyingPower;
    let accountPosition = userPositionData.accountPosition;

    // Check if buying power enough to execute buy order
    const cost = quantity * price;
    if (buyingPower < cost) {
      return response
        .status(400)
        .json({ message: "Insufficient buying power" });
    }
    // Check if stock exists in current portfolio
    const stockExists = accountPosition.find((position) => {
      return position.name == name && position.symbol == symbol;
    });
    if (!stockExists) {
      // Add new stock to portfolio
      const newPosition = { symbol, name, quantity, price };
      accountPosition.push(newPosition);
      buyingPower -= cost;
    } else {
      // Update stock quantity
      stockExists.quantity += quantity;
      buyingPower -= cost;
      const totalBuyCost = stockExists.quantity * stockExists.price + cost;
      const newQuantity = stockExists.quantity + quantity;
      stockExists.price = totalBuyCost / newQuantity;
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
