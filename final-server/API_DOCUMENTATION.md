# Habit Tracker API Documentation

Эта документация содержит подробное описание всех эндпоинтов API и примеры их использования.

## Базовый URL

```
http://localhost:8000
```

## Аутентификация

API использует JWT-токены для аутентификации. Для большинства запросов требуется заголовок `Authorization` в формате:

```
Authorization: Bearer <ваш_токен>
```

---

## Пользователи

### Регистрация нового пользователя

**Запрос:**
```
POST /users/
```

**Тело запроса:**
```json
{
  "username": "username",
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Пример с cURL:**
```bash
curl -X 'POST' \
  'http://localhost:8000/users/' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "username": "username",
  "email": "user@example.com",
  "password": "securepassword"
}'
```

**Успешный ответ (201 Created):**
```json
{
  "username": "username",
  "email": "user@example.com",
  "id": 1,
  "created_at": "2025-04-22T10:30:00"
}
```

### Получение токена (вход в систему)

**Запрос:**
```
POST /users/token
```

**Тело запроса (form-data):**
```
username: username
password: securepassword
```

**Пример с cURL:**
```bash
curl -X 'POST' \
  'http://localhost:8000/users/token' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'username=username&password=securepassword'
```

**Успешный ответ (200 OK):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

### Получение данных текущего пользователя

**Запрос:**
```
GET /users/me
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Пример с cURL:**
```bash
curl -X 'GET' \
  'http://localhost:8000/users/me' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (200 OK):**
```json
{
  "username": "username",
  "email": "user@example.com",
  "id": 1,
  "created_at": "2025-04-22T10:30:00"
}
```

### Обновление данных пользователя

**Запрос:**
```
PUT /users/me
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Тело запроса:**
```json
{
  "username": "new_username",
  "email": "new_email@example.com",
  "password": "new_password"
}
```

**Пример с cURL:**
```bash
curl -X 'PUT' \
  'http://localhost:8000/users/me' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json' \
  -d '{
  "username": "new_username",
  "email": "new_email@example.com",
  "password": "new_password"
}'
```

**Успешный ответ (200 OK):**
```json
{
  "username": "new_username",
  "email": "new_email@example.com",
  "id": 1,
  "created_at": "2025-04-22T10:30:00"
}
```

---

## Привычки

### Создание новой привычки

**Запрос:**
```
POST /habits/
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Тело запроса:**
```json
{
  "title": "Утренняя пробежка",
  "description": "Бег на 5 км каждое утро"
}
```

**Пример с cURL:**
```bash
curl -X 'POST' \
  'http://localhost:8000/habits/' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json' \
  -d '{
  "title": "Утренняя пробежка",
  "description": "Бег на 5 км каждое утро"
}'
```

**Успешный ответ (201 Created):**
```json
{
  "title": "Утренняя пробежка",
  "description": "Бег на 5 км каждое утро",
  "id": 1,
  "created_at": "2025-04-22T10:30:00",
  "active": true,
  "user_id": 1
}
```

### Получение списка всех привычек

**Запрос:**
```
GET /habits/
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Параметры запроса:**
- `skip` (int, optional): Сколько записей пропустить (для пагинации)
- `limit` (int, optional): Максимальное количество записей в ответе (для пагинации)
- `include_inactive` (bool, optional): Включать ли неактивные привычки

**Пример с cURL:**
```bash
curl -X 'GET' \
  'http://localhost:8000/habits/?include_inactive=false' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (200 OK):**
```json
[
  {
    "title": "Утренняя пробежка",
    "description": "Бег на 5 км каждое утро",
    "id": 1,
    "created_at": "2025-04-22T10:30:00",
    "active": true,
    "user_id": 1,
    "streak": 3,
    "completion_rate": 42.857142857142854
  },
  {
    "title": "Чтение книги",
    "description": "Читать по 30 минут в день",
    "id": 2,
    "created_at": "2025-04-22T11:30:00",
    "active": true,
    "user_id": 1,
    "streak": 1,
    "completion_rate": 14.285714285714285
  }
]
```

### Получение информации о конкретной привычке

**Запрос:**
```
GET /habits/{habit_id}
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Пример с cURL:**
```bash
curl -X 'GET' \
  'http://localhost:8000/habits/1' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (200 OK):**
```json
{
  "title": "Утренняя пробежка",
  "description": "Бег на 5 км каждое утро",
  "id": 1,
  "created_at": "2025-04-22T10:30:00",
  "active": true,
  "user_id": 1,
  "streak": 3,
  "completion_rate": 42.857142857142854
}
```

### Обновление привычки

**Запрос:**
```
PUT /habits/{habit_id}
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Тело запроса:**
```json
{
  "title": "Вечерняя пробежка",
  "description": "Бег на 3 км каждый вечер",
  "active": true
}
```

**Пример с cURL:**
```bash
curl -X 'PUT' \
  'http://localhost:8000/habits/1' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json' \
  -d '{
  "title": "Вечерняя пробежка",
  "description": "Бег на 3 км каждый вечер",
  "active": true
}'
```

