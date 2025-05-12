import { body, param, query } from "express-validator";
import mongoose from "mongoose";

export const carDto = [
  body("vin")
    .isLength({ min: 17, max: 17 })
    .withMessage("VIN must be 17 symbols"),
  body("brand").isMongoId(),
  body("series").isMongoId(),
  body("generation").isMongoId(),
  body("price").isInt({ min: 1 }),
];

export const carId = [
  param("id")
    .custom((v) => mongoose.Types.ObjectId.isValid(v))
    .withMessage("Invalid car id"),
];

export const carListQuery = [
  query("page").optional().isInt({ min: 1 }),
  query("limit").optional().isInt({ min: 1, max: 100 }),
  query("brand").optional().isMongoId(),
  query("city").optional().isString(),
  query("boosted").optional().isBoolean(),
];
