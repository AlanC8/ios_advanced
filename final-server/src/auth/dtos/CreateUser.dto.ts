export interface CreateUserDto {
  phone: string;          // ← добавили
  password: string;
  email?: string;
  username?: string;
  city?: string;
}