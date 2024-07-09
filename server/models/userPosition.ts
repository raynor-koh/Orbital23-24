import * as mongoose from "mongoose";

// Structure of userPosition Document
const userPositionSchema = new mongoose.Schema({
  userId: { required: true, readonly: true, type: String, trim: true },
  accountBalance: { required: true, type: Number },
  accountPosition: {
    type: [
      {
        name: { required: true, type: String },
        label: { required: true, type: String },
        quantity: { required: true, type: Number },
        buyPrice: { required: true, type: Number },
      },
    ],
  },
  buyingPower: { required: true, type: Number },
});

// Convert schema into a model
const UserPosition = mongoose.model("UserPosition", userPositionSchema);

export default UserPosition;
