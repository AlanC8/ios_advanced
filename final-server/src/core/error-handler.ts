import { Request, Response, NextFunction } from "express";
import { HttpError } from "../core/http-error";

export const errorHandler = (
  err: any,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  if (err instanceof HttpError) {
    return res
      .status(err.status)
      .json({ message: err.message, details: err.payload });
  }
  console.error(err);
  res.status(500).json({ message: "Internal server error" });
};
