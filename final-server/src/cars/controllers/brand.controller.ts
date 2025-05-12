// src/cars/controllers/brand.controller.ts
import { Request, Response } from "express";
import Brand from "../models/Brand";
import Series from "../models/Series";
import Generation from "../models/Generation";
import { ah } from "../../core/async-handler";
import { HttpError } from "../../core/http-error";
import { FlattenMaps, Types } from "mongoose";

export default class BrandCtrl {
  /** GET /brands */
  static list = ah(async (req: Request, res: Response) => {
    const brands = await Brand.find().select("name logo country").lean();
    res.json(brands);
  });

  /** GET /brands/:id */
  static one = ah(async (req: Request, res: Response) => {
    const brand = await Brand.findById(req.params.id).lean();
    if (!brand) throw new HttpError(404, 'Brand not found');
  
    const series = await Series.find({ brand: brand._id }).lean();
    const gen = await Generation.find({
      series: { $in: series.map(s => s._id) },
    }).lean();
  
    /* ---------- fix: индексируем по строковому id ---------- */
    const genBySeries: Record<string, FlattenMaps<any>[]> = {};
    gen.forEach(g => {
      const key = (g.series as Types.ObjectId).toString();
      (genBySeries[key] ||= []).push(g);
    });
  
    res.json({
      ...brand,
      series: series.map(s => ({
        ...s,
        generations: genBySeries[(s._id as Types.ObjectId).toString()] ?? [],
      })),
    });
  });

  /** DELETE /brands/admin/reset (JWT admin) */
  static reset = ah(async (_req: Request, res: Response) => {
    await Promise.all([
      Brand.deleteMany({}),
      Series.deleteMany({}),
      Generation.deleteMany({}),
    ]);
    res.json({ message: "Cleared Brand/Series/Generation collections" });
  });
}
