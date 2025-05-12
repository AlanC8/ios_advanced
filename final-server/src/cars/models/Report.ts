import { Schema, model, Document, Types } from 'mongoose';
import { IUser } from '../../auth/models/User';
import { ICar } from './Car';

export interface IReport extends Document {
  user: Types.ObjectId | IUser;
  car:  Types.ObjectId | ICar;
  reason: 'fake' | 'sold' | 'fraud' | 'other';
  message?: string;
  resolved: boolean;
}

const ReportSchema = new Schema<IReport>({
  user:     { type: Schema.Types.ObjectId, ref: 'User', required: true },
  car:      { type: Schema.Types.ObjectId, ref: 'Car', required: true },
  reason:   { type: String, enum: ['fake','sold','fraud','other'], required: true },
  message:  String,
  resolved: { type: Boolean, default: false },
}, { timestamps: true });

ReportSchema.index({ car:1 });
export default model<IReport>('Report', ReportSchema);
