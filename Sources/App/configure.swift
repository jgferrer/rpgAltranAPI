import FluentPostgreSQL
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // PostgresSQL Database Configuration
    var databases = DatabasesConfig()
    
    let postgresConfig = PostgreSQLDatabaseConfig(
        hostname: globalVariables.POSTGRESQL_HOSTNAME,
        port:     globalVariables.POSTGRESQL_PORT,
        username: globalVariables.POSTGRESQL_USERNAME,
        database: globalVariables.POSTGRESQL_USERNAME,
        password: globalVariables.POSTGRESQL_PASSWORD)
    
    let postgres = PostgreSQLDatabase(config: postgresConfig)
    databases.add(database: postgres, as: .psql)
    services.register(databases)

    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Comment.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)

    services.register(migrations)

}
