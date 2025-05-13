# Wheelix

**Wheelix** — это iOS-приложение для поиска, просмотра, создания и сохранения в избранное объявлений о продаже автомобилей. Реализовано с использованием SwiftUI + UIKit (MVVM), современного асинхронного сетевого слоя и JSON-JWT-аутентификации.

---

## 📱 Основные экраны

1.  **Splash** — анимированный логотип Wheelix с плавным переходом фона и текста (синий фон/белый текст → белый фон/черный текст).
2.  **Login / Register** — вход по номеру телефона + пароль, регистрация нового аккаунта.
3.  **Главная (Car List)** — список объявлений в виде карточек с бесконечной автоподгрузкой при скролле.
4.  **Car Details** — подробный просмотр: карусель фотографий, характеристики, описание, кнопка «лайк».
5.  **Add Car Flow** — пошаговое создание нового объявления (марка→спецификации→описание→успех) с использованием `NavigationStack`.
6.  **Profile** — данные пользователя, список избранных объявлений с возможностью перехода к деталям, кнопка «Выйти».

---

## 🚀 Технологии и архитектура

-   **UI**: SwiftUI для всех экранов и компонентов.
-   **Навигация**: UIKit (`UINavigationController` через `UIHostingController`), управляемая синглтоном `AppRouter`.
-   **Архитектура**: MVVM (Model–View–ViewModel) для каждого экрана.
-   **Асинхронность**: `async/await`, `Task`, `@MainActor` для UI-обновлений.
-   **Сетевой слой**: `HTTPClient` (синглтон) с generic-методами `getJSON` и `postJSON` для работы с API.
-   **Аутентификация**: JWT-токены, передаваемые в заголовках HTTP-запросов.
-   **Хранение**: `UserDefaults` для токенов (`TokenStore`) и пользовательских настроек (например, фильтры).
-   **Управление состоянием**: `@StateObject`, `@ObservedObject`, `@Published`, `@State` для управления UI-состоянием и данными ViewModel.
-   **Кастомный UI**: ViewModifiers для общих стилей (например, `underlineField`), кастомные компоненты, анимации (Splash Screen, переходы).
-   **Обработка ошибок**: Отображение `Alert` через `AlertItem` для информирования пользователя о сетевых или других ошибках.
-   **Зависимости**: Внедрение зависимостей (например, `AuthService`, `AppRouter`) через конструкторы ViewModel.

---

## 🔧 Установка и запуск

1.  Клонировать репозиторий:
    ```bash
    git clone https://github.com/your-org/wheelix-ios.git
    cd wheelix-ios
    ```
2.  Открыть `Wheelix.xcodeproj` в Xcode 15+ (или более новой версии).
3.  При необходимости скорректировать URL бэкенда в `HTTPClient.swift` (по умолчанию `http://localhost:3001/`).
4.  Убедиться, что серверная часть приложения (бэкенд) запущена и доступна по указанному URL (например, `final-server` из репозитория).
5.  Запустить приложение на симуляторе или физическом устройстве (минимальная версия iOS 15.0 или выше).

---

## ✅ Как всё работает (Ключевые моменты)

-   **Запуск приложения**: `SceneDelegate` инициализирует `RootView`. `RootView` показывает `SplashView`, проверяет токен через `TokenStore.shared.accessToken` и решает, показать `LoginView` или `MainTabView`.
-   **Логин**: `LoginViewModel` валидирует номер телефона (формат +7XXXXXXXXXX) и пароль (минимум 6 символов). Вызывает `AuthService.login()`, который через `HTTPClient` отправляет запрос. При успехе токены сохраняются в `TokenStore`.
-   **Навигация**: `AppRouter.shared` (синглтон) получает `UINavigationController` из `SceneDelegate` при старте и используется ViewModel'ями для переходов между экранами (`navigateToHome`, `navigateToRegister` и т.д.).
-   **Список машин (CarList)**: `CarListViewModel` загружает объявления постранично через `HTTPClient`. Использует `initialLoad` для первой загрузки, `reload` для pull-to-refresh и `loadNextIfNeeded` для бесконечного скроллинга. Данные хранятся в `allCars`, а отображаемые (`visibleCars`) фильтруются на основе `filter`.
-   **Детали машины (CarDetail)**: `CarDetailViewModel` загружает информацию о конкретной машине (`fetchOneCar`). Управляет состоянием кнопки «лайк» (`isFavorite`) и взаимодействует с API для добавления/удаления из избранного.
-   **Добавление объявления (AddCar)**: Многошаговый процесс (`AddCarFlowView`), использующий `NavigationStack` для навигации между этапами (выбор марки/модели, ввод характеристик, добавление фото и описания). Каждый шаг может иметь свою ViewModel.
-   **Профиль (Profile)**: `ProfileViewModel` загружает данные пользователя (`auth/me`) и список его избранных объявлений (`cars/me/favorites`). Поддерживает pull-to-refresh. Функция `logout` очищает токены в `TokenStore` и использует `AppRouter` для возврата на экран логина.

