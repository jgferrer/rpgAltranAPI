import Vapor
import Fluent

struct CommentController: RouteCollection {
    func boot(router: Router) throws {
        
        let commentsRoutes = router.grouped("api", "comments") 

        /// Returns a list of all `Comment`s.
        /* api/comments/all */
        func getAll(_ req: Request) throws -> Future<[Comment]> {
            return Comment.query(on: req).all()
        }
        
        // Returns count of Comments of gnomeId
        /* api/comments/count?gnomeId=1 */
        func count(_ req: Request) throws -> Future<Int> {
            guard
                let searchTerm = req.query[Int.self, at: "gnomeId"] else {
                    throw Abort(.badRequest)
            }
            return try Comment.query(on: req)
                .filter(\Comment.gnomeId == searchTerm)
                .count()
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
        
        /*
        func create(_ req: Request, comment: Comment) throws -> Future<Comment> {
            return comment.save(on: req)
        }
        */
        
        /// Saves a decoded `Comment` to the database.
        func create(_ req: Request) throws -> Future<Comment> {
            return try req.content.decode(Comment.self).flatMap { comment in
                return comment.save(on: req)
            }
        }
        
        /// Deletes a parameterized `Comment`.
        func delete(_ req: Request) throws -> Future<HTTPStatus> {
            return try req.parameters.next(Comment.self).flatMap { comment in
                return comment.delete(on: req)
                }.transform(to: HTTPStatus.noContent)
        }
        
        commentsRoutes.get("all", use: getAll)              /* api/comments/all */
        commentsRoutes.get(use: readGnomeId)                /* api/comments?gnomeId=1 */
        commentsRoutes.get("count", use: count)             /* api/comments/count?gnomeId=1 */
        commentsRoutes.get(Comment.parameter, use: read)    /* api/comments/1 */
        //commentsRoutes.post(Comment.self, use: create)
        commentsRoutes.post(use: create)
        commentsRoutes.delete(Comment.parameter, use: delete)
    }
}
