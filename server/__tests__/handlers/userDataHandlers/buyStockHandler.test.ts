import { buyStockHandler } from "../../../handlers/userdata";
import { User, UserPosition } from "../../../models";

// Mock models
jest.mock("../../../models/user");
jest.mock("../../../models/userPosition");

const validUserId = "valid_user";
const invalidUserId = "invalid_user";

const mockRequest = {
  params: { userId: validUserId },
  body: {
    symbol: "AAPL",
    name: "Apple Inc.",
    quantity: 10,
    price: 100,
  },
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Unit tests for buyStockHandler", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return 404 when user not found", async () => {
    const invalidUserIdRequest = {
      ...mockRequest,
      params: { userId: invalidUserId },
    };

    (User.findById as jest.Mock).mockResolvedValue(null);
    await buyStockHandler(invalidUserIdRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User not found",
    });
  });

  test("Should return 404 when userPosition is not found", async () => {
    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.findOne as jest.Mock).mockResolvedValue(null);
    await buyStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User position not found",
    });
  });

  test("Should return 400 when insufficient buying power", async () => {
    const invalidBuyingPower = {
      buyingPower: 0,
      accountBalance: 0,
      accountPosition: [],
    };
    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.findOne as jest.Mock).mockResolvedValue(invalidBuyingPower);
    await buyStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(400);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Insufficient buying power",
    });
  });

  test("Should return 200 when buying a new stock", async () => {
    const buyNewStock = {
      buyingPower: 5000,
      accountBalance: 0,
      accountPosition: [],
      save: jest.fn().mockResolvedValue(true),
    };
    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.findOne as jest.Mock).mockResolvedValue(buyNewStock);
    await buyStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Buy order executed successfully",
    });

    // Verify that the UserPosition was updated correctly
    expect(buyNewStock.buyingPower).toBe(4000); // 5000 - (10 * 100)
    expect(buyNewStock.accountPosition).toEqual([
      {
        symbol: "AAPL",
        name: "Apple Inc.",
        quantity: 10,
        price: 100,
      },
    ]);
    expect(buyNewStock.save).toHaveBeenCalled();
  });

  test("Should return 200 when buying existing stock", async () => {
    const buyExistingStock = {
      buyingPower: 5000,
      accountBalance: 0,
      accountPosition: [
        {
          symbol: "AAPL",
          name: "Apple Inc.",
          quantity: 5,
          price: 90,
        },
      ],
      save: jest.fn().mockResolvedValue(true),
    };
    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.findOne as jest.Mock).mockResolvedValue(buyExistingStock);
    await buyStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Buy order executed successfully",
    });

    // Verify that the UserPosition was updated correctly
    expect(buyExistingStock.buyingPower).toBe(4000); // 5000 - (10 * 100)
    expect(buyExistingStock.accountPosition).toEqual([
      {
        symbol: "AAPL",
        name: "Apple Inc.",
        quantity: 15, // 5 + 10
        price: 94,
      },
    ]);
    expect(buyExistingStock.save).toHaveBeenCalled();
  });
});
