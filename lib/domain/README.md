# Domain Layer

The domain layer is the core of the application. It contains business entities, use case definitions, and repository interfaces. This layer is completely independent of the data layer, framework, or UI.

## Structure

- **entities/**: Core business objects, free from any framework or dependency
- **repositories/**: Abstract repository interfaces that define operations without implementations
- **usecases/**: Single-responsibility classes that encapsulate business logic 