# Food Recipe App

**Welcome to the Food Recipe app repository! This app provides a user-friendly interface for browsing and discovering various food recipes. It leverages the Yummly API through the RapidAPI service to fetch recipe data, and it also integrates Firebase for user authentication and storage. which the Firebase allows new users to create an account and access the full features of the Food Recipe app. With a simple and intuitive interface, signing up is a breeze.**

## Features
User Registration and Authentication:

- Sign up with email and password using Firebase Authentication.

- Sign in with existing credentials or create a new account.

- Sign in with a phone number using Firebase Phone Authentication.

- Sign in with Google account using Firebase Google Authentication.

## Recipe Search and Browsing:

- Browse a wide range of recipes fetched from the Yummly API.
- Search for recipes based on keywords, ingredients, or categories.
- View detailed information for each recipe, including ingredients and instructions.

## Favorites:

- Save favorite recipes to a personal favorites list.
- Access the favorites list to quickly find and reference saved recipes.

# Screens

The app consists of the following screens:

## Login Screen:

- Allows users to sign in to their accounts or create a new account to access the full features of the Food Recipe App!.
- Provides options for signing in with email and password, phone number, or Google account.

<img src="https://user-images.githubusercontent.com/76783878/235755045-b53bf3a9-3ad2-48c7-82e6-4b0519f3f909.png" alt="Login Screen" width="250" height="500">  <img src="https://user-images.githubusercontent.com/76783878/235758263-08cf9b4b-7c91-4974-ac94-bf1bbba935c8.png" alt="Signup Screen" width="250" height="500">


## Home Screen:

- Displays a list of featured recipes and categories for browsing.
- Allows users to search for specific recipes or explore different categories.

<img src="https://user-images.githubusercontent.com/76783878/235755853-8e1a99a0-e59b-4560-86a0-50f448c3f96a.png" alt="Home Screen" width="250" height="500">

## Recipe Detail Screen:

- Provides detailed information about a specific recipe.
- Shows the recipe name, image, ingredients, and instructions.
- Allows users to add the recipe to their favorites list.

<img src="https://user-images.githubusercontent.com/76783878/235756080-0f484195-a45d-4aba-82e8-e38681e8c2a2.png" alt="Recipe Detail Screen" width="250" height="500">

## Favorites Screen:

- Displays a list of the user's favorite recipes.
- Allows users to view and access their saved recipes.
- Provides options to remove recipes from the favorites list.

<img src="https://user-images.githubusercontent.com/76783878/235756099-6f7d8868-0dfe-4dad-8203-ad5d1598c6b1.png" alt="Alt text" width="250" height="500">

# Dependencies and Packages

These are some of the main packages and dependencies used in the development of the Food Recipe app:

- shared_preferences: ^2.1.0 - Provides a persistent key-value store for storing user preferences.
- google_nav_bar: ^5.0.6 - Offers a customizable bottom navigation bar with smooth animations and icons.
- font_awesome_flutter: ^10.4.0 - Allows you to use FontAwesome icons in your Flutter app.
- staggered_grid_view_flutter: ^0.0.4 - Implements a staggered grid view for displaying a dynamic grid of items with various sizes.
- flutter_staggered_grid_view: ^0.6.2 - Provides a responsive staggered grid view with customizable parameters.
- firebase_auth: ^4.4.2 - Enables authentication using Firebase Authentication services.
- firebase_core: ^2.10.0 - Initializes Firebase services and provides necessary configuration for Firebase plugins.
- lottie: ^2.3.2 - Renders animations created with Adobe After Effects in Flutter apps using Lottie format.
- cloud_firestore: ^4.5.3 - Offers a cloud-based NoSQL database for storing and syncing app data.
- http: ^0.13.5 - Provides functions for making HTTP requests and handling responses.
- google_sign_in: ^6.1.0 - Implements Google Sign-In functionality for authenticating users with their Google accounts.
- bottom_bar_matu: ^1.3.0 - Renders a customizable bottom navigation bar with different styles and animations.
- flashy_tab_bar2: ^0.0.6 - Displays a flashy tab bar with customizable animations and effects.
- provider: ^6.0.5 - Implements state management and dependency injection using the Provider pattern.
- firebase_database: ^10.1.1 - Offers real-time data synchronization and storage using Firebase Realtime Database.

These packages provide various functionalities for your Food Recipe app, including data storage, authentication, UI components, animations, and more.

# Getting Started

To run the Food Recipe app locally, follow these steps:

## 1. Clone the repository:

```git clone https://github.com/your-username/food-recipe-app.git```

## 2. Install the dependencies: 

```cd food-recipe-app``` then ```flutter pub get```

## 3. Set up the Firebase project:

- Create a new Firebase project in the Firebase Console.
- Enable Firebase Authentication and Firestore in the project.
- Add the necessary configuration files to the app following the Firebase documentation.
## 4.  Set up the RapidAPI service:

- Sign up for a RapidAPI account and subscribe to the Yummly API.
- Obtain the API key required for accessing recipe data.

## 5. Update the configuration:

- Replace the placeholder API keys and Firebase configuration values in the app code with your own credentials.

## 6. Run the app:

- Connect a device or start an emulator.
- Run the following command:

```flutter run```

# Technologies Used

- Flutter: A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- Firebase: A comprehensive development platform that includes tools and services for building and managing mobile and web apps.
- RapidAPI: A platform that allows developers to access a wide range of APIs and integrate them into their applications.

# License

- This project is licensed under the [MIT License](https://opensource.org/license/mit/)

# Credits

- [Yummly API](https://yummly.com)
- [RapidAPI](https://rapidapi.com)


