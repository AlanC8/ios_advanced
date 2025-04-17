# iOS Development Assignment: Concurrent Weather Data App

## Overview
In this assignment, you will build a weather application that demonstrates the power of Swift's modern concurrency system. The app will fetch multiple weather data points concurrently (forecasts, current conditions, weather maps, etc.) from a public weather API and display them to the user as each one finishes loading, rather than waiting for all data to complete.

## Learning Objectives
- Implement Swift's modern concurrency features (async/await, Task, TaskGroup)
- Understand how to manage multiple concurrent network requests
- Create responsive UIs that update as data becomes available
- Apply proper error handling in asynchronous contexts
- Implement cancellation in concurrent operations

## Requirements

### Core Features
1. Create a UI using SwiftUI that displays multiple weather data components
2. Implement concurrent fetching of at least 5 different weather data points. For example:
   - Current conditions
   - 5-day forecast
   - Weather radar/map
   - Air quality data
   - Weather alerts or warnings
3. Display each component immediately as it loads, with appropriate loading indicators
4. Show loading progress for each component (either with a progress bar or status text)
5. Implement proper error handling for failed data loads
6. Add a refresh button to reload all weather data

### Advanced Features (For Higher Grades)
1. Implement cancellation of ongoing data fetch operations
2. Add the ability to search for different locations
3. Implement data caching to improve performance
4. Create detail views when a weather component is tapped
5. Support both light and dark mode with appropriate UI adjustments

## Suggested Weather APIs
Here are some open-source weather APIs you can use for this assignment:

1. **OpenWeatherMap API** - [https://openweathermap.org/api](https://openweathermap.org/api)
   - Offers current weather, forecasts, and maps
   - Generous free tier with simple API key registration

2. **WeatherAPI** - [https://www.weatherapi.com/](https://www.weatherapi.com/)
   - Comprehensive weather data
   - Free tier available with API key

3. **National Weather Service API** - [https://www.weather.gov/documentation/services-web-api](https://www.weather.gov/documentation/services-web-api)
   - US weather data
   - No API key required

4. **Tomorrow.io API** - [https://www.tomorrow.io/weather-api/](https://www.tomorrow.io/weather-api/)
   - Detailed weather forecasts and conditions
   - Free tier with registration

5. **AccuWeather API** - [https://developer.accuweather.com/](https://developer.accuweather.com/)
   - Comprehensive weather information
   - Free tier with limited requests

## Technical Requirements
1. Use MVVM architecture pattern
2. Use Swift's structured concurrency with proper error handling
3. Use `Task` and `TaskGroup` to manage concurrent weather data loading
4. Update the UI immediately when data is ready
5. Create an enum for different loading states
6. Implement proper error handling for network requests

## Grading Rubric

### Functionality
- **Concurrent Data Loading**
  - Successfully implements Swift's modern concurrency features
  - Data loads concurrently rather than sequentially
  - Each component displays as soon as it's loaded

- **UI Implementation**
  - Weather interface is properly implemented using SwiftUI
  - Loading states are clearly indicated to the user
  - UI updates are performed on the main thread using @MainActor

- **Error Handling**
  - Proper error handling for network requests
  - Appropriate UI feedback when errors occur
  - Implementation of retry functionality

### Code Quality
- **Architecture**
  - Clear separation of concerns (Model, View, ViewModel)
  - Proper use of SwiftUI state management
  - Clean, organized project structure

- **Swift Concurrency Implementation**
  - Correct implementation of async/await
  - Proper use of TaskGroups for concurrent operations
  - Implementation of cancellation

- **Documentation and Code Style**
  - Code is well-commented and follows Swift style guidelines
  - README explains the project structure and features
  - Variable and function names are clear and descriptive

### Advanced Features
- **Caching**
  - Implementation of data caching for improved performance
  - Cache expiration/management

- **Additional UI Features (5 points)**
  - Location search functionality
  - Animation and transitions between states
  - Dark mode support

## Submission Requirements

1. **Source Code**
   - Complete Xcode project with all source files
   - Remove any API keys before submission
   - Ensure the project builds without errors

2. **Documentation**
   - README.md file containing:
     - Project overview
     - Setup instructions (including any API registration required)
     - Features implemented
     - Known issues or limitations
     - Any third-party libraries used and why

3. **Demo Video**
   - 2-3 minute screen recording demonstrating the app's functionality
   - Narration explaining how concurrency is implemented
   - Demonstration of error states and edge cases

## Submission Format
- Xcode project
- Demo video (linked or uploaded separately)
- Submit to the git repository