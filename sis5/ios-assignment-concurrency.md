# iOS Development Assignment: Pinterest-Style Image Gallery App

## Overview

In this assignment, you will create a Pinterest-style image gallery application using SwiftUI. The app will fetch random images from an API, display them in a grid layout, and implement proper concurrency patterns using Grand Central Dispatch (GCD).

## Learning Objectives

- Implement the MVVM architectural pattern in a SwiftUI application
- Use Grand Central Dispatch for concurrent operations
- Work with network requests to download images
- Create responsive grid layouts in SwiftUI
- Handle asynchronous UI updates

## Requirements

### Core Features

1. Create a SwiftUI application that downloads 5 random images from https://picsum.photos/ when a button is pressed. Each time when button pressed, you should add 5 more images to existing list of images.
2. Implement image downloading concurrently on a background thread
3. Use DispatchGroup to ensure all images are downloaded before updating the UI
4. Display images in a grid layout for a Pinterest-like experience
5. Follow the MVVM (Model-View-ViewModel) architecture pattern
6. Implement all concurrency using GCD (Grand Central Dispatch)

### Project Structure

Your project should follow the MVVM architecture:

- **Models**: Define data structures for images
- **Views**: SwiftUI views including the grid layout and image components
- **ViewModels**: Business logic for fetching images and managing state

## Advanced Challenges

For students who finish early or want to challenge themselves:

1. Implement a pull-to-refresh feature
2. Add image caching to prevent downloading the same images multiple times
3. Create a detail view when an image is tapped
4. Add error handling for failed downloads
5. Implement infinite scrolling to load more images when reaching the bottom

## Evaluation Criteria

Your assignment will be evaluated based on:

1. Correct implementation of MVVM architecture
2. Proper use of GCD for concurrent image downloads
3. Correct implementation of DispatchGroup for synchronization
4. Quality of SwiftUI grid layout implementation
5. Code organization and readability
6. Error handling and edge cases
7. Overall user experience

## Submission

Submit your complete Xcode project to your GitHub repository.