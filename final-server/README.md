# Habit Tracker API

A FastAPI-based RESTful API for tracking habits, with features similar to habit tracking mobile apps. The API allows users to create habits, track daily completions, and view statistics about their progress.

## Features

- 👤 **User Authentication**: Register, login, and manage user accounts
- 📝 **Habit Management**: Create, read, update, and delete habits
- ✅ **Daily Tracking**: Mark habits as completed for each day
- 📊 **Statistics**: Calculate streaks and completion rates
- 📆 **Calendar View**: View habit completion history by date range

## Getting Started

### Prerequisites

- Python 3.9+
- pip (Python package manager)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/habit-tracker-api.git
cd habit-tracker-api
```

2. Install dependencies
```bash
pip install -r requirements.txt
```

3. Run the application
```bash
uvicorn main:app --reload
```

The API will be available at http://localhost:8000

### API Documentation

Once the application is running, you can access the auto-generated Swagger documentation at http://localhost:8000/docs

## API Endpoints

### Authentication
- `POST /users/` - Register a new user
- `POST /users/token` - Login and get access token

### Users
- `GET /users/me` - Get current user information
- `PUT /users/me` - Update user information

### Habits
- `POST /habits/` - Create a new habit
- `GET /habits/` - List all habits
- `GET /habits/{habit_id}` - Get a specific habit
- `PUT /habits/{habit_id}` - Update a habit
- `DELETE /habits/{habit_id}` - Delete a habit

### Tracking
- `POST /tracking/habits/{habit_id}/entries` - Create or update a tracking entry
- `GET /tracking/habits/{habit_id}/entries` - Get tracking entries for a habit
- `GET /tracking/entries/{entry_id}` - Get a specific tracking entry
- `PUT /tracking/entries/{entry_id}` - Update a tracking entry
- `DELETE /tracking/entries/{entry_id}` - Delete a tracking entry
- `GET /tracking/today` - Get today's tracking entries for all habits

## Built With

- [FastAPI](https://fastapi.tiangolo.com/) - Modern, fast web framework for building APIs
- [SQLAlchemy](https://www.sqlalchemy.org/) - SQL toolkit and ORM
- [Pydantic](https://pydantic-docs.helpmanual.io/) - Data validation and settings management
- [JWT](https://jwt.io/) - JSON Web Tokens for authentication

## License

This project is licensed under the MIT License - see the LICENSE file for details 