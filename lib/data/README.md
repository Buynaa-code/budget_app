# Data Layer

The data layer is responsible for data retrieval from various sources like databases, APIs, etc. It contains the implementation of repositories defined in the domain layer.

## Structure

- **datasources/**: Contains classes that fetch data from specific sources (local/remote)
- **models/**: Data models that extend domain entities, adding serialization methods
- **repositories/**: Implementations of domain repositories 