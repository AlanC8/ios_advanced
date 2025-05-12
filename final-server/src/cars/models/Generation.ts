import { Schema, model, Document, Types } from 'mongoose';
import { ISeries } from './Series';

export interface IGeneration extends Document {
  series: Types.ObjectId | ISeries;
  code:   string;    // G30, XV70 …
  years:  { start: number; end?: number }; // 2017-…
}

const GenerationSchema = new Schema<IGeneration>({
  series: { type: Schema.Types.ObjectId, ref: 'Series', required: true },
  code:   { type: String, required: true, trim: true },
  years:  {
    start: { type: Number, required: true },
    end:   Number,
  },
});

GenerationSchema.index({ series: 1, code: 1 }, { unique: true });

export default model<IGeneration>('Generation', GenerationSchema);
