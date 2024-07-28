import { resetBalanceHandler } from "../../../handlers/userdata";
import { User, UserPosition } from "../../../models";

// Mock models
jest.mock("../../../models/user");
jest.mock("../../../models/userPosition");

const validUserId = "valid_user";
const invalidUserId = "invalid_user";

const mockRequest = {
  params: { id: validUserId },
  body: {
    amount: 1000,
  },
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Unit tests for resetUserBalance handler", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return 404 when user not found", async () => {
    const invalidUserRequest = {
      ...mockRequest,
      params: { id: invalidUserId },
    };
    (User.findById as jest.Mock).mockResolvedValue(null);
    await resetBalanceHandler(invalidUserRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User not found",
    });
  });

  test("Should return 404 when user position not found", async () => {
    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.findOne as jest.Mock).mockResolvedValue(null);
    await resetBalanceHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "UserPosition not found",
    });
  });

  test("Should return 400 when no changes were made to the user position", async () => {
    const userPosition = {
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
    (UserPosition.findOne as jest.Mock).mockResolvedValue(userPosition);
    (UserPosition.updateOne as jest.Mock).mockResolvedValue({
      modifiedCount: 0,
    });
    await resetBalanceHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(400);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "No changes were made to the user position",
    });
  });

  test("Should return 200 when successfully reset", async () => {
    const userPosition = {
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
    (UserPosition.findOne as jest.Mock).mockResolvedValue(userPosition);
    (UserPosition.updateOne as jest.Mock).mockResolvedValue({
      modifiedCount: 1,
    });
    await resetBalanceHandler(mockRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User position reset to 1000",
    });
  });
});
