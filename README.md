# E-Commerce App

A small Flutter e-commerce application built as part of a Flutter development assignment.

The app demonstrates:
- Mock email/password authentication
- Product listing
- Adding products to cart
- Cart quantity management
- Removing products from cart
- Total price calculation
- Shared cart state between Home and Cart screens

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture.

### Project Structure

```text
lib/
├── models/
│   ├── product.dart
│   └── cart_item.dart
│
├── views/
│   ├── login/
│   │   └── login_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   └── cart/
│       └── cart_screen.dart
│
├── viewmodels/
│   ├── cart_cubit.dart
│   └── cart_state.dart
│
├── widgets/
│   ├── product_image.dart
│   └── app_bottom_nav.dart
│
├── data/
│   └── products.dart
│
└── main.dart
```

### Architecture Approach

- **Models** represent the application's data.
- **Views** are responsible for displaying the UI.
- **ViewModel** contains the cart logic and manages the state used by the UI.

For this small project, a simple MVVM structure was used without additional layers such as repositories or use cases, keeping the architecture appropriate to the project's scope.

## State Management

The cart state is managed using **Cubit** from the `flutter_bloc` package.

The state flow is:

```text
CartCubit
    ↓
CartState
    ↓
BlocBuilder
    ↓
UI
```

`CartCubit` handles the cart operations, while `CartState` represents the current cart data.

The main operations include:

- Add product
- Increase quantity
- Decrease quantity
- Remove product
- Clear cart

## Main State Data

`CartState` contains the current list of cart items and provides calculated values such as:

- Total item count
- Total cart price
- Quantity of a specific product

When the cart changes, `CartCubit` emits a new `CartState`, allowing the relevant UI to rebuild automatically.

## Technical Decisions

- **Flutter & Dart** — application development
- **MVVM** — project architecture
- **Cubit / flutter_bloc** — state management
- **Mock local product data** — no backend is required for the assignment
- **Shared CartCubit** — keeps the cart state available across Home and Cart screens
- **Reusable widgets** — common UI components are separated into the `widgets` folder

## Challenges

One of the main challenges was keeping the cart state synchronized between different screens.

The cart initially used `ChangeNotifier` and was later migrated to Cubit to separate cart logic and state management from the UI.

Another consideration was keeping the architecture simple and appropriate for the project's size without introducing unnecessary complexity.

## Future Improvements

For a production application, the project could be extended with:

- Real backend APIs
- User authentication
- Persistent cart storage
- Repository and data-source layers
- Loading and error states
- Unit and widget testing
- Dependency injection
- Pagination and caching
- Payment and order management