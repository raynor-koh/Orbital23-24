import { authTokenIsValidHandler } from "../../../handlers/auth/authTokenIsValidHandler";
import User from "../../../models/user";
import * as jwt from "jsonwebtoken";
import * as bcryptjs from "bcryptjs";

const userName = "User_Test";
const userEmail = "test@example.com";
const userPassword = "password";

// Mock Classes of the Functions to be mocked
jest.mock("../../../models/user");
jest.mock("jsonwebtoken");

const mockRequest = {
  header: jest.fn(),
};

const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
};

describe("Token Is Valid Tests", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return false if No Token", async () => {
    mockRequest.header.mockImplementation(() => undefined);

    await authTokenIsValidHandler(mockRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(401);
    expect(mockResponse.json).toHaveBeenCalledWith(false);
  });

  test("Should return false if Invalid Token", async () => {
    mockRequest.header.mockImplementation(() => "Invalid Token");
    (jwt.verify as jest.Mock).mockImplementation(() => null);

    await authTokenIsValidHandler(mockRequest, mockResponse);
    expect(mockRequest.header).toHaveBeenCalledWith("x-auth-token");
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(403);
    expect(mockResponse.json).toHaveBeenCalledWith(false);
  });

  test("Should return false if Valid Token but User Not Found", async () => {
    mockRequest.header.mockImplementation(() => "Valid Token");
    (jwt.verify as jest.Mock).mockImplementation(() => ({ userId: "123" }));
    (User.findById as jest.Mock).mockImplementation(() => null);

    await authTokenIsValidHandler(mockRequest, mockResponse);
    expect(mockRequest.header).toHaveBeenCalledWith("x-auth-token");
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(404);
    expect(mockResponse.json).toHaveBeenCalledWith(false);
  });

  test("Should return true if Valid Token and User Found", async () => {
    const user = {
      _id: "123",
      email: userEmail,
      name: userName,
      password: await bcryptjs.hash(userPassword, 8),
    };
    mockRequest.header.mockImplementation(() => "Valid Token");
    (jwt.verify as jest.Mock).mockImplementation(() => ({ userId: "123" }));
    (User.findById as jest.Mock).mockImplementation(() => user);

    await authTokenIsValidHandler(mockRequest, mockResponse);
    expect(mockRequest.header).toHaveBeenCalledWith("x-auth-token");
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith(true);
  });

  // test("Shoulfd return 500 if error occurs", async () => {
  //   mockRequest.header.mockImplementation(() => "Valid Token");
  //   (jwt.verify as jest.Mock).mockImplementation(() => {
  //     throw new Error("Test Error");
  //   });

  //   await authTokenIsValidHandler(mockRequest, mockResponse);
  //   expect(mockResponse.status).toHaveBeenCalledWith(500);
  //   expect(mockResponse.json).toHaveBeenCalledWith(
  //     expect.objectContaining({ error: expect.any(Error) })
  //   );
  // });
});
