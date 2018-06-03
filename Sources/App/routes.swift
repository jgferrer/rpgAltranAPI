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

    /*
    let tokenAuthenticationMiddleware = User.tokenAuthMiddleware()
    let authedRoutes = router.grouped(tokenAuthenticationMiddleware)
    authedRoutes.get("this/protected/route") { request -> Future<User.PublicUser> in
        let user = try request.requireAuthenticated(User.self)
        return try user.authTokens.query(on: request).first().map(to: User.PublicUser.self) { userTokenType in
            guard let tokenType = userTokenType?.token else { throw Abort.init(HTTPResponseStatus.notFound) }
            return User.PublicUser(username: user.username, token: tokenType)
        }
    }
    */
}
