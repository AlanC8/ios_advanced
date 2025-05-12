import { Schema, model, Document, Types } from 'mongoose';
import { IUser } from '../../auth/models/User';
import { ICar } from './Car';

export interface IFavorite extends Document {
  user: Types.ObjectId | IUser;
  car:  Types.ObjectId | ICar;
  createdAt: Date;
}

const FavoriteSchema = new Schema<IFavorite>({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  car:  { type: Schema.Types.ObjectId, ref: 'Car', required: true },
}, { timestamps: { createdAt: true, updatedAt: false } });

FavoriteSchema.index({ user:1, car:1 }, { unique: true });
export default model<IFavorite>('Favorite', FavoriteSchema);
