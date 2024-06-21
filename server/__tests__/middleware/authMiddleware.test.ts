import * as jwt from "jsonwebtoken";
import { NextFunction, Request, Response } from "express";
import User from "../../models/user";
import auth from "../../middleware/auth";

// Mock Functions
jest.mock("../../models/user");
jest.mock("jsonwebtoken");

const mockRequest = { header: jest.fn() } as unknown as Request;
const mockResponse = {
  status: jest.fn().mockReturnThis(),
  json: jest.fn(),
} as unknown as Response;
const next = jest.fn() as NextFunction;

describe("Tests for Auth Middleware", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Should return 401 if no token is provided", async () => {
    (mockRequest.header as jest.Mock).mockReturnValue(null);

    await auth(mockRequest, mockResponse, next);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(401);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "No auth token, access denied.",
    });
  });

  test("Should return 401 if invalid token", async () => {
    (mockRequest.header as jest.Mock).mockReturnValue("invalid-token");
    (jwt.verify as jest.Mock).mockImplementation(() => null);

    await auth(mockRequest, mockResponse, next);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(401);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Token verification failed, authorization denied.",
    });
  });

  test("Should call next() if token is valid", async () => {
    (mockRequest.header as jest.Mock).mockReturnValue("valid-token");
    (jwt.verify as jest.Mock).mockImplementation(() => ({ id: "123" }));

    await auth(mockRequest, mockResponse, next);
    expect(next).toHaveBeenCalledTimes(1);
    expect(mockRequest.user).toBe("123");
    expect(mockRequest.token).toBe("valid-token");
  });
});
