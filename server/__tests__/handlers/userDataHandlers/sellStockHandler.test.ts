import { sellStockHandler } from "../../../handlers/userdata";
import { User, UserPosition } from "../../../models";

// Mock models
jest.mock("../../../models/user");
jest.mock("../../../models/userPosition");

const validUserId = "valid_user";
const invalidUserId = "invalid_user";

const mockRequest = {
  params: { id: validUserId },
  body: {
    symbol: "AAPL",
    name: "Apple Inc.",
    quantity: 5,
    price: 150,
  },
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Unit tests for sellStockHandler", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return 404 when user not found", async () => {
    const invalidUserIdRequest = {
      ...mockRequest,
      params: { userId: invalidUserId },
    };

    (User.findById as jest.Mock).mockResolvedValue(null);
    await sellStockHandler(invalidUserIdRequest, mockResponse);
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
    await sellStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User Position not found",
    });
  });

  test("Should return 404 when user does not own stock", async () => {
    const noStockOwned = {
      accountBalance: 0,
      buyingPower: 0,
      accountPosition: [],
    };

    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.find as jest.Mock).mockResolvedValue([noStockOwned]);
    await sellStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "You do not own this stock",
    });
  });

  test("Should return 404 when user does not own sufficient", async () => {
    const insufficientStockOwned = {
      accountBalance: 0,
      buyingPower: 0,
      accountPosition: [
        {
          symbol: "AAPL",
          name: "Apple Inc.",
          quantity: 2,
          price: 150,
        },
      ],
    };

    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.find as jest.Mock).mockResolvedValue([
      insufficientStockOwned,
    ]);
    await sellStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "You do not own sufficient quantity of this",
    });
  });

  test.todo("Should return 200 when selling all stock");

  test("Should return 200 when partial sale", async () => {
    const insufficientStockOwned = {
      accountBalance: 0,
      buyingPower: 0,
      accountPosition: [
        {
          symbol: "AAPL",
          name: "Apple Inc.",
          quantity: 12,
          price: 150,
        },
      ],
      save: jest.fn().mockResolvedValue(true),
    };

    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.find as jest.Mock).mockResolvedValue([
      insufficientStockOwned,
    ]);
    await sellStockHandler(mockRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Sell order successfully executed",
    });
    // Verify that the UserPosition was updated correctly
    expect(insufficientStockOwned.buyingPower).toBe(750); // 5000 - (10 * 100)
    expect(insufficientStockOwned.accountPosition).toEqual([
      {
        symbol: "AAPL",
        name: "Apple Inc.",
        quantity: 7,
        price: 150,
      },
    ]);
    expect(insufficientStockOwned.save).toHaveBeenCalled();
  });
});
