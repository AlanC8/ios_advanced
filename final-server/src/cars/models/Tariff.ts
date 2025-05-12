import { Schema, model, Document } from 'mongoose';

export interface ITariff extends Document {
  code: 'TOP3' | 'TOP7';
  label: string;
  durationDays: number;
  priceKZT: number;
  active: boolean;
}

const TariffSchema = new Schema<ITariff>({
  code:         { type: String, unique: true, required: true },
  label:        { type: String, required: true },
  durationDays: { type: Number, required: true },
  priceKZT:     { type: Number, required: true },
  active:       { type: Boolean, default: true },
});

export default model<ITariff>('Tariff', TariffSchema);
