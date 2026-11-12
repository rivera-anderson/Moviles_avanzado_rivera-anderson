import Foundation
import SwiftData

/// Errores que el usuario puede ver en una alerta
enum ErrorCompra: LocalizedError {
    case datosInvalidos
    case motivoVacio
    case noEstaPendiente

    var errorDescription: String? {
        switch self {
        case .datosInvalidos: return "Revisa proveedor, producto, cantidad y costo unitario."
        case .motivoVacio: return "Para rechazar una compra hay que escribir un motivo."
        case .noEstaPendiente: return "Esta compra ya no está pendiente de aprobación."
        }
    }
}

/// Operaciones que cambian datos: registrar, aprobar, rechazar y pagar compras.
/// Cada una termina con save() para que el cambio llegue al archivo SQLite de inmediato.
enum ServicioCompras {

    /// Registra una compra del comprador de la sesión.
    /// - Total menor a S/ 5,000: queda Aprobada al instante (cambia stock, costo promedio y cuentas por pagar).
    /// - Total desde S/ 5,000: queda Pendiente y no cambia nada hasta que el supervisor la apruebe.
    @discardableResult
    static func registrar(fecha: Date, cantidad: Int, costoUnitario: Double, alCredito: Bool,
                          comprador: Usuario, proveedor: Proveedor, producto: Producto,
                          en contexto: ModelContext) throws -> Compra {
        guard cantidad > 0, costoUnitario > 0 else { throw ErrorCompra.datosInvalidos }

        let compra = Compra(fecha: fecha, cantidad: cantidad, costoUnitario: costoUnitario, alCredito: alCredito)
        contexto.insert(compra)

        // Relaciones: basta asignar el lado "uno"; SwiftData completa el inverso
        // (usuario.compras, proveedor.compras y producto.compras)
        compra.comprador = comprador
        compra.proveedor = proveedor
        compra.producto = producto

        if !ReglasCompra.requiereAprobacion(total: compra.total) {
            aplicarAprobacion(compra)
        }

        try contexto.save()
        return compra
    }

    /// Supervisor aprueba una compra pendiente: recién ahí se aplican sus efectos
    static func aprobar(_ compra: Compra, en contexto: ModelContext) throws {
        guard compra.estado == EstadoCompra.pendiente else { throw ErrorCompra.noEstaPendiente }
        aplicarAprobacion(compra)
        try contexto.save()
    }

    /// Supervisor rechaza con motivo obligatorio. No cambia stock ni costo promedio.
    static func rechazar(_ compra: Compra, motivo: String, en contexto: ModelContext) throws {
        let texto = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { throw ErrorCompra.motivoVacio }
        guard compra.estado == EstadoCompra.pendiente else { throw ErrorCompra.noEstaPendiente }
        compra.estado = EstadoCompra.rechazada
        compra.motivoRechazo = texto
        try contexto.save()
    }

    /// Supervisor marca como pagada una compra a crédito: sale de Pendientes de pago
    static func pagar(_ compra: Compra, en contexto: ModelContext) throws {
        guard compra.estaPorPagar else { return }
        compra.pagada = true
        try contexto.save()
    }

    /// Efectos de una compra aprobada
    private static func aplicarAprobacion(_ compra: Compra) {
        if let producto = compra.producto {
            // 1) Costo promedio ponderado: se calcula con el stock ANTES de sumar la compra
            producto.costoPromedio = ReglasCompra.nuevoCostoPromedio(
                stockActual: producto.stock,
                costoActual: producto.costoPromedio,
                cantidad: compra.cantidad,
                costoUnitario: compra.costoUnitario
            )
            // 2) Entra la mercadería al stock
            producto.stock += compra.cantidad
        }
        compra.estado = EstadoCompra.aprobada
        // 3) Contado: queda pagada. Crédito: queda como cuenta por pagar (vence a los 30 días)
        compra.pagada = !compra.alCredito
    }
}
