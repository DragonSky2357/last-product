export class SuccessStatus<T> {
  statusCode: number;
  message?: string;
  data?: T;
}

export class FailedStatus {
  statusCode: number;
  message?: string;
  error?: object;
}
