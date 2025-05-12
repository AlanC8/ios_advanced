import { Router } from 'express';
import auth from '../../middlewares/auth-middleware';
import Favorite from '../models/Favorite';

const r = Router();

/**
 * Тогглит избранное для машины:
 * Если уже есть в избранном — удаляет.
 * Если нет — добавляет.
 */
r.post('/:id/favorite', auth, async (req, res) => {
  const userId = (req as any).user._id;
  const carId = req.params.id;

  try {
    const existing = await Favorite.findOne({ user: userId, car: carId });

    if (existing) {
      await Favorite.deleteOne({ _id: existing._id });
      return res.status(200).json({ message: 'Removed from favorites' });
    } else {
      const newFav = await Favorite.create({ user: userId, car: carId });
      return res.status(201).json({ message: 'Added to favorites', favorite: newFav });
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

r.get('/me/favorites', auth, async (req, res) => {
  const userId = (req as any).user._id;

  try {
    const favorites = await Favorite.find({ user: userId }).populate('car');
    res.json(favorites);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch favorites' });
  }
});

export default r;
