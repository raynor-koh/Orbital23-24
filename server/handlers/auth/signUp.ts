import * as bcryptjs from "bcryptjs";
import User from "../../models/user";

export const authSignUpHandler = async (request: any, response: any) => {
  try {
    const { name, email, password } = request.body; // Extract user input

    // Check if the fields are empty.
    if (!name || !email || !password) {
      return response.status(400).json({ message: "Please fill all fields" });
    }

    // Find existing user
    const existingUser = await User.findOne({ email: email });
    if (existingUser) {
      return response
        .status(400)
        .json({ message: "User with the same email already exists!" });
    }

    // User trying to sign up for the first time
    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      name: name,
      email: email,
      password: hashedPassword,
    });

    // Save user and retrieve user documentId
    user = await user.save(); // MongoDB will add two more fields: documentId and version
    response.status(200).json(user);
    return;
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: error });
    throw error;
  }
};
