import { Schema, model, Document, Types } from 'mongoose';
import { IUser } from '../../auth/models/User';
import { ICar } from './Car';

export interface IReview extends Document {
  user: Types.ObjectId | IUser;
  car:  Types.ObjectId | ICar;
  rating: number;   // 1-5
  comment?: string;
}

const ReviewSchema = new Schema<IReview>({
  user:    { type: Schema.Types.ObjectId, ref: 'User', required: true },
  car:     { type: Schema.Types.ObjectId, ref: 'Car', required: true },
  rating:  { type: Number, min: 1, max: 5, required: true },
  comment: String,
}, { timestamps: true });

ReviewSchema.index({ car:1 });
ReviewSchema.index({ user:1, car:1 }, { unique: true }); // 1 отзыв от юзера

export default model<IReview>('Review', ReviewSchema);
