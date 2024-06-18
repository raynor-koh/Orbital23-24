// THIS FILE IS USED FOR AUTHENTICATION ROUTES
import * as express from "express";
import * as bcryptjs from "bcryptjs";
import * as jwt from "jsonwebtoken";
import User from "../models/user";
import auth from "../middleware/auth";
const authRouter = express.Router();

import { authSignUpHandler } from "../handlers/auth/signUp";

// Sign Up
authRouter.post("/signup", authSignUpHandler);

// Sign In
authRouter.post("/signin", async (request, response) => {
  try {
    const { email, password } = request.body;
    const user = await User.findOne({ email: email });

    // Check if user exists
    if (!user) {
      return response
        .status(400)
        .json({ message: "User with this email does not exist!" });
    }

    // Check if password matches
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return response.status(400).json({ message: "Incorrect password." });
    }

    // Set up JWT token to know if the user has already logged in or not
    const token = jwt.sign({ id: user._id }, "passwordKey"); // Token stored in local storage database
    response.json({ token: token, user: user });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    throw error;
  }
});

// Check if token is valid
authRouter.post("/tokenIsvalid", async (request, response) => {
  try {
    const token = request.header("x-auth-token");
    if (!token) return response.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return response.json(false);

    const user = User.findById((verified as jwt.JwtPayload).id);
    if (!user) return response.json(false);
    response.json(true);
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
  }
});

// Check if user is authenticated
authRouter.get("/", auth, async (request, response) => {
  // Auth is middleware
  const user = await User.findById(request.user);
  response.json({ user: user, token: request.token });
});

export default authRouter;
