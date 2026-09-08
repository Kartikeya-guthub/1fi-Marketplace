# 1Fi Marketplace Assignment

A pixel-faithful implementation of the 1Fi Marketplace feature inside the existing Shop experience, built with Flutter.

## Architecture

This project uses a feature-first architecture (`features/shop`, `features/marketplace`) with a shared `core/` design system to maximize component reusability. 

State management is handled cleanly by **Riverpod**, separating the UI from the mock API data layer.

## Design Decisions

1. **2→3 Tab Switcher**: The original pill tab switcher in the reference screenshots is designed for exactly 2 equal-width segments (Top Brands, Nearby Stores). Adding a 3rd segment breaks the layout. I implemented a solution that dynamically scales to 3 equal-width segments with a concise "Marketplace" label.
2. **Mock Data**: Since no official product reference material was provided, I anchored the mock product catalog to the actual categories advertised in the 1Fi hero banner (iPhone, MacBook, BMW, Honda Activa, Apple Watch, TV). This proves product understanding rather than using random mock data.
3. **Repository Pattern**: The `MockMarketplaceApi` implements an abstract `MarketplaceApi` interface and is injected via Riverpod. This means you can swap the mock API for your real production API without touching the UI code.
4. **Shimmer Skeleton**: I avoided generic loading spinners and instead built a custom `AppSkeleton` that exactly matches the full-page shimmer pattern from the reference screenshots.
5. **Confirmation Sheet**: To prevent the flow from dead-ending when clicking the CTA button, I added a summary confirmation bottom sheet.

## Execution

The app supports all states out-of-the-box:
- **Loading**: `AppSkeleton`
- **Data**: Product grid and details page
- **Empty**: Graceful empty state illustration
- **Error**: Provable error state with a functioning Retry button (you can toggle `shouldFail = true` in `mock_marketplace_api.dart` to test this).

## How to Run

1. Make sure Flutter SDK is installed.
2. Run `flutter pub get`
3. Run `flutter run`
