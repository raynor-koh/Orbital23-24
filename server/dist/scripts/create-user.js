"use strict";
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
const axios_1 = __importDefault(require("axios"));
// THE URL HERE IS FOR SERVER ONLY NOT THE FLUTTER APP
const SIGNUP_URL = "http://localhost:3000";
const createMultipeUsers = () => __awaiter(void 0, void 0, void 0, function* () {
    for (let i = 0; i < 1; i++) {
        const user = {
            name: `User ${i}`,
            email: `user${i}@example.com`,
            password: `password${i}`,
        };
        try {
            const res = yield axios_1.default.post(SIGNUP_URL, user);
        }
        catch (error) {
            console.log(`Failed to sign up user ${user.email}`);
            console.error(error);
            throw error;
        }
    }
});
createMultipeUsers();
