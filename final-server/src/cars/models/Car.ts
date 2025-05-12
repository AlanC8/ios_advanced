import { Schema, model, Document, Types } from 'mongoose';
import { IBrand } from './Brand';
import { ISeries } from './Series';
import { IGeneration } from './Generation';
import { IUser } from '../../auth/models/User';

export interface ICar extends Document {
  seller:        Types.ObjectId | IUser;   // владелец объявления
  brand:         Types.ObjectId | IBrand;
  series:        Types.ObjectId | ISeries;
  generation:    Types.ObjectId | IGeneration;
  vin:           string;
  year:          number;
  mileage:       number;      // км
  price:         number;
  currency:      'KZT' | 'USD';
  engine:        { volume: number; type: 'petrol'|'diesel'|'hybrid'|'ev' };
  gearbox:       'manual' | 'automatic' | 'cvt' | 'robot';
  drive:         'fwd' | 'rwd' | 'awd';
  steeringSide:  'left' | 'right';
  customsCleared:boolean;
  city:          string;
  title:         string;
  description?:  string;
  features:      string[];   // ABS, ESP …
  photos:        string[];   // массив URL-ов
  views:         number;
  createdAt:     Date;
  updatedAt:     Date;
}

const CarSchema = new Schema<ICar>({
  seller:        { type: Schema.Types.ObjectId, ref: 'User', required: true },
  brand:         { type: Schema.Types.ObjectId, ref: 'Brand', required: true },
  series:        { type: Schema.Types.ObjectId, ref: 'Series', required: true },
  generation:    { type: Schema.Types.ObjectId, ref: 'Generation', required: true },
  vin:           { type: String, required: true, unique: true, uppercase: true },
  year:          { type: Number, required: true },
  mileage:       { type: Number, required: true },
  price:         { type: Number, required: true },
  currency:      { type: String, enum: ['KZT', 'USD'], default: 'KZT' },
  engine: {
    volume:      Number,
    type:        { type: String, enum: ['petrol','diesel','hybrid','ev'] },
  },
  gearbox:       { type: String, enum: ['manual','automatic','cvt','robot'] },
  drive:         { type: String, enum: ['fwd','rwd','awd'] },
  steeringSide:  { type: String, enum: ['left','right'], default: 'left' },
  customsCleared:{ type: Boolean, default: true },
  city:          String,
  title:         { type: String, maxlength: 120 },
  description:   String,
  features:      [String],
  photos:        [String],
  views:         { type: Number, default: 0 },
}, { timestamps: true });

CarSchema.index({ brand:1, series:1, generation:1, price:1 });
CarSchema.index({ city:1 });
CarSchema.index({ vin:1 });

export default model<ICar>('Car', CarSchema);
