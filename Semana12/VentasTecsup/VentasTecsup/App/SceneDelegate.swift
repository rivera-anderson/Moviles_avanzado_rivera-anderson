import UIKit

/// Maneja la ventana. Al arrancar muestra la escena inicial de Main.storyboard (el login).
/// Cuando cambia la sesión, mostramos el login o el UITabBarController del rol.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.tintColor = .marca
        // Escena inicial de Main.storyboard (la flecha "Is Initial View Controller"): el login
        window.rootViewController = Pantallas.storyboard.instantiateInitialViewController()
        window.makeKeyAndVisible()
        self.window = window

        // Cuando alguien inicia o cierra sesión, cambiamos la pantalla raíz
        NotificationCenter.default.addObserver(self, selector: #selector(sesionCambio),
                                               name: .sesionCambio, object: nil)
    }

    @objc private func sesionCambio() {
        guard let window else { return }
        if let usuario = Sesion.shared.usuario {
            // Storyboard IDs: "TabsSupervisor" o "TabsVendedor" (las pestañas dependen del rol)
            window.rootViewController = Pantallas.pestanas(para: usuario)
        } else {
            window.rootViewController = Pantallas.acceso()
        }
        UIView.transition(with: window, duration: 0.35, options: .transitionCrossDissolve, animations: nil)
    }
}
