import axios from "axios";

// THE URL HERE IS FOR SERVER ONLY NOT THE FLUTTER APP
const SIGNUP_URL = "http://localhost:3000";

const createMultipeUsers = async () => {
  for (let i = 0; i < 1; i++) {
    const user = {
      name: `User ${i}`,
      email: `user${i}@example.com`,
      password: `password${i}`,
    };
    try {
      const res = await axios.post(SIGNUP_URL, user);
    } catch (error) {
      console.log(`Failed to sign up user ${user.email}`);
      console.error(error);
      throw error;
    }
  }
};

createMultipeUsers();
