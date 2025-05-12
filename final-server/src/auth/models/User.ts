// src/auth/models/User.ts
import { Schema, model, Document } from "mongoose";

export interface IUser extends Document {
  phone: string; // +7 707 ***
  email?: string;
  username?: string;
  password: string; // храним хеш
  city?: string;
  avatar?: string;
}

const UserSchema = new Schema<IUser>(
  {
    phone: { type: String, unique: true, required: true }, 
    email: { type: String, lowercase: true, trim: true },
    username: String,
    password: { type: String, required: true },
    city: String,
    avatar: { type: String, default: "https://…" },
  },
  { timestamps: true }
);

UserSchema.index({ phone: 1 });
export default model<IUser>("User", UserSchema);
