import Foundation
import Observation

/// Sesión de la app: recuerda al usuario conectado mientras la app está abierta.
/// Es @Observable: cuando cambia `usuario`, las vistas que la leen se redibujan solas.
/// Se pone en el entorno con .environment(sesion) en ComprasTecsupApp.
@Observable
final class Sesion {
    var usuario: Usuario?

    var esSupervisor: Bool { usuario?.esSupervisor ?? false }

    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
    }

    /// Cerrar sesión: basta poner el usuario en nil y RaizView vuelve al login sola
    func cerrarSesion() {
        usuario = nil
    }
}
