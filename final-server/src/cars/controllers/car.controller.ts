import { Request, Response } from 'express';
import mongoose from 'mongoose';
import Car from '../models/Car';
import { ValidationError, validationResult } from 'express-validator';
import { HttpError } from '../../core/http-error';

/* ───────── helpers ───────── */
const toObjectId = (v?: string) =>
  v ? new mongoose.Types.ObjectId(v) : undefined;

/* ───────── controller ───────── */
export default class CarController {
  /** create ---------------------------------------------------- */
  static async create(req: Request, res: Response) {
    
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      const details = errors.array().map((err) => ({
        field: (err as any).param,
        message: (err as any).msg,
      }));
    
      console.log("🧨 ВАЛИДАЦИЯ НЕ ПРОШЛА:");
      console.log(JSON.stringify(details, null, 2));
    
      // временно не выбрасываем ошибку, просто возвращаем
      return res.status(400).json({ message: 'Validation failed', details });
    }
  
    

    const vinExists = await Car.exists({ vin: req.body.vin });
    if (vinExists) throw new HttpError(409, 'VIN already exists');
    
    const car = await Car.create({
      ...req.body,
      seller: (req as any).user._id,
    });
  
    res.status(201).json(car);
  }
  
  

  /** list ------------------------------------------------------ */
  static async list(req: Request, res: Response) {
    const { page = 1, limit = 20, brand, city, boosted } = req.query as any;

    const match: Record<string, any> = {};
    if (brand) match.brand = toObjectId(brand);
    if (city) match.city = city;

    const pipeline: any[] = [{ $match: match }];

    /* join boosts */
    pipeline.push(
      {
        $lookup: {
          from: 'boosts',
          let: { carId: '$_id' },
          pipeline: [
            {
              $match: {
                $expr: {
                  $and: [
                    { $eq: ['$car', '$$carId'] },
                    { $gt: ['$boostExpiresAt', new Date()] },
                  ],
                },
              },
            },
          ],
          as: 'boostData',
        },
      },
      {
        $addFields: {
          isBoosted: { $gt: [{ $size: '$boostData' }, 0] },
          boostExpiresAt: { $arrayElemAt: ['$boostData.boostExpiresAt', 0] },
        },
      },
    );

    if (boosted === 'true') pipeline.push({ $match: { isBoosted: true } });

    pipeline.push({ $sort: { isBoosted: -1, boostExpiresAt: -1, updatedAt: -1 } });

    const docs = await Car.aggregate(pipeline)
      .skip((+page - 1) * +limit)
      .limit(+limit);

    const total = await Car.countDocuments(match);
    res.json({ total, page: +page, docs });
  }

  /** one ------------------------------------------------------- */
  static async one(req: Request, res: Response) {
    const car = await Car.findById(req.params.id).lean();
    if (!car) throw new HttpError(404, 'Car not found');
    res.json(car);
  }

  /** update ---------------------------------------------------- */
  static async update(req: Request, res: Response) {
    const car = await Car.findOneAndUpdate(
      { _id: req.params.id, seller: (req as any).user._id },
      req.body,
      { new: true },
    );
    if (!car) throw new HttpError(404, 'Car not found or not owner');
    res.json(car);
  }

  /** delete ---------------------------------------------------- */
  static async remove(req: Request, res: Response) {
    const ok = await Car.deleteOne({
      _id: req.params.id,
      seller: (req as any).user._id,
    });
    if (!ok.deletedCount) throw new HttpError(404, 'Car not found or not owner');
    res.status(204).end();
  }
}
