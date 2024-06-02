import { Request, Response } from "express";
import * as jwt from "jsonwebtoken";

const auth = async (request, response, next) => {
  try {
    const token = request.header("x-auth-token");
    if (!token) {
      return response
        .status(401)
        .json({ message: "No auth token, access denied." });
    }

    const verified = jwt.verify(token, "passwordKey") as jwt.JwtPayload;
    if (!verified) {
      return response
        .status(401)
        .json({ message: "Token verification failed, authorization denied." });
    }

    request.user = verified.id;
    request.token = token;
    next();
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    throw error;
  }
};

export default auth;
