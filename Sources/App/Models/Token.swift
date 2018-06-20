import Foundation
import Vapor
import FluentSQLite
import Authentication

final class Token: SQLiteModel {
    var id: Int?
    var token: String
    var userId: User.ID
    
    init(token: String, userId: User.ID) {
        self.token = token
        self.userId = userId
    }
    
    static func createToken(forUser user: User) throws -> Token {
        // let tokenString = Helpers.randomToken(withLength: 30)
        let random = try CryptoRandom().generateData(count: 25)
        
        let newToken = try Token(token: random.base64EncodedString(),
                                 userId: user.requireID())
        return newToken
    }
}
extension Token: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<Token, String> { return \Token.token }
}

extension Token {
    var user: Parent<Token, User> {
        return parent(\.userId)
    }
}

extension Token: Authentication.Token {
    static var userIDKey: WritableKeyPath<Token, User.ID> { return \Token.userId }
    typealias UserType = User
    typealias UserIDType = User.ID
}

extension Token: Content { }
extension Token: Migration { }
