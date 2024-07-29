import request from "supertest";
import express from "express";
import { buyStockHandler } from "../../../handlers/userdata";
import { User, UserPosition } from "../../../models";

jest.mock("../../../models", () => ({
  User: {
    findById: jest.fn(),
  },
  UserPosition: {
    findOne: jest.fn(),
  },
}));

const app = express();
app.use(express.json());
app.post("/api/users/:id/buy", buyStockHandler);

describe("buyStockHandler Integration Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should successfully buy a new stock", async () => {
    const mockUser = { _id: "user123" };
    const mockUserPosition = {
      userId: "user123",
      accountBalance: 10000,
      buyingPower: 5000,
      accountPosition: [],
      save: jest.fn(),
    };

    (User.findById as jest.Mock).mockResolvedValue(mockUser);
    (UserPosition.findOne as jest.Mock).mockResolvedValue(mockUserPosition);

    const response = await request(app).post("/api/users/user123/buy").send({
      symbol: "AAPL",
      name: "Apple Inc.",
      quantity: 10,
      price: 150,
    });

    expect(response.status).toBe(200);
    expect(response.body.message).toBe("Buy order executed successfully");
    expect(mockUserPosition.save).toHaveBeenCalled();
    expect(mockUserPosition.accountPosition).toHaveLength(1);
    expect(mockUserPosition.accountPosition[0]).toEqual({
      symbol: "AAPL",
      name: "Apple Inc.",
      quantity: 10,
      price: 150,
    });
    expect(mockUserPosition.buyingPower).toBe(3500);
  });

  it("should update existing stock position", async () => {
    const mockUser = { _id: "user123" };
    const mockUserPosition = {
      userId: "user123",
      accountBalance: 10000,
      buyingPower: 5000,
      accountPosition: [
        { symbol: "AAPL", name: "Apple Inc.", quantity: 5, price: 100 },
      ],
      save: jest.fn(),
    };

    (User.findById as jest.Mock).mockResolvedValue(mockUser);
    (UserPosition.findOne as jest.Mock).mockResolvedValue(mockUserPosition);

    const response = await request(app).post("/api/users/user123/buy").send({
      symbol: "AAPL",
      name: "Apple Inc.",
      quantity: 5,
      price: 160,
    });

    expect(response.status).toBe(200);
    expect(response.body.message).toBe("Buy order executed successfully");
    expect(mockUserPosition.save).toHaveBeenCalled();
    expect(mockUserPosition.accountPosition).toHaveLength(1);
    expect(mockUserPosition.accountPosition[0]).toEqual({
      symbol: "AAPL",
      name: "Apple Inc.",
      quantity: 10,
      price: 120,
    });
    expect(mockUserPosition.buyingPower).toBe(4200);
  });

  it("should return 404 if user not found", async () => {
    (User.findById as jest.Mock).mockResolvedValue(null);

    const response = await request(app)
      .post("/api/users/nonexistent/buy")
      .send({
        symbol: "AAPL",
        name: "Apple Inc.",
        quantity: 10,
        price: 150,
      });

    expect(response.status).toBe(404);
    expect(response.body.message).toBe("User not found");
  });

  it("should return 404 if user position not found", async () => {
    const mockUser = { _id: "user123" };
    (User.findById as jest.Mock).mockResolvedValue(mockUser);
    (UserPosition.findOne as jest.Mock).mockResolvedValue(null);

    const response = await request(app).post("/api/users/user123/buy").send({
      symbol: "AAPL",
      name: "Apple Inc.",
      quantity: 10,
      price: 150,
    });

    expect(response.status).toBe(404);
    expect(response.body.message).toBe("User position not found");
  });

  it("should return 400 if insufficient buying power", async () => {
    const mockUser = { _id: "user123" };
    const mockUserPosition = {
      userId: "user123",
      accountBalance: 10000,
      buyingPower: 1000,
      accountPosition: [],
    };

    (User.findById as jest.Mock).mockResolvedValue(mockUser);
    (UserPosition.findOne as jest.Mock).mockResolvedValue(mockUserPosition);

    const response = await request(app).post("/api/users/user123/buy").send({
      symbol: "AAPL",
      name: "Apple Inc.",
      quantity: 10,
      price: 150,
    });

    expect(response.status).toBe(400);
    expect(response.body.message).toBe("Insufficient buying power");
  });

  it("should handle server errors", async () => {
    (User.findById as jest.Mock).mockRejectedValue(new Error("Database error"));

    const response = await request(app).post("/api/users/user123/buy").send({
      symbol: "AAPL",
      name: "Apple Inc.",
      quantity: 10,
      price: 150,
    });

    expect(response.status).toBe(500);
    expect(response.body.error).toBeDefined();
  });
});
