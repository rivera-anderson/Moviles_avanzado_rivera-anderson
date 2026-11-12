import Foundation
import SwiftData

/// Roles posibles. Se guardan como texto en Usuario.rol
enum Rol {
    static let comprador = "Comprador"
    static let supervisor = "Supervisor"
    static let todos = [comprador, supervisor]
}

@Model
final class Usuario {
    var nombre: String   // Nombre completo
    var usuario: String  // Se guarda en minúsculas: "MTORRES" y "mtorres" son el mismo usuario
    var clave: String    // Práctica: texto plano (en una app real se guarda un hash)
    var rol: String      // "Comprador" o "Supervisor"

    // Un usuario registra muchas compras (lado "muchos").
    // .deny: no se puede borrar un usuario que tenga compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, rol: String) {
        self.nombre = nombre
        self.usuario = usuario.lowercased()
        self.clave = clave
        self.rol = rol
    }

    // Calculado (no se guarda)
    var esSupervisor: Bool { rol == Rol.supervisor }
}
