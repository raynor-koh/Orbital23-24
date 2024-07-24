import * as jwt from "jsonwebtoken";
import User from "../../models/user";

export const authTokenIsValidHandler = async (request: any, response: any) => {
  try {
    const token = request.header("x-auth-token");
    if (!token) return response.status(401).json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return response.status(403).json(false);

    const user = User.findById((verified as jwt.JwtPayload).id);
    if (!user) return response.status(404).json(false);
    response.status(200).json(true);
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
  }
};
