import LeafKit
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    let pathToPublic = "\(app.directory.workingDirectory)/Sources/App/Public"
    app.middleware.use(FileMiddleware(publicDirectory: pathToPublic))
    
    let pathToViews = "\(app.directory.workingDirectory)/Sources/App/Views"
    app.logger.info("Configuring Leaf with views directory: \(pathToViews)")
    
    app.leaf.configuration.rootDirectory = pathToViews
    app.views.use(.leaf)
    
    // Log the contents of the views directory
    let fileManager = FileManager.default
    if let files = try? fileManager.contentsOfDirectory(atPath: pathToViews) {
        app.logger.info("Files in views directory: \(files)")
    } else {
        app.logger.error("Failed to read contents of views directory: \(pathToViews)")
    }

    // register routes
    try routes(app)
}
