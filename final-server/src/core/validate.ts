import { body } from 'express-validator';

export const carDTO = [
  body('brand').isMongoId(),
  body('vin').isLength({ min: 17, max: 17 }),
  body('price').isNumeric().isInt({ min: 1 }),
];
