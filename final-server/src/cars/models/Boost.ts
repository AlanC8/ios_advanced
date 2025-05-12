// src/boost/models/Boost.ts
import { Schema, model, Document, Types } from 'mongoose';
import { IUser } from '../../auth/models/User';
import { ICar } from '../../cars/models/Car';
import { ITariff } from './Tariff';

export interface IBoost extends Document {
  car:    Types.ObjectId | ICar;
  user:   Types.ObjectId | IUser;    // кто оплатил
  tariff: Types.ObjectId | ITariff;
  purchasedAt: Date;
  boostExpiresAt: Date;           
  paymentId?: string;            
}

const BoostSchema = new Schema<IBoost>({
  car:           { type: Schema.Types.ObjectId, ref: 'Car', required: true },
  user:          { type: Schema.Types.ObjectId, ref: 'User', required: true },
  tariff:        { type: Schema.Types.ObjectId, ref: 'Tariff', required: true },
  purchasedAt:   { type: Date, default: Date.now },
  boostExpiresAt:{ type: Date, required: true },
  paymentId:     String,
});

BoostSchema.index({ car:1, boostExpiresAt:-1 });
BoostSchema.index({ boostExpiresAt:1 });

export default model<IBoost>('Boost', BoostSchema);
