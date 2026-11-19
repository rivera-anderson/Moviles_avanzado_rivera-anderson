import Foundation

extension Notification.Name {
    /// Se envía cada vez que alguien inicia o cierra sesión
    static let sesionCambio = Notification.Name("sesionCambio")
}

/// Sesión de la app: recuerda al usuario conectado mientras la app está abierta.
/// Es un único objeto compartido (static let shared).
final class Sesion {
    static let shared = Sesion()
    private init() {}

    private(set) var usuario: Usuario? {
        didSet {
            // El SceneDelegate escucha este aviso y cambia entre login y pestañas
            NotificationCenter.default.post(name: .sesionCambio, object: nil)
        }
    }

    var esSupervisor: Bool { usuario?.esSupervisor ?? false }

    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
    }

    /// Cerrar sesión: basta poner el usuario en nil y la app vuelve al login
    func cerrar() {
        usuario = nil
    }
}
