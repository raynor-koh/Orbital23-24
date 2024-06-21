/*
For unit testing, you should only test a single piece of your code.
This is to separate concerns and each function should have Single Responsibility

toHaveBeenCalled: checks if function has been called
toHaveBeenCalledWith(params): checks if function has been called with that return value
toHaveBeenCalledTimes(params): checks how many times the function has been called
*/

// Describe => Test Suite Name
// Test => Individual Test

import { authSignUpHandler } from "../../handlers/auth/authSignUpHandler";
import User from "../../models/user";
import * as bcryptjs from "bcryptjs";

// Mock user model
jest.mock("../../models/user");

const testName = "user";
const testEmail = "test01@example.com";
const testPassword = "password123";

const existingEmail = "test@example.com";

const mockRequest = {
  body: {
    name: testName,
    email: testEmail,
    password: testPassword,
  },
};

const mockResponse = {
  status: jest.fn().mockReturnThis(), // Creates Mock Function
  json: jest.fn(),
};

describe("Sign Up Tests", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  // Test for Valid Sign Up
  test("Should sign up if all fields are valid", async () => {
    const validRequest = mockRequest;

    // Mock User.findOne to return null
    (User.findOne as jest.Mock).mockResolvedValue(null);

    const hashedPassword = bcryptjs.hashSync(testPassword, 8);

    // Mock User.prototype.save to return user object
    (User.prototype.save as jest.Mock).mockResolvedValue({
      name: testName,
      email: testEmail,
      password: hashedPassword,
    });

    await authSignUpHandler(validRequest, mockResponse);
    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.json).toHaveBeenCalledWith(
      expect.objectContaining({
        name: testName,
        email: testEmail,
        password: hashedPassword,
      })
    );
  });

  // Test for Name Empty
  test("Should not sign up if name is empty", async () => {
    const emptyNameRequest = {
      ...mockRequest,
      body: { ...mockRequest.body, name: "" },
    };
    await authSignUpHandler(emptyNameRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(400);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Please fill all fields",
    });
  });

  // Test for Email Empty
  test("Should not sign up if email is empty", async () => {
    const emptyEmailRequest = {
      ...mockRequest,
      body: { ...mockRequest.body, email: "" },
    };
    await authSignUpHandler(emptyEmailRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(400);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Please fill all fields",
    });
  });

  // Test for Password Empty
  test("Should not sign up if password is empty", async () => {
    const emptyPasswordRequest = {
      ...mockRequest,
      body: { ...mockRequest.body, password: "" },
    };
    await authSignUpHandler(emptyPasswordRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(400);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "Please fill all fields",
    });
  });

  // Test for Existing Email
  test("Should not sign up if email already exists", async () => {
    const existingEmailRequest = {
      ...mockRequest,
      body: { ...mockRequest.body, email: existingEmail },
    };

    const hashedPassword = bcryptjs.hashSync(testPassword, 8);

    (User.findOne as jest.Mock).mockResolvedValue({
      email: existingEmail,
    });

    await authSignUpHandler(existingEmailRequest, mockResponse);
    expect(mockResponse.status).not.toHaveBeenCalledWith(200);
    expect(mockResponse.status).toHaveBeenCalledWith(400);
    expect(mockResponse.json).toHaveBeenCalledWith({
      message: "User with the same email already exists!",
    });
  });
});
