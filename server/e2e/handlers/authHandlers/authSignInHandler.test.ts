import * as dotenv from "dotenv";
import request from "supertest";
import { createApp } from "../../../createApp";
import mongoose from "mongoose";
import { User, UserPosition } from "../../../models";
import * as bcryptjs from "bcryptjs";

dotenv.config({ path: "../.env" });

const DB = process.env.MONGODB_DATABASE_TEST as string;

describe("authSignInHandler integration tests", () => {
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

    // Create a test user
    const hashedPasswrd = await bcryptjs.hash("testpassword", 8);
    await User.create({
      name: "Test User",
      email: "testuser@example.com",
      password: hashedPasswrd,
    });
  });

  test("Should return 404 if user does not exist", async () => {
    const response = await request(app)
      .post("/signin")
      .send({ email: "nonexistent@example.com", password: "anypassword" });
    expect(response.status).toBe(404);
    expect(response.body).toEqual({
      message: "User with this email does not exist!",
    });
  });

  test("Should return 403 if password is incorrect", async () => {
    const response = await request(app)
      .post("/signin")
      .send({ email: "testuser@example.com", password: "wrongpassword" });

    expect(response.status).toBe(403);
    expect(response.body).toEqual({ message: "Incorrect password." });
  });

  test("Should successfully sign in a user", async () => {
    const response = await request(app)
      .post("/signin")
      .send({ email: "testuser@example.com", password: "testpassword" });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty("token");
    expect(response.body).toHaveProperty("user");
    expect(response.body.user).toHaveProperty("email", "testuser@example.com");
  });

  test("Should return a valid JWT token", async () => {
    const response = await request(app)
      .post("/signin")
      .send({ email: "testuser@example.com", password: "testpassword" });

    expect(response.body).toHaveProperty("token");
    expect(typeof response.body.token).toBe("string");
    expect(response.body.token.split(".").length).toBe(3); // JWT tokens have 3 parts
  });

  test("Should not return the password in the response", async () => {
    const response = await request(app)
      .post("/signin")
      .send({ email: "testuser@example.com", password: "testpassword" });

    expect(response.body.user).toHaveProperty("password");
    expect(response.body.user.password).not.toBe("testpassword");
  });
});
