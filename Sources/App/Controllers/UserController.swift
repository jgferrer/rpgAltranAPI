import Foundation
import Vapor
import Fluent
import FluentSQLite
import Crypto

class UserController: RouteCollection {
    func boot(router: Router) throws {
        let group = router.grouped("api", "users")
        group.post("createUser", use: createUser)
        group.post("loginUser", use: loginUser)
    }
}

private extension UserController {

    func createUser(_ request: Request) throws -> Future<User.PublicUser> {

            return try request.content.decode(User.self).flatMap(to: User.PublicUser.self) { user in

                user.username = user.username.fromBase64()!
                user.password = user.password.fromBase64()!
                
                return User.query(on: request).filter(\.username == user.username).first().flatMap { existingUser in
                    guard existingUser == nil else {
                        throw Abort(.badRequest, reason: "a user with this username already exists!" , identifier: nil)
                    }

                let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
                let newUser = User(username: user.username, password: passwordHashed)
                return newUser.save(on: request).flatMap(to: User.PublicUser.self) { createdUser in
                    let accessToken = try Token.createToken(forUser: createdUser)
                    return accessToken.save(on: request).map(to: User.PublicUser.self) { createdToken in
                        let publicUser = User.PublicUser(username: createdUser.username, token: createdToken.token)
                        return publicUser
                    }
                }
            }
        }
    }

    func loginUser(_ request: Request) throws -> Future<User.PublicUser> {
        return try request.content.decode(User.self).flatMap(to: User.PublicUser.self) { user in
            
            user.username = user.username.fromBase64()!
            user.password = user.password.fromBase64()!
            
            let passwordVerifier = try request.make(BCryptDigest.self)

            return User.authenticate(username: user.username, password: user.password, using: passwordVerifier, on: request)
                .unwrap(or: Abort.init(HTTPResponseStatus.unauthorized)).flatMap(to: User.PublicUser.self) { user in
                    let accessToken = try Token.createToken(forUser: user)

                    // Eliminar tokens anteriores del usuario
                    _ = Token.query(on: request)
                        .filter(\Token.userId == user.id!)
                        .delete()
                    
                    return accessToken.save(on: request).map(to: User.PublicUser.self) { createdToken in
                        let publicUser = User.PublicUser(username: user.username, token: createdToken.token)
                        return publicUser
                    }
                }
            }
        }
    }

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
