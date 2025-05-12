import Boost from "../models/Boost";
import Tariff from "../models/Tariff";
import Car from "../../cars/models/Car";
import { ah } from "../../core/async-handler";
import { Request, Response } from "express";

export default {
  buy: ah(async (req: Request, res: Response) => {
    const { tariffCode } = req.body;
    const { id: carId } = req.params;
    const userId = (req as any).user._id;

    const tariff = await Tariff.findOne({ code: tariffCode });
    if (!tariff) return res.status(404).json({ message: "Tariff not found" });

    const expires = new Date(Date.now() + tariff.durationDays * 864e5);

    const boost = await Boost.create({
      car: carId,
      user: userId,
      tariff,
      boostExpiresAt: expires,
    });
    res.status(201).json(boost);
  }),

  cancelExpired: ah(async (_req: Request, res: Response) => {
    const n = await Boost.deleteMany({ boostExpiresAt: { $lte: new Date() } });
    res.json({ removed: n.deletedCount });
  }),
};
