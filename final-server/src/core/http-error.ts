export class HttpError extends Error {
  status: number;
  payload?: any;
  constructor(status: number, msg: string, payload?: any) {
    super(msg);
    this.status = status;
    this.payload = payload;
  }
}
