import { getUserPositionHandler } from "../../../handlers/userdata/getUserPositionHandler";
import User from "../../../models/user";
import UserPosition from "../../../models/userPosition";

// Mock models
jest.mock("../../../models/user");
jest.mock("../../../models/userPosition");

const validUserId = "valid_user";
const invalidUserId = "invalid_user";

const mockRequest = {
  params: { userId: validUserId },
};
const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Retrieve user position Test", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return 404 when userId is invalid", async () => {
    const invalidUserIdRequest = {
      ...mockRequest,
      params: { ...mockRequest.params, userId: invalidUserId },
    };

    (User.findById as jest.Mock).mockResolvedValue(null);
    await getUserPositionHandler(invalidUserIdRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({ error: "User not found" });
  });

  test("Should return 404 when userPosition is not found", async () => {
    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.find as jest.Mock).mockResolvedValue(null);
    await getUserPositionHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      error: "User position not found",
    });
  });

  test("Should return 200 when userPosition is found", async () => {
    const userPosition = {
      userId: validUserId,
      accountBalance: 1,
      accountPosition: [],
      buyingPower: 0,
    };
    (User.findById as jest.Mock).mockResolvedValue(
      new User({ id: validUserId })
    );
    (UserPosition.find as jest.Mock).mockResolvedValue([userPosition]);
    await getUserPositionHandler(mockRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      userPosition: userPosition,
    });
  });
});
