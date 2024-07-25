import { User } from "../../models";

export const authJWTTokenHandler = async (request: any, response: any) => {
  // Auth is middleware
  const user = await User.findById(request.user);
  if (!user) {
    return response.status(404).json({ message: "User not found." });
  }
  response.status(200).json({ user: user, token: request.token });
};
