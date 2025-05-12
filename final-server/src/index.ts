import "dotenv/config";
import express from "express";
import globalRouter from "./global-router";
import { logger } from "./logger";
import connectDB from "./db";
import cors from 'cors'
import { errorHandler } from "./core/error-handler";
const app = express();
const PORT = process.env.PORT || 3000;
connectDB()
app.use(cors())
app.use(logger);
app.use(express.json());
app.use("/api/v1/", globalRouter);
app.use(errorHandler);
app.listen(PORT, () => {
  console.log(`Server runs at http://localhost:${PORT}`);
});
