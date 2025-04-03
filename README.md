# Budget App

A Flutter application for budget management with clean architecture.

## Project Structure

This project follows the Clean Architecture principles, organizing code into distinct layers:

### Core Layer

Located in `lib/core`, contains code reused across the entire application without specific business logic:

- **constants/**: Application-wide constants
- **errors/**: Error handling classes and exceptions
- **network/**: Network utility classes
- **themes/**: Application themes and styles
- **utils/**: Utility classes and helper functions

### Domain Layer

Located in `lib/domain`, the core business logic of the application:

- **entities/**: Pure business objects without external dependencies
- **repositories/**: Abstract interfaces defining operations
- **usecases/**: Single-responsibility classes implementing business logic

### Data Layer

Located in `lib/data`, implements repositories from the domain layer:

- **datasources/**: Classes to fetch data from specific sources (local/remote)
- **models/**: Data models extending domain entities with serialization methods
- **repositories/**: Implementation of domain repository interfaces

### Presentation Layer

Located in `lib/presentation`, handling UI and state management:

- **bloc/**: Business Logic Components for state management
- **pages/**: Complete screens in the application
- **widgets/**: Reusable UI components

### Dependency Injection

Located in `lib/di`, manages dependencies throughout the app:

- **injection_container.dart**: Main configuration for dependency injection
- **auth_injection.dart**: Authentication-related dependencies
- **transaction_injection.dart**: Transaction-related dependencies
- **profile_injection.dart**: Profile-related dependencies
- **balance_injection.dart**: Balance-related dependencies

## Features

- User authentication (login, register, profile management)
- Transaction management (add, edit, delete transactions)
- Balance tracking and statistics
- Modern UI with dark theme

## Technologies

- Flutter
- Bloc for state management
- Get_it for dependency injection
- Sqflite for local database
- Equatable for value equality 