# Presentation Layer

The presentation layer handles user interactions and state management. It contains UI components (widgets, pages) and state management logic.

## Structure

- **bloc/**: Contains BLoC (Business Logic Component) or state management classes
  - **auth/**: Authentication state management
  - **balance/**: Balance state management
  - **transaction/**: Transaction state management
  
- **pages/**: Screen/page widgets that serve as complete screens in the app
  - **auth/**: Authentication screens (login, register)
  - **dashboard/**: Dashboard screens and pages
  - **profile/**: Profile-related screens
  - **transaction/**: Transaction-related screens
  
- **widgets/**: Reusable UI components used across multiple pages 