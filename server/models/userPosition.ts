import * as mongoose from "mongoose";

// Structure of userData Document
const userPositionSchema = new mongoose.Schema({
  userId: { required: true, readonly: true, type: String, trim: true },
  accountBalance: { required: true, type: Number },
  accountPosition: {
    type: [
      {
        name: String,
        label: String,
        quantity: Number,
        buyPrice: Number,
      },
    ],
  },
  buyingPower: { required: true, type: Number },
});

// Convert schema into a model
const UserPosition = mongoose.model("UserPosition", userPositionSchema);

export default UserPosition;
