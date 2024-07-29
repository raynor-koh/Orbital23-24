import { getTransactionHistoryHandler } from "../../../handlers/transactionHistory";
import { User, Transaction } from "../../../models";

// Mock models
jest.mock("../../../models/user");
jest.mock("../../../models/transaction");

const validUserId = "valid-user-id";
const invalidUserId = "invalid-user-id";

const mockRequest = {
  params: { id: validUserId },
  body: {},
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Unit tests for getTransactionHistoryHandler", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return 404 when user not found", async () => {
    const invalidUserIdRequest = {
      ...mockRequest,
      params: { id: invalidUserId },
    };

    (User.findById as jest.Mock).mockResolvedValue(null);
    await getTransactionHistoryHandler(invalidUserIdRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User not found",
    });
  });

  test("Should return 200 when transaction history is found", async () => {
    const mockTransactions: any = [];
    (User.findById as jest.Mock).mockResolvedValue({ _id: validUserId });
    const mockSort = jest.fn().mockResolvedValue(mockTransactions);
    const mockFind = jest.fn().mockReturnValue({ sort: mockSort });
    (Transaction.find as jest.Mock).mockImplementation(mockFind);

    await getTransactionHistoryHandler(mockRequest, mockResponse);

    expect(Transaction.find).toHaveBeenCalledWith({ userId: validUserId });
    expect(mockSort).toHaveBeenCalledWith({ timeStamp: -1 });
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      transactions: mockTransactions,
    });
  });

  test("Should return transactions sorted by timestamp in descending order", async () => {
    const mockTransactions = [
      { id: "1", timeStamp: new Date("2023-07-26") },
      { id: "2", timeStamp: new Date("2023-07-27") },
      { id: "3", timeStamp: new Date("2023-07-25") },
    ];
    (User.findById as jest.Mock).mockResolvedValue({ _id: validUserId });
    const mockSort = jest.fn().mockResolvedValue(mockTransactions);
    const mockFind = jest.fn().mockReturnValue({ sort: mockSort });
    (Transaction.find as jest.Mock).mockImplementation(mockFind);

    await getTransactionHistoryHandler(mockRequest, mockResponse);

    expect(Transaction.find).toHaveBeenCalledWith({ userId: validUserId });
    expect(mockSort).toHaveBeenCalledWith({ timeStamp: -1 });
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      transactions: mockTransactions,
    });
  });

  test("Should return empty array when user has no transactions", async () => {
    const mockTransactions: any = [];
    (User.findById as jest.Mock).mockResolvedValue({ _id: validUserId });
    const mockSort = jest.fn().mockResolvedValue(mockTransactions);
    const mockFind = jest.fn().mockReturnValue({ sort: mockSort });
    (Transaction.find as jest.Mock).mockImplementation(mockFind);

    await getTransactionHistoryHandler(mockRequest, mockResponse);

    expect(Transaction.find).toHaveBeenCalledWith({ userId: validUserId });
    expect(mockSort).toHaveBeenCalledWith({ timeStamp: -1 });
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      transactions: mockTransactions,
    });
  });
});
