import Foundation
import SwiftData

/// Estados posibles de una compra. Se guardan como texto en Compra.estado
enum EstadoCompra {
    static let pendiente = "Pendiente"
    static let aprobada = "Aprobada"
    static let rechazada = "Rechazada"
}

@Model
final class Compra {
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double
    var igv: Double        // 18 % del subtotal (crédito fiscal)
    var total: Double      // subtotal + IGV
    var alCredito: Bool    // false = contado, true = crédito 30 días
    var vence: Date        // Crédito: fecha + 30 días. Contado: la misma fecha
    var estado: String     // "Pendiente", "Aprobada" o "Rechazada"
    var pagada: Bool
    var motivoRechazo: String?

    // Lado "uno" de las relaciones. El inverso (usuario.compras, etc.) lo completa SwiftData.
    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    // Las relaciones se asignan después de insertar la compra en el contexto (ver ServicioCompras)
    init(fecha: Date, cantidad: Int, costoUnitario: Double, alCredito: Bool) {
        let subtotal = ReglasCompra.subtotal(cantidad: cantidad, costoUnitario: costoUnitario)
        let igv = ReglasCompra.igv(de: subtotal)

        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.igv = igv
        self.total = ReglasCompra.redondear(subtotal + igv)
        self.alCredito = alCredito
        self.vence = alCredito ? ReglasCompra.fechaVencimiento(desde: fecha) : fecha
        self.estado = EstadoCompra.pendiente // El servicio la aprueba al instante si es menor a S/ 5,000
        self.pagada = false
        self.motivoRechazo = nil
    }

    // MARK: - Calculados (no se guardan)

    var subtotal: Double { ReglasCompra.subtotal(cantidad: cantidad, costoUnitario: costoUnitario) }

    /// Aprobada, a crédito y sin pagar: es una cuenta por pagar
    var estaPorPagar: Bool { estado == EstadoCompra.aprobada && alCredito && !pagada }

    /// Por pagar y con la fecha de vencimiento ya pasada
    var estaVencida: Bool { estaPorPagar && vence < Date() }
}
