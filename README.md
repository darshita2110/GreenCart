# GreenCart 🥬🛒

A fresh produce shopping app built with Flutter, Firebase Authentication, and Riverpod state management.

## Features

- **Splash Screen** – Animated splash with auto-login detection
- **Onboarding** – 3-page onboarding flow for first-time users
- **Authentication** – Login, Sign-up, and Forgot Password using Firebase Auth
- **Home Page** – Browse fruits, vegetables, leafy greens, roots, and exotic produce
- **Search** – Real-time search across all products
- **Category Filter** – Filter products by category with horizontal chip selector
- **Product Details** – Full product view with image, rating, description, and quantity picker
- **Shopping Cart** – Add/remove items, update quantities, checkout flow
- **Profile** – User profile with settings menu and logout
- **Bottom Navigation** – Home, Cart (with badge), and Profile tabs

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| State Management | Riverpod (flutter_riverpod) |
| Authentication | Firebase Auth |
| Database | Local JSON (assets/data/products.json) |
| Routing | Named routes with onGenerateRoute |
| Fonts | Google Fonts (Poppins) |
| Architecture | Clean Architecture |

## Architecture

```
lib/
├── main.dart                     # app entry point, firebase init
├── app.dart                      # MaterialApp setup with theme
├── firebase_options.dart         # firebase config
│
├── config/
│   ├── constants/                # app-wide constants
│   ├── routes/                   # route definitions
│   └── theme/                    # colors, text styles, theme data
│
├── models/
│   ├── product.dart              # product model with fromJson
│   ├── user.dart                 # user model for auth
│   ├── cart_item.dart            # cart item model
│   └── validators.dart           # form validation logic
│
├── providers/
│   ├── auth_provider.dart        # auth state (login, signup, forgot password)
│   ├── product_provider.dart     # product loading, search, filter
│   └── cart_provider.dart        # cart state management
│
├── services/
│   ├── auth_service.dart         # firebase auth operations
│   └── product_service.dart      # load products from json
│
├── screens/
│   ├── splash_screen.dart        # animated splash with auth check
│   ├── onboarding_screen.dart    # 3-page onboarding
│   ├── login_screen.dart         # email/password login
│   ├── signup_screen.dart        # create account
│   ├── forgot_password_screen.dart
│   ├── main_navigation_screen.dart  # bottom nav shell
│   ├── home_screen.dart          # product browse + search
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart          # shopping cart
│   └── profile_screen.dart       # user profile
│
└── widgets/
    ├── custom_button.dart        # reusable button component
    ├── custom_text_field.dart    # reusable text field
    ├── product_card.dart         # product grid card
    ├── product_grid.dart         # responsive product grid
    └── product_search_bar.dart   # search input
```

## State Management (Riverpod)

All state is managed through Riverpod providers:

- `authStateProvider` – StreamProvider listening to Firebase auth changes
- `loginProvider` / `signupProvider` – StateNotifier for auth forms
- `allProductsProvider` – FutureProvider loading products from JSON
- `searchQueryProvider` / `selectedCategoryProvider` – StateProviders for filtering
- `cartProvider` – StateNotifier for cart operations
- `cartItemCountProvider` / `cartTotalProvider` – derived providers

## Responsive Design

- Product grid adapts to screen width (2/3/4 columns)
- Product detail image scales with screen height
- All layouts use flexible sizing with MediaQuery
- Buttons and inputs use full-width on mobile

## Setup

1. Clone the repo
2. Run `flutter pub get`
3. Set up a Firebase project and update `lib/firebase_options.dart`
4. Enable Email/Password auth in Firebase Console
5. Run with `flutter run`

## Screenshots

The app includes:
- Green-themed UI with Poppins font
- Animated splash screen
- Swipeable onboarding pages with dot indicators
- Form validation on login/signup
- Product cards with real produce images
- Category filter chips
- Cart with quantity controls and checkout
- Profile page with avatar and settings menu