---
### User flow diagram
<img width="798" alt="image" src="https://github.com/user-attachments/assets/d769da26-7925-490c-95e4-b826500c5306" />

---
### Документация API (Основные эндпоинты с развернутыми примерами ответов)

*(Предполагается, что базовый URL API: `http://localhost:3001/api/v1`)*

---

#### Аутентификация (`/auth`)

*   **`POST /login`**: Вход пользователя.
    *   **Тело запроса (JSON):**
        ```json
        {
          "identifier": "+77071112233",
          "password": "user_password"
        }
        ```
    *   **Ответ (JSON - Пример):**
        ```json
        {
          "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "user": {
            "_id": "681bb3b81d1e09f19985dc02",
            "phone": "+77071112233",
            "email": "user@wheelix.kz",
            "username": "Jasper",
            "city": "Almaty",
            "avatar": "https://avatars.mds.yandex.net/get-yapic/...",
            "createdAt": "2025-05-07T19:25:44.813Z",
            "updatedAt": "2025-05-07T19:25:44.813Z"
          }
        }
        ```

*   **`POST /register`**: Регистрация нового пользователя.
    *   **Тело запроса (JSON):**
        ```json
        {
          "phone": "+77009998877",
          "password": "new_user_password",
          "username": "NewUser"
        }
        ```
    *   **Ответ (JSON - Пример):**
        ```json
        {
          "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "user": {
            "_id": "682cc3b81d1e09f19985dd03",
            "phone": "+77009998877",
            "email": null,
            "username": "NewUser",
            "city": null,
            "avatar": "https://avatars.mds.yandex.net/get-yapic/...",
            "createdAt": "2025-05-13T10:00:00.000Z",
            "updatedAt": "2025-05-13T10:00:00.000Z"
          }
        }
        ```

*   **`GET /me`**: Получение данных текущего аутентифицированного пользователя.
    *   **Заголовки:** `Authorization: Bearer <jwt_token>` (обязательно)
    *   **Ответ (JSON - Пример):**
        ```json
        {
          "_id": "681bb3b81d1e09f19985dc02",
          "phone": "+77071112233",
          "email": "user@wheelix.kz",
          "username": "Jasper",
          "city": "Almaty",
          "avatar": "https://avatars.mds.yandex.net/get-yapic/...",
          "createdAt": "2025-05-07T19:25:44.813Z",
          "updatedAt": "2025-05-07T19:25:44.813Z"
        }
        ```

---

#### Объявления (`/cars`)

*   **`GET /`**: Получение списка объявлений.
    *   **Параметры запроса (Query Parameters):** `page`, `limit`, `brandId`, `city`, `priceMin`, `priceMax`, и т.д.
    *   **Ответ (JSON - Пример):**
        ```json
        {
          "data": [
            {
              "_id": "681bb560038262c8e006d9e7",
              "seller": { // Может быть ID или популированный объект User
                "_id": "681bb3b81d1e09f19985dc02",
                "username": "Jasper",
                "phone": "+77071112233"
              },
              "brand": { // Может быть ID или популированный объект Brand
                "_id": "663fa5a8e48e9b3bd197c4b1",
                "name": "BMW"
              },
              "series": { // Может быть ID или популированный объект Series
                "_id": "663fa5d3e48e9b3bd197c4b4",
                "name": "5 Series"
              },
              "generation": { // Может быть ID или популированный объект Generation
                 "_id": "663fa5fee48e9b3bd197c4b7",
                 "code": "G30"
              },
              "vin": "WBA5D11090G123456",
              "year": 2021,
              "mileage": 43000,
              "price": 24500000,
              "currency": "KZT",
              "engine": { "volume": 2.0, "type": "petrol" },
              "gearbox": "automatic",
              "drive": "rwd",
              "steeringSide": "left",
              "customsCleared": true,
              "city": "Almaty",
              "title": "BMW 540i G30 xDrive",
              "description": "Идеальное состояние, один владелец",
              "features": ["ABS", "ESP", "Panorama"],
              "photos": ["https://cdn.wheelix.kz/cars/540-1.jpg", "https://cdn.wheelix.kz/cars/540-2.jpg"],
              "views": 150,
              "createdAt": "2025-05-07T19:32:48.174Z",
              "updatedAt": "2025-05-07T19:32:48.174Z"
            }
            // ... другие объявления ...
          ],
          "totalPages": 5,
          "currentPage": 1
        }
        ```

