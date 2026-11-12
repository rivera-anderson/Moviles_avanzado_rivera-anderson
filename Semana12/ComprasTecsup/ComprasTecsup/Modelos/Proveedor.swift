import Foundation
import SwiftData

@Model
final class Proveedor {
    var nombre: String
    var ruc: String

    // Un proveedor tiene muchas compras.
    // .deny: no se puede borrar un proveedor que tenga compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }

    // MARK: - Valores calculados desde la relación proveedor ▸ compras (no se guardan)

    /// Suma del total de las compras aprobadas a este proveedor
    var totalComprado: Double {
        compras
            .filter { $0.estado == EstadoCompra.aprobada }
            .reduce(0) { $0 + $1.total }
    }

    /// Cuántas compras a crédito siguen sin pagarse
    var cantidadPorPagar: Int {
        compras.filter { $0.estaPorPagar }.count
    }
}
