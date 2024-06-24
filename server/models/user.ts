import * as mongoose from "mongoose";

// Structure of User Document
const userSchema = new mongoose.Schema({
  name: { required: true, type: String, trim: true },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value: string) => {
        // ReGex for Email
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: { required: true, type: String },
});

// Convert schema into a model
const User = mongoose.model("User", userSchema); // Name of Schema, Schema object

export default User;
