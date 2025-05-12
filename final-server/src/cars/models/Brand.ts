import { Schema, model, Document } from 'mongoose';

export interface IBrand extends Document {
  name: string;          // BMW, Toyota …
  country?: string;
  logo?: string;
}

const BrandSchema = new Schema<IBrand>({
  name:        { type: String, required: true, unique: true, trim: true },
  country:     String,
  logo:        String, // URL
});

export default model<IBrand>('Brand', BrandSchema);
