import Vapor
import FluentSQLite

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {

    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    
    // Catches errors and converts to HTTP response
    middlewares.use(ErrorMiddleware.self)
    middlewares.use(FileMiddleware.self)
    services.register(middlewares)
    
    try services.register(FluentSQLiteProvider())
    
    let sqlite = try SQLiteDatabase(storage: .file(path: "db7.sqlite"))

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.enableLogging(on: .sqlite)
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    var migrations = MigrationConfig()
    migrations.add(model: Bulletin.self, database: .sqlite)
    services.register(migrations)
}
