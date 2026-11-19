import UIKit

/// Punto de entrada de la app (UIKit, sin storyboard)
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = CoreDataStack.shared // Abre la base de datos SQLite al iniciar
        return true
    }

    /// Le decimos a iOS qué clase maneja la ventana
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuracion = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        configuracion.delegateClass = SceneDelegate.self
        return configuracion
    }
}
