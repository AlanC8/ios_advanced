# iOS Advanced Development Course Assignment

## HeroApp using MVVM + Router

Due Date: March 25, 2025

### Project Overview

Create a SuperHero application that fetches heroes data from the Superhero API and presents it in an intuitive, user-friendly interface.

### Technical Requirements

- Use Swift and SwiftUI for the implementation
- Implement MVVM architecture pattern
- Implement Router for navigation stack
    - Use UINavigationController for routing embeded SwiftUI views
- Implement Service for all network requests
- Include proper error handling and loading states
- Use URLSession for network requests
- Implement proper memory management

### Core Features

- Hero list display showing:
    - Hero image
    - Full name
    - Power stats
    - Biography details
    - Any extra info from response based on your UI
- Detailed hero view with complete information
- Search functionality by hero name in hero list

### API Integration

- Implement endpoints:
    - /all.json - for fetching all heroes
    - /id/{id}.json - for fetching specific hero details

### UI Requirements

- Clean and modern interface
- Proper constraint layout for various iPhone sizes
- Smooth animations for state transitions
- Hero card design with image and basic info

### Code Quality Criteria

| **Criteria** | **Points** |
| --- | --- |
| Code Architecture | 30 |
| Functionality | 30 |
| UI/UX Design | 20 |
| Code Quality | 20 |

### Submission Guidelines

- Submit via GitHub repository
- Include README with setup instructions
- Provide a brief documentation of your architecture decisions
- Record a short demo video showing the app's functionality

### Bonus Points

- Adding favorites functionality

<aside>
Note: The Superhero API (akabab.github.io/superhero-api) is free to use and doesn't require an API key. However, make sure to implement proper error handling and caching mechanisms to handle API limitations and provide a smooth user experience.

</aside>