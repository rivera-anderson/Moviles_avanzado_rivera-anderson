import Foundation
import SwiftData

@Model
final class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    var costoPromedio: Double // Cambia con cada compra aprobada (promedio ponderado)

    // Un producto aparece en muchas compras.
    // .deny: no se puede borrar un producto que tenga compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
    }

    // Calculado (no se guarda): stock × costo promedio
    var valorInventario: Double { Double(stock) * costoPromedio }
}
