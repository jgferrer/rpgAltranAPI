import Foundation
import Vapor
import Fluent

struct gnomeCount: Codable {
    var gnomeId: Int
    var count: Int
}
extension gnomeCount: Content { }

struct CommentController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let commentsRoutes = router.grouped("api", "comments") 

        /// Returns a list of all `Comment`s.
        /* api/comments/all */
        func getAll(_ req: Request) throws -> Future<[Comment]> {
            let user = try req.requireAuthenticated(User.self)
            return try user.authTokens.query(on: req).first().flatMap(to: [Comment].self) { userTokenType in
                guard (userTokenType?.token) != nil else { throw Abort.init(HTTPResponseStatus.notFound) }
                return Comment.query(on: req).all()
            }
        }
        
        // Returns count of Comments of gnomeId
        /* api/comments/count?gnomeId=1 */
        func count(_ req: Request) throws -> Future<gnomeCount> {
            guard
                let searchTerm = req.query[Int.self, at: "gnomeId"] else {
                    throw Abort(.badRequest)
            }
            
            return try Comment.query(on: req)
                .filter(\Comment.gnomeId == searchTerm)
                .count().map(to: gnomeCount.self) { cuenta in
                    return gnomeCount.init(gnomeId: searchTerm, count: cuenta)
            }
        }
        
        /// Returns all Comments of gnomeId.
        /*  api/comments?gnomeId=1  */
        func readGnomeId(_ req: Request) throws -> Future<[Comment]> {
            guard
                let searchTerm = req.query[Int.self, at: "gnomeId"] else {
                    throw Abort(.badRequest)
            }
            return try Comment.query(on: req)
                .filter(\Comment.gnomeId == searchTerm)
                .all()
        }
        
        /// Returns one Comment by CommentId.
        /*  api/comments/1 */
        func read(_ req: Request) throws -> Future<Comment> {
            return try req.parameters.next(Comment.self)
        }
        
        
        /// Saves a decoded `Comment` to the database.
        func create(_ req: Request) throws -> Future<Comment> {
            let user = try req.requireAuthenticated(User.self)
            return try user.authTokens.query(on: req).first().flatMap(to: Comment.self) { userTokenType in
                guard (userTokenType?.token) != nil else { throw Abort.init(HTTPResponseStatus.notFound) }
                
                return try req.content.decode(Comment.self).flatMap { comment in
                    return comment.save(on: req)
                }
            }
        }
        
        /// Deletes a parameterized `Comment`.
        func delete(_ req: Request) throws -> Future<HTTPStatus> {
            let user = try req.requireAuthenticated(User.self)
            return try user.authTokens.query(on: req).first().flatMap(to: HTTPStatus.self) { userTokenType in
                guard (userTokenType?.token) != nil else { throw Abort.init(HTTPResponseStatus.notFound) }
                
                return try req.parameters.next(Comment.self).flatMap { comment in
                    return comment.delete(on: req)
                    }.transform(to: HTTPStatus.noContent)
            }
        }
        
        
        // Require Authorization Routes
        let tokenAuthenticationMiddleware = User.tokenAuthMiddleware()
        let authedRoutes = router.grouped(tokenAuthenticationMiddleware).grouped("api/comments")
        authedRoutes.get("all", use: getAll)
        authedRoutes.post(use: create)
        authedRoutes.delete(Comment.parameter, use: delete)
        
        // No Authorization Routes
        commentsRoutes.get(use: readGnomeId)                /* api/comments?gnomeId=1 */
        commentsRoutes.get("count", use: count)             /* api/comments/count?gnomeId=1 */
        commentsRoutes.get(Comment.parameter, use: read)    /* api/comments/1 */
    }
}
