import * as bcryptjs from "bcryptjs";
import * as jwt from "jsonwebtoken";
import { User } from "../../models";

export const authSignInHandler = async (request: any, response: any) => {
  try {
    const { email, password } = request.body;
    const user = await User.findOne({ email: email });

    // Check if user exists
    if (!user) {
      return response
        .status(404)
        .json({ message: "User with this email does not exist!" });
    }

    // Check if password matches
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return response.status(403).json({ message: "Incorrect password." });
    }

    // Set up JWT token to know if the user has already logged in or not
    const token = jwt.sign({ id: user._id }, "passwordKey"); // Token stored in local storage database
    response.status(200).json({ token: token, user: user });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    throw error;
  }
};
