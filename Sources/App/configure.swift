import Leaf
import Vapor
import VHX

// configures your application
public func configure(_ app: Application) async throws {
    let fileManager = FileManager.default
    
    // check the Environment - use Resources/Views on Docker (Vapor Standard)
    let isDocker = fileManager.fileExists(atPath: "/.dockerenv")
    let viewsPath: String
    
    // On Docker, use default path from Vapor and on development, use custom path
    if isDocker {
        viewsPath = "\(app.directory.workingDirectory)/Resources/Views"
    } else {
        viewsPath = "\(app.directory.workingDirectory)/Sources/App/Views"
    }
    
    // register Public directory for static files
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // register Leaf
    app.leaf.configuration.rootDirectory = viewsPath
    app.views.use(.leaf)
    
    // register Htmx
    let hxConfig = HtmxConfiguration.basic()
    try configureHtmx(app, configuration: hxConfig)

    // register routes
    try routes(app)
}
