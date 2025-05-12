// src/global-router.ts
import { Router } from 'express';

import authRouter     from './auth/auth-router';
import carRouter      from './cars/routes/car.router';
import favoriteRouter from './cars/routes/favorite.router';
import boostRouter from './cars/routes/boost.router'
import reportRouter from './cars/routes/report.router'
import reviewRouter from './cars/routes/review.router'
import tariffRouter from './cars/routes/tariff.router'
import brandRouter from './cars/routes/brand.router';

const globalRouter = Router();

/*  ───────────  AUTH  ─────────── */
globalRouter.use('/auth', authRouter);

/*  ───────────  CARS & nested actions  ─────────── */
globalRouter.use('/cars', carRouter);        // CRUD объявлений
globalRouter.use('/cars', favoriteRouter);   // /cars/:id/favorite
globalRouter.use('/cars', reviewRouter);     // /cars/:id/review
globalRouter.use('/cars', reportRouter);     // /cars/:id/report
globalRouter.use('/brands', brandRouter);
globalRouter.use('/boost', boostRouter);     // /boost (покупка)
globalRouter.use('/tariffs', tariffRouter);

export default globalRouter;
