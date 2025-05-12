import { Router } from 'express';
import auth from '../../middlewares/auth-middleware';
import Report from '../models/Report';
import { ah } from '../../core/async-handler';

const r = Router({ mergeParams: true });

/* ─────────  POST /cars/:id/report  ───────── */
r.post('/:id/report', auth, ah(async (req, res) => {
  const report = await Report.create({
    user:    (req as any).user._id,
    car:     req.params.id,
    reason:  req.body.reason,
    message: req.body.message,
  });
  res.status(201).json(report);
}));

/* ─────────  (admin) GET /reports  ───────── */
r.get('/reports', ah(async (_req, res) => {
  const list = await Report.find().populate('car user', 'title phone').lean();
  res.json(list);
}));

/* ─────────  PATCH /reports/:id (resolve) ───────── */
r.patch('/reports/:id', auth, ah(async (req, res) => {
  const doc = await Report.findByIdAndUpdate(req.params.id, req.body, { new: true });
  if (!doc) return res.status(404).json({ message: 'Not found' });
  res.json(doc);
}));

export default r;
