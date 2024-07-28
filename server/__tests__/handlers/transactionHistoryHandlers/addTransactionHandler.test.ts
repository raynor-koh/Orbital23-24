import { addTransactionHandler } from "../../../handlers/transactionHistory";
import { User, Transaction } from "../../../models";

// Mock models
jest.mock("../../../models/user");
jest.mock("../../../models/transaction");

const validUserId = "valid-user-id";
const invalidUserId = "invalid-user-id";
const date = Date.now();

const mockRequest = {
  params: { id: validUserId },
  body: {
    symbol: "AAPL",
    name: "Apple Inc",
    quantity: 10,
    price: 100,
    timeStamp: date,
    isBuy: true,
  },
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Unit tests for addTransactionHandler", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return 404 when use is not found", async () => {
    const invalidUserIdRequest = {
      ...mockRequest,
      params: { id: invalidUserId },
    };

    (User.findById as jest.Mock).mockResolvedValue(null);
    await addTransactionHandler(invalidUserIdRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User not found",
    });
  });

  test("Should return 200 when transaction added to database", async () => {
    (User.findById as jest.Mock).mockResolvedValue({ id: validUserId });
    (Transaction.prototype.save as jest.Mock).mockResolvedValue({
      userId: validUserId,
      symbol: "AAPL",
      name: "Apple Inc",
      quantity: 10,
      price: 100,
      timeStamp: date,
      isBuy: true,
    });
    await addTransactionHandler(mockRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Transaction added to database",
    });
    expect(Transaction).toHaveBeenCalledWith({
      userId: validUserId,
      symbol: "AAPL",
      name: "Apple Inc",
      quantity: 10,
      price: 100,
      timeStamp: date,
      isBuy: true,
    });
  });
});