*   **`POST /`**: Создание нового объявления.
    *   **Заголовки:** `Authorization: Bearer <jwt_token>` (обязательно)
    *   **Тело запроса (JSON - Пример):**
        ```json
        {
          "brand": "brand_id_string", // ID марки
          "series": "series_id_string", // ID серии
          "generation": "generation_id_string", // ID поколения
          "vin": "NEWVINCODE123",
          "year": 2022,
          "mileage": 10000,
          "price": 30000000,
          "currency": "KZT",
          "engine": { "volume": 2.5, "type": "hybrid" },
          "gearbox": "automatic",
          "drive": "awd",
          "city": "Astana",
          "title": "Новое объявление Toyota Camry",
          "photos": ["url1.jpg", "url2.jpg"],
          "features": ["LED", "Cruise Control"]
        }
        ```
    *   **Ответ (JSON - Пример, аналогичен GET /{id} для созданного объявления):**
        ```json
        {
          "_id": "new_car_id_string",
          "seller": "current_user_id_string", // ID текущего пользователя
          "brand": "brand_id_string",
          // ... все остальные поля созданного объявления ...
          "views": 0,
          "createdAt": "2025-05-13T10:15:00.000Z",
          "updatedAt": "2025-05-13T10:15:00.000Z"
        }
        ```

*   **`GET /{id}`**: Получение деталей конкретного объявления.
    *   **Параметр пути:** `id` (строка ObjectId) - ID объявления.
    *   **Ответ (JSON - Пример):**
        ```json
        {
          "_id": "681bb560038262c8e006d9e7",
          "seller": {
            "_id": "681bb3b81d1e09f19985dc02",
            "username": "Jasper",
            "phone": "+77071112233",
            "city": "Almaty",
            "avatar": "https://..."
          },
          "brand": { "_id": "663fa5a8e48e9b3bd197c4b1", "name": "BMW", "country": "Germany", "logo": "url_to_bmw_logo.png" },
          "series": { "_id": "663fa5d3e48e9b3bd197c4b4", "name": "5 Series" },
          "generation": { "_id": "663fa5fee48e9b3bd197c4b7", "code": "G30", "years": { "start": 2017 } },
          "vin": "WBA5D11090G123456",
          "year": 2021,
          "mileage": 43000,
          "price": 24500000,
          "currency": "KZT",
          "engine": { "volume": 2.0, "type": "petrol" },
          "gearbox": "automatic",
          "drive": "rwd",
          "steeringSide": "left",
          "customsCleared": true,
          "city": "Almaty",
          "title": "BMW 540i G30 xDrive",
          "description": "Идеальное состояние, один владелец. Полная комплектация. Не бита, не крашена.",
          "features": ["ABS", "ESP", "Panorama", "Leather Seats", "Heated Seats", "Navigation"],
          "photos": ["https://cdn.wheelix.kz/cars/540-1.jpg", "https://cdn.wheelix.kz/cars/540-2.jpg", "https://cdn.wheelix.kz/cars/540-3.jpg"],
          "views": 152,
          "createdAt": "2025-05-07T19:32:48.174Z",
          "updatedAt": "2025-05-08T12:00:00.000Z"
        }
        ```

*   **`POST /{id}/favorite`**: Добавление объявления в избранное.
    *   **Заголовки:** `Authorization: Bearer <jwt_token>` (обязательно)
    *   **Параметр пути:** `id` (строка ObjectId) - ID объявления.
    *   **Ответ (Пример - может быть просто статус или объект избранного):**
        ```json
        // Вариант 1: Статус 200 OK / 201 Created (тело ответа может быть пустым или содержать сообщение)
        // Вариант 2: Объект созданной записи Favorite
        {
          "_id": "favorite_entry_id",
          "user": "current_user_id",
          "car": "car_id_that_was_favorited",
          "createdAt": "2025-05-13T10:20:00.000Z"
        }
        ```

*   **`DELETE /{id}/favorite`**: Удаление объявления из избранного.
    *   **Заголовки:** `Authorization: Bearer <jwt_token>` (обязательно)
    *   **Параметр пути:** `id` (строка ObjectId) - ID объявления.
    *   **Ответ:** Статус успеха (например, `200 OK` или `204 No Content`). Тело ответа обычно пустое.

