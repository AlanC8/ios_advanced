import { Router } from 'express';
import auth from '../../middlewares/auth-middleware';
import boostCtrl from '../controllers/boost.controller';

const r = Router();
r.post('/:id/boost', auth, boostCtrl.buy);
export default r;
