# books_discovery_app

## Overview
A Flutter mobile app demonstrating proficiency in state management, authentication, navigation, API integration, and use of native device features.  
The app allows users to discover books, authenticate via email or Google, access device contacts, view analytics, and manage their profile.

---

## Features

### 1. Authentication
- Email/Password login and registration
- Google Sign-In
- Display user profile info after login
- Firebase Authentication used

### 2. State Management
- **Riverpod** used for app-wide state
- Login state persisted between app launches

### 3. Auto route Navigation
- Bottom Navigation Bar with 4 tabs: Home, Analytics, Contacts, Profile
- Each tab supports stacked navigation using AutoRoute

### 4. Home Tab (Google Books Search)
- Search bar to query books using the Google Books API
- List of books displayed with title, thumbnail, and short description
- Book Detail screen with full info and other books by the same author
- Search history maintained

### 5. Analytics Tab
- **Genre Distribution:** Pie/Donut chart
- **Book Publishing Trend:** Bar/Line chart (2021–2025)
- **Sales Overview:** Monthly/quarterly simulated sales data
- Charts animated on appearance

### 6. Contacts Tab
- Request permission and display device contacts
- On tap, shows BottomSheet with contact name, phone, email, and user profile

### 7. Profile Tab
- Show user name, email, profile picture
- Animated UI elements using Hero, SizeTransition, AnimatedContainer
- Logout button
- Change profile picture with gallery permission

---


## State Management
- **Riverpod** manages authentication, search history, book list, and user profile
- Providers and StateNotifiers used for async data and reactive UI updates

---

## Assumptions / Limitations
- App tested only on Android
- Firebase API keys not shared
- Only main features implemented as per test requirements
- Some animations may differ on older devices

---

## Firebase Setup
- Firebase project configured for Authentication and Firestore
- Steps to run locally:
    1. Download your own `google-services.json` from Firebase console
    2. Place it in `android/app/` directory
    3. Enable Email and Google sign-in


## How to Run
1. Clone the repository:
```bash
git clone https://github.com/Kishan04sh/books_discovery_app.git