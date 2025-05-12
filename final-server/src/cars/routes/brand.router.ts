import { Router } from "express";
import BrandCtrl from "../controllers/brand.controller";
import auth from "../../middlewares/auth-middleware";
import { ah } from "../../core/async-handler";

const r = Router();

r.get("/", ah(BrandCtrl.list));
r.get("/:id", ah(BrandCtrl.one));
r.delete("/admin/reset", auth, ah(BrandCtrl.reset));

export default r;