*   **`GET /me/favorites`**: Получение списка избранных объявлений текущего пользователя.
    *   **Заголовки:** `Authorization: Bearer <jwt_token>` (обязательно)
    *   **Ответ (JSON - Пример):**
        ```json
        [
          {
            "_id": "favorite_entry_id_1", // ID самой записи "избранное"
            "user": "current_user_id",     // ID пользователя (для проверки)
            "car": { // Популированные данные машины
              "_id": "681bb560038262c8e006d9e7",
              "brand": { "_id": "663fa5a8e48e9b3bd197c4b1", "name": "BMW" },
              "series": { "_id": "663fa5d3e48e9b3bd197c4b4", "name": "5 Series" },
              "year": 2021,
              "price": 24500000,
              "currency": "KZT",
              "city": "Almaty",
              "title": "BMW 540i G30 xDrive",
              "photos": ["https://cdn.wheelix.kz/cars/540-1.jpg"] // Обычно достаточно одного фото для списка
            },
            "createdAt": "2025-05-11T10:25:28.434Z"
          }
          // ... другие избранные объявления ...
        ]
        ```

---

#### Справочники (если есть отдельные эндпоинты)

*   **`GET /brands`**: Список марок.
    *   **Ответ (JSON - Пример):**
        ```json
        [
          { "_id": "663fa5a8e48e9b3bd197c4b1", "name": "BMW", "country": "Germany", "logo": "url_to_bmw_logo.png" },
          { "_id": "665b11aa7f9f63d4fcabb003", "name": "Mercedes-Benz", "country": "Germany", "logo": "url_to_mercedes_logo.png" },
          { "_id": "some_toyota_id", "name": "Toyota", "country": "Japan", "logo": "url_to_toyota_logo.png" }
        ]
        ```

*   **`GET /series`**: Список моделей/серий.
    *   **Параметры запроса (Query):** `brandId={id}` (опционально, для фильтрации по марке)
    *   **Ответ (JSON - Пример для `?brandId=663fa5a8e48e9b3bd197c4b1`):**
        ```json
        [
          { "_id": "663fa5d3e48e9b3bd197c4b4", "name": "5 Series", "brand": "663fa5a8e48e9b3bd197c4b1" },
          { "_id": "some_3_series_id", "name": "3 Series", "brand": "663fa5a8e48e9b3bd197c4b1" },
          { "_id": "some_x5_id", "name": "X5", "brand": "663fa5a8e48e9b3bd197c4b1" }
        ]
        ```

*   **`GET /generations`**: Список поколений.
    *   **Параметры запроса (Query):** `seriesId={id}` (опционально, для фильтрации по серии)
    *   **Ответ (JSON - Пример для `?seriesId=663fa5d3e48e9b3bd197c4b4`):**
        ```json
        [
          { "_id": "663fa5fee48e9b3bd197c4b7", "code": "G30", "series": "663fa5d3e48e9b3bd197c4b4", "years": { "start": 2017 } },
          { "_id": "some_f10_id", "code": "F10", "series": "663fa5d3e48e9b3bd197c4b4", "years": { "start": 2010, "end": 2017 } }
        ]
        ```

*(Примечание: Это детальные примеры. Реальный API может возвращать меньше полей в списках для оптимизации и больше — в детальных запросах. Также, `seller`, `brand`, `series`, `generation` в объекте `Car` могут возвращаться как полные вложенные объекты (если используется `populate` на бэкенде) или просто как ID (строки ObjectId), если популяция не настроена для конкретного эндпоинта.)*

---

## 📋 Соответствие требованиям (Примерная таблица)

| Требование                        | Реализация                                                                 |
| --------------------------------- | -------------------------------------------------------------------------- |
| SwiftUI + MVVM                    | Все экраны построены на SwiftUI, каждая View имеет свою ViewModel.         |
| Навигация через UIKit             | `UIHostingController` используется для интеграции SwiftUI View в иерархию `UINavigationController`, управляемую `AppRouter`. |
| Async/await                       | Все сетевые запросы и асинхронные операции выполнены с использованием `async/await`. |
| Минимум 4–5 экранов               | Реализовано: Splash, Login, Register, CarList, CarDetail, AddCar (несколько шагов), Profile. |
| Локальное хранение                | `UserDefaults` используется для хранения JWT-токенов (`TokenStore`) и, возможно, фильтров. |
| Аутентификация JWT                | Вход и регистрация реализованы через `AuthService`, который работает с JWT. |
| Обработка ошибок и лоадеры        | Используются `AlertItem` для отображения ошибок пользователю и `ProgressView` для индикации загрузки. |
| Combine / `@ObservableObject`     | ViewModel'ы являются `@ObservableObject`, данные публикуются через `@Published`. |
| Оптимизация                       | `LazyVGrid` / `List` для списков, `AsyncImage` для загрузки изображений, `onAppear` для подгрузки данных. |
| Кастомные модификаторы и анимации | Используются ViewModifier'ы для стилизации (например, полей ввода), анимация на Splash Screen, плавные переходы. |
| SPM                               | Предполагается использование SPM для любых внешних зависимостей (если есть). |
