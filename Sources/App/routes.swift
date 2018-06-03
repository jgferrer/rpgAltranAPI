import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // ------------------- //
    // Comments Controller //
    /* /api/comments       */
    // -------------------
    let commentController = CommentController()
    try router.register(collection: commentController)
    /* ------------------- */
    
    // ------------------- //
    //   Users Controller  //
    /*   /api/users        */
    // -------------------
    let userRouteController = UserController()
    try userRouteController.boot(router: router)
    /* ------------------- */
    
    let jsonGnomes = json()
    try router.register(collection: jsonGnomes)

}
