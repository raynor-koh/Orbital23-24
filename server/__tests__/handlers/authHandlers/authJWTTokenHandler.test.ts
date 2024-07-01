import * as bcryptjs from "bcryptjs";
import { authJWTTokenHandler } from "../../../handlers/auth/authJWTTokenHandler";
import User from "../../../models/user";

jest.mock("../../../models/user");

const mockRequest = {
  user: "user_id",
  token: "token",
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

const user = {
  _id: "user_id",
  name: "user_name",
  email: "test@example.com",
  password: bcryptjs.hash("123456", 8),
};

describe("Test for authJWTTokenHandler", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });
  test("should return a user annd token on success", async () => {
    (User.findById as jest.Mock).mockResolvedValue(user);

    await authJWTTokenHandler(mockRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      user,
      token: mockRequest.token,
    });
  });

  test("should return 404 if user not found", async () => {
    (User.findById as jest.Mock).mockResolvedValue(null);

    await authJWTTokenHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User not found.",
    });
  });
});
