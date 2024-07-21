import * as mongoose from "mongoose";

// Structure of Transaction Document
const transactionSchema = new mongoose.Schema({
  userId: { required: true, type: String, trim: true },
  symbol: { required: true, type: String, trim: true },
  name: { required: true, type: String, trim: true },
  quantity: { required: true, type: Number },
  price: { required: true, type: Number },
  timeStamp: { required: true, type: Date },
  isBuy: { required: true, type: Boolean },
});

// Convert schema into a model
const Transaction = mongoose.model("Transaction", transactionSchema);

export default Transaction;
