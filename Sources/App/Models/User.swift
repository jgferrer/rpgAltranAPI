import Foundation
import Vapor
import FluentSQLite
import Authentication

extension User: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> { return \User.username }
    static var passwordKey: WritableKeyPath<User, String> { return \User.password }
}

extension User: TokenAuthenticatable { typealias TokenType = Token }

final class User: SQLiteModel {
    var id: Int?
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    struct PublicUser: Content {
        var username: String
        var token: String
    }
}

extension User: Migration { }
extension User: Content { }
extension User: Parameter { }
