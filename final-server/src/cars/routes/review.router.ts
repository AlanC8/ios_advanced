import { Router } from 'express';
import auth from '../../middlewares/auth-middleware';
import Review from '../models/Review';
import { ah } from '../../core/async-handler';

const r = Router({ mergeParams: true });         // наследуем :id из /cars

/* ─────────  POST /cars/:id/review  ───────── */
r.post('/:id/review', auth, ah(async (req, res) => {
  const review = await Review.create({
    user:  (req as any).user._id,
    car:   req.params.id,
    rating: req.body.rating,
    comment: req.body.comment,
  });
  res.status(201).json(review);
}));

/* ─────────  GET /cars/:id/reviews  ───────── */
r.get('/:id/reviews', ah(async (req, res) => {
  const reviews = await Review.find({ car: req.params.id }).lean();
  res.json(reviews);
}));

/* ─────────  PATCH /reviews/:id  ───────── */
r.patch('/reviews/:id', auth, ah(async (req, res) => {
  const doc = await Review.findOneAndUpdate(
    { _id: req.params.id, user: (req as any).user._id },
    req.body,
    { new: true },
  );
  if (!doc) return res.status(404).json({ message: 'Not found' });
  res.json(doc);
}));

/* ─────────  DELETE /reviews/:id  ───────── */
r.delete('/reviews/:id', auth, ah(async (req, res) => {
  await Review.deleteOne({ _id: req.params.id, user: (req as any).user._id });
  res.status(204).end();
}));

export default r;