**Успешный ответ (200 OK):**
```json
{
  "title": "Вечерняя пробежка",
  "description": "Бег на 3 км каждый вечер",
  "id": 1,
  "created_at": "2025-04-22T10:30:00",
  "active": true,
  "user_id": 1
}
```

### Удаление привычки

**Запрос:**
```
DELETE /habits/{habit_id}
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Пример с cURL:**
```bash
curl -X 'DELETE' \
  'http://localhost:8000/habits/1' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (204 No Content)**

---

## Отслеживание привычек

### Создание записи о выполнении привычки

**Запрос:**
```
POST /tracking/habits/{habit_id}/entries
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Тело запроса:**
```json
{
  "date": "2025-04-22",
  "completed": true,
  "notes": "Пробежал 6 км вместо запланированных 5!"
}
```

**Пример с cURL:**
```bash
curl -X 'POST' \
  'http://localhost:8000/tracking/habits/1/entries' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json' \
  -d '{
  "date": "2025-04-22",
  "completed": true,
  "notes": "Пробежал 6 км вместо запланированных 5!"
}'
```

**Успешный ответ (200 OK):**
```json
{
  "date": "2025-04-22",
  "completed": true,
  "notes": "Пробежал 6 км вместо запланированных 5!",
  "id": 1,
  "habit_id": 1,
  "created_at": "2025-04-22T10:30:00",
  "updated_at": null
}
```

### Получение записей о выполнении привычки

**Запрос:**
```
GET /tracking/habits/{habit_id}/entries
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Параметры запроса:**
- `start_date` (date, optional): Начальная дата для фильтрации
- `end_date` (date, optional): Конечная дата для фильтрации

**Пример с cURL:**
```bash
curl -X 'GET' \
  'http://localhost:8000/tracking/habits/1/entries?start_date=2025-04-01&end_date=2025-04-30' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (200 OK):**
```json
[
  {
    "date": "2025-04-22",
    "completed": true,
    "notes": "Пробежал 6 км вместо запланированных 5!",
    "id": 1,
    "habit_id": 1,
    "created_at": "2025-04-22T10:30:00",
    "updated_at": null
  },
  {
    "date": "2025-04-21",
    "completed": true,
    "notes": "Стандартная тренировка",
    "id": 2,
    "habit_id": 1,
    "created_at": "2025-04-21T10:30:00",
    "updated_at": null
  }
]
```

### Получение конкретной записи о выполнении

**Запрос:**
```
GET /tracking/entries/{entry_id}
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Пример с cURL:**
```bash
curl -X 'GET' \
  'http://localhost:8000/tracking/entries/1' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (200 OK):**
```json
{
  "date": "2025-04-22",
  "completed": true,
  "notes": "Пробежал 6 км вместо запланированных 5!",
  "id": 1,
  "habit_id": 1,
  "created_at": "2025-04-22T10:30:00",
  "updated_at": null
}
```

### Обновление записи о выполнении

**Запрос:**
```
PUT /tracking/entries/{entry_id}
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Тело запроса:**
```json
{
  "completed": true,
  "notes": "Обновленная заметка"
}
```

**Пример с cURL:**
```bash
curl -X 'PUT' \
  'http://localhost:8000/tracking/entries/1' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json' \
  -d '{
  "completed": true,
  "notes": "Обновленная заметка"
}'
```

**Успешный ответ (200 OK):**
```json
{
  "date": "2025-04-22",
  "completed": true,
  "notes": "Обновленная заметка",
  "id": 1,
  "habit_id": 1,
  "created_at": "2025-04-22T10:30:00",
  "updated_at": "2025-04-22T11:15:00"
}
```

### Удаление записи о выполнении

**Запрос:**
```
DELETE /tracking/entries/{entry_id}
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Пример с cURL:**
```bash
curl -X 'DELETE' \
  'http://localhost:8000/tracking/entries/1' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (204 No Content)**

### Получение записей о выполнении на сегодня

**Запрос:**
```
GET /tracking/today
```

**Заголовки:**
```
Authorization: Bearer <ваш_токен>
```

**Пример с cURL:**
```bash
curl -X 'GET' \
  'http://localhost:8000/tracking/today' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
```

**Успешный ответ (200 OK):**
```json
[
  {
    "date": "2025-04-22",
    "completed": true,
    "notes": "Пробежал 6 км вместо запланированных 5!",
    "id": 1,
    "habit_id": 1,
    "created_at": "2025-04-22T10:30:00",
    "updated_at": null
  },
  {
    "date": "2025-04-22",
    "completed": false,
    "notes": null,
    "id": 3,
    "habit_id": 2,
    "created_at": "2025-04-22T10:30:01",
    "updated_at": null
  }
]
```

## Коды ошибок

- **400 Bad Request**: Ошибка в запросе (например, некорректные данные)
- **401 Unauthorized**: Отсутствие или недействительный токен аутентификации
- **403 Forbidden**: Недостаточно прав для доступа к ресурсу
- **404 Not Found**: Запрашиваемый ресурс не найден
- **500 Internal Server Error**: Внутренняя ошибка сервера 