import { authSignInHandler } from "../../../handlers/auth/authSignInHandler";
import User from "../../../models/user";
import * as bcryptjs from "bcryptjs";
import * as jwt from "jsonwebtoken";

// Mock Classes of the Functions to be mocked
jest.mock("../../../models/user");
jest.mock("bcryptjs");
jest.mock("jsonwebtoken");

const userEmail = "test01@example.com";
const userPassword = "password123";

const doesNotExistEmail = "test@example.com";
const incorrectPassword = "password456";

const mockRequest = {
  body: {
    email: userEmail,
    password: userPassword,
  },
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Sign In Tests", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should sign in if correct credentials", async () => {
    const correctCredentialsRequest = mockRequest;

    const user = {
      _id: "13456",
      email: userEmail,
      password: await bcryptjs.hash(userPassword, 8),
    };

    // Mock User.findOne to return a User
    (User.findOne as jest.Mock).mockResolvedValue(user);

    // Mock bcryptjs.compare
    (bcryptjs.compare as jest.Mock).mockResolvedValue(true);

    // Mock jwt.sign to return a token
    (jwt.sign as jest.Mock).mockReturnValue("fakeToken");

    await authSignInHandler(correctCredentialsRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith({
      token: "fakeToken",
      user: user,
    });
  });

  test("Should not sign in if email not found", async () => {
    const emailNotFoundRequest = {
      ...mockRequest,
      body: { ...mockRequest.body, email: doesNotExistEmail },
    };
    // Mock User.findOne to return null
    (User.findOne as jest.Mock).mockResolvedValue(null);

    await authSignInHandler(emailNotFoundRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User with this email does not exist!",
    });
  });

  test("Should not sign in if incorrect password", async () => {
    const incorrectPasswordRequest = {
      ...mockRequest,
      body: { ...mockRequest.body, password: incorrectPassword },
    };

    // User Credentials
    const user = {
      _id: "123456",
      email: userEmail,
      password: await bcryptjs.hash(userPassword, 8),
    };

    // Mock User.findOne to return a User
    (User.findOne as jest.Mock).mockResolvedValue(user);

    // Mock bcryptjs.compare
    (bcryptjs.compare as jest.Mock).mockResolvedValue(false);

    // Assertions
    await authSignInHandler(incorrectPasswordRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(403);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Incorrect password.",
    });
  });
});
