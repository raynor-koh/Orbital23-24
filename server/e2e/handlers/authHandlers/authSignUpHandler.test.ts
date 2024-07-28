import * as dotenv from "dotenv";
import request from "supertest";
import { createApp } from "../../../createApp";
import mongoose from "mongoose";
import { User, UserPosition } from "../../../models";

dotenv.config({ path: "../.env" });

const DB = process.env.MONGODB_DATABASE_TEST as string;

describe("/signup", () => {
  let app: any;
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
  });
  test("Should return 400 if fields are empty", async () => {
    const response = await request(app)
      .post("/signup")
      .send({ name: "", email: "", password: "" });
    expect(response.status).toBe(400);
    expect(response.body).toEqual({ message: "Please fill all fields" });
  });

  test("Should return 400 if email already in use", async () => {
    // Create a user first
    await request(app).post("/signup").send({
      name: "Test User",
      email: "test@example.com",
      password: "password123",
    });

    // Try to create another user with the same email address
    const response = await request(app).post("/signup").send({
      name: "Test User",
      email: "test@example.com",
      password: "password123",
    });
    expect(response.status).toBe(400);
    expect(response.body).toEqual({
      message: "User with the same email already exists!",
    });
  });

  test("Should hash the password", async () => {
    const response = await request(app).post("/signup").send({
      name: "New User",
      email: "newuser@example.com",
      password: "newpassword123",
    });
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty("user");
    expect(response.body).toHaveProperty("token");
    expect(response.body.user).toHaveProperty("name", "New User");
    expect(response.body.user).toHaveProperty("email", "newuser@example.com");

    // Check if user was actually created in the database
    const user = await User.findOne({ email: "newuser@example.com" });
    expect(user).toBeTruthy();

    // Check if UserPosition was created
    const userPosition = await UserPosition.findOne({ userId: user?._id });
    expect(userPosition).toBeTruthy();
    expect(userPosition?.accountBalance).toBe(1000);
    expect(userPosition?.buyingPower).toBe(1000);
  });

  test("Should hash the password", async () => {
    await request(app).post("/signup").send({
      name: "Password Test",
      email: "passwordtest@example.com",
      password: "testpassword",
    });

    const user = await User.findOne({ email: "passwordtest@example.com" });
    expect(user?.password).not.toBe("testpassword");
    expect(user?.password.length).toBeGreaterThan(0);
  });

  test("Should return a valid JWT token", async () => {
    const response = await request(app)
      .post("/signup")
      .send({
        name: "Token Test",
        email: "tokentest@example.com",
        password: "tokenpassword",
      });

    expect(response.body).toHaveProperty("token");
    expect(typeof response.body.token).toBe("string");
    expect(response.body.token.split(".").length).toBe(3); // JWT tokens have 3 parts
  });
});
