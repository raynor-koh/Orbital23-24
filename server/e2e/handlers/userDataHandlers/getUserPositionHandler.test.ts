import * as dotenv from "dotenv";
import request from "supertest";
import { createApp } from "../../../createApp";
import mongoose from "mongoose";
import { User, UserPosition } from "../../../models";

dotenv.config({ path: "../.env" });

const DB = process.env.MONGODB_DATABASE_TEST as string;

describe("getUserPositionHandler integration tests", () => {
  let app: any;
  let testUser: any;
  let testUserPosition: any;

  beforeAll(async () => {
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

    // Create a test user
    testUser = await User.create({
      name: "Test User",
      email: "testuser@example.com",
      password: "hashedpassword",
    });

    // Create a test user position
    testUserPosition = await UserPosition.create({
      userId: testUser._id,
      accountBalance: 1000,
      accountPositon: [],
      buyingPower: 1000,
    });
  });

  test("Should return 404 if user not found", async () => {
    const nonExistentId = new mongoose.Types.ObjectId();

    const response = await request(app).get(`/user/${nonExistentId}`);

    expect(response.status).toBe(404);
    expect(response.body).toEqual({ error: "User not found" });
  });

  test("Should return 404 if user position not found", async () => {
    // Delete the user position to simulate this scenario
    await UserPosition.deleteMany({ userId: testUser._id });

    const response = await request(app).get(`/user-position/${testUser._id}`);

    expect(response.status).toBe(404);
    expect(response.body).toEqual({ error: "User position not found" });
  });

  test("Should return user position for valid user id", async () => {
    const response = await request(app).get(`/user-position/${testUser._id}`);

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty("userPosition");
    expect(response.body.userPosition).toHaveProperty(
      "userId",
      testUser._id.toString()
    );
    expect(response.body.userPosition).toHaveProperty("accountBalance", 1000);
    expect(response.body.userPosition).toHaveProperty("buyingPower", 1000);
  });
});
