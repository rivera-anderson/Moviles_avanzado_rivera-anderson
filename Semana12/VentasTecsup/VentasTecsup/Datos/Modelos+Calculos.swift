import CoreData

/// Roles posibles. Se guardan como texto en Usuario.rol
enum Rol {
    static let vendedor = "Vendedor"
    static let supervisor = "Supervisor"
    static let todos = [vendedor, supervisor]
}

// Las clases Usuario, Producto, Cliente y Venta las genera Xcode desde Ventas.xcdatamodeld
// (Codegen: Class Definition). Aquí solo agregamos valores calculados que NO se guardan.

extension Usuario {
    var esSupervisor: Bool { rol == Rol.supervisor }
    var nombreMostrado: String { nombre ?? "" }
    var primerNombre: String { String(nombreMostrado.split(separator: " ").first ?? "") }
    var cantidadVentas: Int { ventas?.count ?? 0 }
}

extension Producto {
    var cantidadVentas: Int { ventas?.count ?? 0 }
}

extension Cliente {
    /// Ventas que cuentan: las no anuladas (relación cliente ▸ ventas)
    var ventasValidas: [Venta] {
        let todas = (ventas as? Set<Venta>) ?? []
        return todas.filter { !$0.anulada }
    }

    /// Lo comprado por el cliente = suma del total de sus ventas no anuladas
    var totalComprado: Double {
        ventasValidas.reduce(0) { $0 + $1.total }
    }

    /// Categoría calculada (no se guarda): Regular, Frecuente o VIP
    var categoria: CategoriaCliente {
        CategoriaCliente(totalComprado: totalComprado)
    }

    var cantidadVentas: Int { ventas?.count ?? 0 }
}

extension Venta {
    var subtotal: Double {
        ReglasVenta.redondear(Double(cantidad) * precioUnitario)
    }
}
