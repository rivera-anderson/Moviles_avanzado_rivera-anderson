import UIKit

/// Categoría del cliente según lo comprado (ventas no anuladas)
enum CategoriaCliente: String {
    case regular = "Regular"
    case frecuente = "Frecuente"
    case vip = "VIP"

    static let limiteFrecuente = 1000.0
    static let limiteVIP = 5000.0

    /// Regular: menos de S/ 1,000 · Frecuente: desde S/ 1,000 · VIP: desde S/ 5,000
    init(totalComprado: Double) {
        if totalComprado >= CategoriaCliente.limiteVIP {
            self = .vip
        } else if totalComprado >= CategoriaCliente.limiteFrecuente {
            self = .frecuente
        } else {
            self = .regular
        }
    }

    /// VIP: 10 % del subtotal. Los demás: 0 %
    var porcentajeDescuento: Double { self == .vip ? 0.10 : 0 }

    var color: UIColor {
        switch self {
        case .regular: return .systemGray
        case .frecuente: return .systemBlue
        case .vip: return .systemPurple
        }
    }
}

/// Montos calculados de una venta
struct ResumenVenta {
    let subtotal: Double
    let descuento: Double
    let igv: Double
    let total: Double

    static let cero = ResumenVenta(subtotal: 0, descuento: 0, igv: 0, total: 0)
}

/// Reglas de negocio puras (sin pantallas ni base de datos): fáciles de probar y explicar
enum ReglasVenta {
    static let tasaIGV = 0.18
    static let limiteStockBajo: Int64 = 5

    /// Redondea a 2 decimales (céntimos)
    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    /// Subtotal = cantidad × precio
    /// Descuento = subtotal × % de la categoría
    /// IGV = 18 % de (subtotal − descuento)
    /// Total = subtotal − descuento + IGV
    /// Ejemplo VIP: 2 × 200 = 400 · desc. 40 · IGV 64.80 · total 424.80
    static func calcular(cantidad: Int, precioUnitario: Double, categoria: CategoriaCliente) -> ResumenVenta {
        let subtotal = redondear(Double(cantidad) * precioUnitario)
        let descuento = redondear(subtotal * categoria.porcentajeDescuento)
        let igv = redondear((subtotal - descuento) * tasaIGV)
        let total = redondear(subtotal - descuento + igv)
        return ResumenVenta(subtotal: subtotal, descuento: descuento, igv: igv, total: total)
    }
}
