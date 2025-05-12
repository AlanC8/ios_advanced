import { Model } from "mongoose";
import { Request, Response } from "express";
import { ah } from "./async-handler";

export const crudController = (Model: Model<any>) => ({
  create: ah(async (req: Request, res: Response) => {
    const doc = await Model.create(req.body);
    res.status(201).json(doc);
  }),

  getAll: ah(async (req: Request, res: Response) => {
    const { page = 1, limit = 20, ...filters } = req.query as any;
    const q = Model.find(filters).lean();
    const docs = await q
      .skip((+page - 1) * +limit)
      .limit(+limit)
      .sort({ createdAt: -1 });
    const total = await Model.countDocuments(filters);
    res.json({ total, page: +page, docs });
  }),

  getOne: ah(async (req: Request, res: Response) => {
    const doc = await Model.findById(req.params.id).lean();
    if (!doc) return res.status(404).json({ message: "Not found" });
    res.json(doc);
  }),

  update: ah(async (req: Request, res: Response) => {
    const doc = await Model.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!doc) return res.status(404).json({ message: "Not found" });
    res.json(doc);
  }),

  delete: ah(async (req: Request, res: Response) => {
    const doc = await Model.findByIdAndDelete(req.params.id);
    if (!doc) return res.status(404).json({ message: "Not found" });
    res.status(204).end();
  }),
});
