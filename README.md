# Taghyeer — Flutter Technical Test

A Flutter application built as a technical assessment. It demonstrates clean architecture, feature-first folder structure, BLoC/Cubit state management, token-based authentication with automatic refresh, and paginated data fetching — all backed by the public [DummyJSON](https://dummyjson.com) API.

---

## Table of Contents

- [Features](#features)
- [Tech Stack & Packages](#tech-stack--packages)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Screens](#screens)
- [Authentication Flow](#authentication-flow)
- [API Integration](#api-integration)

---

## Features

- **Authentication** — Login with username/password. JWT access and refresh tokens are persisted locally. The Dio interceptor automatically retries requests with a refreshed token on 401 responses and logs the user out if the refresh also fails.
- **Posts** — Infinitely scrollable list of posts fetched from DummyJSON. Each post can be tapped to view full details including stats (views, likes, dislikes), tags, body content, and author info.
- **Products** — Infinitely scrollable grid of products. Each product opens a detail page with an image carousel, category/brand chips, star rating, stock badge, discounted price, description, SKU/weight/dimensions grid, shipping policies, and customer reviews.
- **Settings** — Displays the currently logged-in user's profile (avatar, name, username, email). Lets the user switch between System, Light, and Dark themes. Provides a confirmation-guarded logout action.
- **Theme** — System/Light/Dark mode toggle persisted across sessions via `shared_preferences`.
- **Shimmer loading** — Skeleton placeholders are shown while the first page of data loads.
- **Fade-in images** — All network images use `FadeInImage.memoryNetwork` for a smooth loading experience.
- **Error states** — Distinguishes between no-internet and generic server errors, with a retry button.

---

## Tech Stack & Packages

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management via Cubit |
| `dio` | HTTP client with interceptor-based token refresh |
| `shared_preferences` | Persistent local storage for tokens and user data |
| `equatable` | Value equality for BLoC states |
| `infinite_scroll_pagination` | Cursor-based infinite scroll for Posts and Products |
| `shimmer` | Skeleton loading placeholders |
| `transparent_image` | `kTransparentImage` placeholder for `FadeInImage` |
| `lucide_icons` | Consistent icon set throughout the app |

**Font:** BricolageGrotesque (Regular, Medium, SemiBold, Bold) — bundled in `assets/fonts/`.

---

## Architecture

The project follows a **feature-first** folder structure combined with a lightweight **Repository + Cubit** pattern:

```
UI Layer (Pages / Widgets)
        │
        ▼
  Cubit (State management)
        │
        ▼
  Repository (Data access abstraction)
        │
        ▼
  DioClient (Singleton HTTP client with token interceptor)
        │
        ▼
  DummyJSON REST API
```

- **Pages** hold navigation scaffolding and delegate all display logic to dedicated widget files.
- **Cubits** orchestrate async operations and emit typed states (`Loading`, `LoggedIn`, `Error`, etc.).
- **Repositories** are injected into Cubits and are the only classes that know about the network layer.
- **DioClient** is a singleton. Its `InterceptorsWrapper` attaches the `Authorization` header on every request and handles transparent token refresh on 401 responses.
- **LocalStorage** wraps `shared_preferences` with typed getters/setters for access token, refresh token, and the user profile map.

---

## Project Structure

```
lib/
├── main.dart                        # App entry point
├── _app.dart                        # MaterialApp, theme, BLoC providers
│
├── core/
│   ├── constants/_app_constants.dart   # API base URL, endpoints, UI strings
│   ├── network/_dio_client.dart        # Singleton Dio instance + interceptors
│   └── storage/_local_storage.dart    # shared_preferences wrappers
│
├── shared/
│   ├── bloc/_theme_cubit.dart          # ThemeMode state
│   └── widgets/                        # App-wide reusable widgets
│
└── features/
    ├── auth/
    │   ├── bloc/_auth_cubit.dart        # Login, logout, session check
    │   ├── pages/_login_page.dart
    │   ├── repository/_auth_repository.dart
    │   └── widgets/
    │
    ├── splash/
    │
    └── dashboard/
        ├── _wrapper.dart               # Bottom navigation shell
        │
        ├── posts/
        │   ├── bloc/_post_cubit.dart
        │   ├── models/_post_model.dart
        │   ├── pages/
        │   │   ├── _post_page.dart
        │   │   └── _post_detail_page.dart
        │   ├── repository/_post_repository.dart
        │   └── widgets/
        │       ├── _post_card.dart
        │       ├── _post_stat_item.dart
        │       ├── _posts_shimmer_list.dart
        │       └── _posts_error_view.dart
        │
        ├── products/
        │   ├── bloc/_product_cubit.dart
        │   ├── models/_product_model.dart
        │   ├── pages/
        │   │   ├── _product_page.dart
        │   │   └── _product_detail_page.dart
        │   ├── repository/_product_repository.dart
        │   └── widgets/
        │       ├── _product_card.dart
        │       ├── _image_carousel.dart
        │       ├── _star_rating.dart
        │       ├── _stock_badge.dart
        │       ├── _details_grid.dart
        │       ├── _info_tile.dart
        │       ├── _review_card.dart
        │       ├── _product_chip.dart
        │       ├── _product_shimmer_grid.dart
        │       └── _product_error_view.dart
        │
        └── settings/
            ├── pages/_settings_page.dart
            └── widgets/
                ├── _user_info_card.dart
                ├── _appearance_section.dart
                ├── _logout_tile.dart
                └── _section_label.dart
```

---

## Screens

| Screen | Description |
|---|---|
| **Splash** | Short branded intro before the session check resolves |
| **Login** | Username + password form. Validates inputs and shows inline errors |
| **Posts** | Paginated list; shimmer on first load, error view with retry on failure |
| **Post Detail** | Full post body, tag chips, stats row (views / likes / dislikes), author |
| **Products** | Paginated 2-column grid; shimmer skeleton, error view with retry |
| **Product Detail** | Image carousel, pricing with discount badge, details grid, policies, reviews |
| **Settings** | User profile card, theme switcher, logout |

---

## Authentication Flow

```
App start
    │
    ▼
AuthCubit.checkLogin()
    │
    ├─ access token found → AuthLoggedIn  → Dashboard
    └─ no token          → AuthUnauthenticated → Login
                                │
                                ▼
                        User submits credentials
                                │
                                ▼
                        POST /auth/login
                                │
                        Save accessToken + refreshToken
                        Save user profile (without tokens)
                                │
                                ▼
                            AuthLoggedIn → Dashboard
```

When any API call returns **401**, the Dio interceptor:
1. Attempts `POST /auth/refresh` with the stored refresh token.
2. On success — saves the new tokens and retries the original request transparently.
3. On failure — calls `onUnauthorized()` which triggers `AuthCubit.logout()`, clearing storage and navigating to the Login screen.

---

## API Integration

All data comes from **[https://dummyjson.com](https://dummyjson.com)** — a free mock REST API.

| Endpoint | Used by |
|---|---|
| `POST /auth/login` | Login |
| `POST /auth/refresh` | Token refresh (interceptor) |
| `GET /posts?skip=&limit=` | Post pagination |
| `GET /products?skip=&limit=` | Product pagination |

Pagination uses **skip/limit** offsets. `PagingController` from `infinite_scroll_pagination` manages page keys, and the `fetchPage` callback delegates to the relevant repository method.
