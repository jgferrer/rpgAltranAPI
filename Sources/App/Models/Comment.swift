import FluentSQLite
import Vapor

/// A single entry of a Comment.
final class Comment: Codable {
    /// The unique identifier for this `Comment`.
    var id: Int?

    var title: String
    var comment: String
    var userId: String
    var gnomeId: Int

    /// Creates a new `Comment`.
    init(id: Int? = nil, title: String, comment: String, userId: String, gnomeId: Int) {
        self.id = id
        self.title = title
        self.comment = comment
        self.userId = userId
        self.gnomeId = gnomeId
    }
}

extension Comment: SQLiteModel { }

/// Allows `Comment` to be used as a dynamic migration.
extension Comment: Migration { }

/// Allows `Comment` to be encoded to and decoded from HTTP messages.
extension Comment: Content { }

/// Allows `Comment` to be used as a dynamic parameter in route definitions.
extension Comment: Parameter { }
