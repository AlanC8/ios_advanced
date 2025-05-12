import { Router } from "express";
import { crudController } from "../../core/crud-factory";
import Tariff from "../models/Tariff";
import auth from "../../middlewares/auth-middleware"; 

const r = Router();
const tCtrl = crudController(Tariff);

/* ─────────  PUBLIC ───────── */
r.get("/", tCtrl.getAll); // GET /tariffs
r.get("/:id", tCtrl.getOne); // GET /tariffs/:id

/* ─────────  ADMIN-AUTH ───────── */
r.post("/", auth, tCtrl.create); // POST   /tariffs
r.patch("/:id", auth, tCtrl.update); // PATCH  /tariffs/:id
r.delete("/:id", auth, tCtrl.delete); // DELETE /tariffs/:id

export default r;
