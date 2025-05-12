import { Schema, model, Document, Types } from 'mongoose';
import { IBrand } from './Brand';

export interface ISeries extends Document {
  brand: Types.ObjectId | IBrand;
  name:  string;      
}

const SeriesSchema = new Schema<ISeries>({
  brand: { type: Schema.Types.ObjectId, ref: 'Brand', required: true },
  name:  { type: String, required: true, trim: true },
});

SeriesSchema.index({ brand: 1, name: 1 }, { unique: true });

export default model<ISeries>('Series', SeriesSchema);
