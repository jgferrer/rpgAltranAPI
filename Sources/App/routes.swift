import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get() { req in
        return "Hello, world!"
    }

    // ------------------- //
    // Comments Controller //
    /* /api/comments       */
    // -------------------
    let commentsController = CommentsController()
    try router.register(collection: commentsController)
    /* ------------------- */
    
    let jsonGnomes = json()
    try router.register(collection: jsonGnomes)

}
