// THIS FILE IS USED FOR AUTHENTICATION ROUTES
import * as express from "express";
import auth from "../middleware/auth";
const authRouter = express.Router();

import { authSignUpHandler } from "../handlers/auth/authSignUpHandler";
import { authSignInHandler } from "../handlers/auth/authSignInHandler";
import { authTokenIsValidHandler } from "../handlers/auth/authTokenIsValidHandler";
import { authJWTTokenHandler } from "../handlers/auth/authJWTTokenHandler";

// Sign Up
authRouter.post("/signup", authSignUpHandler);

// Sign In
authRouter.post("/signin", authSignInHandler);

// Check if token is valid
authRouter.post("/tokenIsValid", authTokenIsValidHandler);

// Check if user is authenticated
authRouter.get("/", auth, authJWTTokenHandler);

export default authRouter;
