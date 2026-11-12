import Foundation
import SwiftData

/// Filtros del segmented de "Mis compras" (B6)
enum FiltroMisCompras: String, CaseIterable, Identifiable {
    case todas = "Todas"
    case pendientes = "Pendientes"
    case rechazadas = "Rechazadas"
    var id: String { rawValue }
}

/// Filtros del segmented de "Por pagar" (B8)
enum FiltroPorPagar: String, CaseIterable, Identifiable {
    case pendientes = "Pendientes"
    case vencidas = "Vencidas"
    case pagadas = "Pagadas"
    var id: String { rawValue }
}

/// Reglas de negocio del caso Compras. Son funciones puras: reciben números y devuelven números,
/// por eso se pueden comprobar a mano con los casos de prueba del expediente.
enum ReglasCompra {
    static let tasaIGV = 0.18
    static let limiteAprobacion = 5000.0 // Desde este total la compra queda Pendiente
    static let diasCredito = 30

    /// Redondea a 2 decimales (céntimos)
    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    /// Subtotal = cantidad × costo unitario
    static func subtotal(cantidad: Int, costoUnitario: Double) -> Double {
        redondear(Double(cantidad) * costoUnitario)
    }

    /// IGV = 18 % del subtotal. En compras es crédito fiscal.
    static func igv(de subtotal: Double) -> Double {
        redondear(subtotal * tasaIGV)
    }

    /// Una compra con total desde S/ 5,000 necesita aprobación del supervisor
    static func requiereAprobacion(total: Double) -> Bool {
        total >= limiteAprobacion
    }

    /// Crédito: vence 30 días después de la fecha de compra
    static func fechaVencimiento(desde fecha: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: diasCredito, to: fecha) ?? fecha
    }

    /// Costo promedio ponderado (se aplica al aprobar):
    /// nuevo = (stock actual × costo promedio + cantidad × costo unitario) / (stock actual + cantidad)
    /// Ejemplo: (40 × 110 + 50 × 120) / 90 = 115.56
    static func nuevoCostoPromedio(stockActual: Int, costoActual: Double,
                                   cantidad: Int, costoUnitario: Double) -> Double {
        let unidades = stockActual + cantidad
        guard unidades > 0 else { return costoUnitario }
        let valorActual = Double(stockActual) * costoActual
        let valorCompra = Double(cantidad) * costoUnitario
        return (valorActual + valorCompra) / Double(unidades)
    }

    // MARK: - Consultas con #Predicate
    // Regla de #Predicate: los valores de afuera se guardan primero en un let.

    /// Ver solo lo propio: compras del comprador de la sesión, filtradas por estado
    static func predicadoMisCompras(usuario: String, filtro: FiltroMisCompras) -> Predicate<Compra> {
        let nombreUsuario = usuario
        switch filtro {
        case .todas:
            return #Predicate<Compra> { compra in
                compra.comprador?.usuario == nombreUsuario
            }
        case .pendientes:
            let pendiente = EstadoCompra.pendiente
            return #Predicate<Compra> { compra in
                compra.comprador?.usuario == nombreUsuario && compra.estado == pendiente
            }
        case .rechazadas:
            let rechazada = EstadoCompra.rechazada
            return #Predicate<Compra> { compra in
                compra.comprador?.usuario == nombreUsuario && compra.estado == rechazada
            }
        }
    }

    /// Cuentas por pagar: solo compras aprobadas a crédito. Vencidas compara la fecha con hoy.
    static func predicadoPorPagar(filtro: FiltroPorPagar, hoy: Date) -> Predicate<Compra> {
        let aprobada = EstadoCompra.aprobada
        let ahora = hoy
        switch filtro {
        case .pendientes: // Todas las que faltan pagar (incluye las vencidas)
            return #Predicate<Compra> { compra in
                compra.estado == aprobada && compra.alCredito && !compra.pagada
            }
        case .vencidas: // Faltan pagar y la fecha de vencimiento ya pasó
            return #Predicate<Compra> { compra in
                compra.estado == aprobada && compra.alCredito && !compra.pagada && compra.vence < ahora
            }
        case .pagadas:
            return #Predicate<Compra> { compra in
                compra.estado == aprobada && compra.alCredito && compra.pagada
            }
        }
    }
}
