"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// THIS FILE IS USED FOR AUTHENTICATION ROUTES
const express = __importStar(require("express"));
const bcryptjs = __importStar(require("bcryptjs"));
const jwt = __importStar(require("jsonwebtoken"));
const user_1 = __importDefault(require("../models/user"));
const auth_1 = __importDefault(require("../middleware/auth"));
const authRouter = express.Router();
// Sign Up
authRouter.post("/signup", (request, response) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { name, email, password } = request.body; // Extract user input
        // Find existing user
        const existingUser = yield user_1.default.findOne({ email: email });
        if (existingUser) {
            return response
                .status(400)
                .json({ message: "User with the same email already exists!" });
        }
        // User trying to sign up for the first time
        const hashedPassword = yield bcryptjs.hash(password, 8);
        let user = new user_1.default({
            name: name,
            email: email,
            password: hashedPassword,
        });
        // Save user and retrieve user documentId
        user = yield user.save(); // MongoDB will add two more fields: documentId and version
        response.json(user);
    }
    catch (error) {
        console.error(error);
        response.status(500).json({ error: error });
        throw error;
    }
}));
// Sign In
authRouter.post("/signin", (request, response) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { email, password } = request.body;
        const user = yield user_1.default.findOne({ email: email });
        // Check if user exists
        if (!user) {
            return response
                .status(400)
                .json({ message: "User with this email does not exist!" });
        }
        // Check if password matches
        const isMatch = yield bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return response.status(400).json({ message: "Incorrect password." });
        }
        // Set up JWT token to know if the user has already logged in or not
        const token = jwt.sign({ id: user._id }, "passwordKey"); // Token stored in local storage database
        response.json({ token: token, user: user });
    }
    catch (error) {
        console.error(error);
        response.status(500).json({ error: error });
        throw error;
    }
}));
// Check if token is valid
authRouter.post("/tokenIsvalid", (request, response) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = request.header("x-auth-token");
        if (!token)
            return response.json(false);
        const verified = jwt.verify(token, "passwordKey");
        if (!verified)
            return response.json(false);
        const user = user_1.default.findById(verified.id);
        if (!user)
            return response.json(false);
        response.json(true);
    }
    catch (error) {
        console.error(error);
        response.status(500).json({ error: error });
    }
}));
// Check if user is authenticated
authRouter.get("/", auth_1.default, (request, response) => __awaiter(void 0, void 0, void 0, function* () {
    // Auth is middleware
    const user = yield user_1.default.findById(request.user);
    response.json({ user: user, token: request.token });
}));
exports.default = authRouter;
