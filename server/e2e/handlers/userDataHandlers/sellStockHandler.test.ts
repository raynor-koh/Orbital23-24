import * as dotenv from "dotenv";
import request from "supertest";
import { createApp } from "../../../createApp";
import mongoose from "mongoose";
import { User, UserPosition } from "../../../models";

dotenv.config({ path: "../.env" });

const DB = process.env.MONGODB_DATABASE_TEST as string;

describe("/sellStock", () => {
  let app: any;
  let userId: any;
  let token: any;

  beforeAll(() => {
    mongoose
      .connect(DB)
      .then(() => {
        console.log("Connection successful");
      })
      .catch((error) => {
        console.error("Database connection error: ", error);
        process.exit(1); // Exit process with failure code.
      });
    app = createApp();
  });

  afterAll(async () => {
    await mongoose.connection.dropDatabase();
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    await User.deleteMany({});
    await UserPosition.deleteMany({});

    // Create a new user and get the token
    const response = await request(app).post("/signup").send({
      name: "Test User",
      email: "test@example.com",
      password: "password123",
    });
    userId = response.body.user._id;
    token = response.body.token;
  });

  test("Should return 404 if user not found", async () => {
    const response = await request(app)
      .post(`/user/sellStock/invalid-user-id`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        symbol: "TST",
        name: "Test Stock",
        quantity: 5,
        price: 60,
      });
    expect(response.status).toBe(404);
  });

  test("Should return 404 if user position not found", async () => {
    await UserPosition.deleteMany({});
    const response = await request(app)
      .post(`/user/sellStock/${userId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        symbol: "TST",
        name: "Test Stock",
        quantity: 5,
        price: 60,
      });
    expect(response.status).toBe(404);
  });

  test("Should return 404 if stock not owned", async () => {
    const response = await request(app)
      .post(`/user/sellStock/${userId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        symbol: "Invalid Symbol",
        name: "Invalid Stock",
        quantity: 5,
        price: 60,
      });
    expect(response.status).toBe(404);
  });

  test("Should return 404 if insufficient quantity owned", async () => {
    const userPosition = await UserPosition.findOne({ userId });
    userPosition!.accountPosition.push({
      symbol: "TST",
      name: "Test Stock",
      quantity: 5,
      price: 60,
    });
    await userPosition!.save();

    const response = await request(app)
      .post(`/user/sellStock/${userId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        symbol: "TST",
        name: "Test Stock",
        quantity: 10,
        price: 60,
      });
    expect(response.status).toBe(404);
  });

  test("Should successfully execute sell order", async () => {
    const userPosition = await UserPosition.findOne({ userId });
    userPosition!.accountPosition.push({
      symbol: "TST",
      name: "Test Stock",
      quantity: 10,
      price: 60,
    });
    await userPosition!.save();

    const response = await request(app)
      .post(`/user/sellStock/${userId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        symbol: "TST",
        name: "Test Stock",
        quantity: 5,
        price: 60,
      });
    expect(response.status).toBe(200);
  });
});
