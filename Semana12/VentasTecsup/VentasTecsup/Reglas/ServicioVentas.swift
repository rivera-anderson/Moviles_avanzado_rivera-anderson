import CoreData

/// Errores con mensaje listo para mostrar en una alerta
enum ErrorVenta: LocalizedError {
    case datosIncompletos
    case cantidadInvalida
    case stockInsuficiente(pedido: Int, disponible: Int64)
    case motivoVacio
    case yaAnulada
    case tieneVentas

    var errorDescription: String? {
        switch self {
        case .datosIncompletos:
            return "Elige un cliente y un producto."
        case .cantidadInvalida:
            return "La cantidad debe ser mayor a cero."
        case .stockInsuficiente(let pedido, let disponible):
            return "Pediste \(pedido) u. y solo hay \(disponible) u. en stock. La venta no se registró."
        case .motivoVacio:
            return "Para anular una venta hay que escribir un motivo."
        case .yaAnulada:
            return "Esta venta ya estaba anulada."
        case .tieneVentas:
            return "Tiene ventas registradas. La regla de borrado Deny lo impide."
        }
    }
}

/// Operaciones que cambian datos. Cada una termina con save() para que llegue al SQLite.
enum ServicioVentas {
    private static var contexto: NSManagedObjectContext { CoreDataStack.shared.contexto }

    /// Registra una venta: calcula descuento e IGV, baja el stock y guarda quién la registró
    @discardableResult
    static func registrar(cantidad: Int, producto: Producto?, cliente: Cliente?, vendedor: Usuario?) throws -> Venta {
        guard let producto, let cliente, let vendedor else { throw ErrorVenta.datosIncompletos }
        guard cantidad > 0 else { throw ErrorVenta.cantidadInvalida }
        // Regla de stock: si la cantidad supera el stock, no se registra
        guard Int64(cantidad) <= producto.stock else {
            throw ErrorVenta.stockInsuficiente(pedido: cantidad, disponible: producto.stock)
        }

        // La categoría se calcula con lo comprado ANTES de esta venta
        let resumen = ReglasVenta.calcular(cantidad: cantidad, precioUnitario: producto.precio,
                                           categoria: cliente.categoria)

        let venta = Venta(context: contexto)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = resumen.descuento
        venta.igv = resumen.igv
        venta.total = resumen.total
        venta.anulada = false

        // Relaciones To One: Core Data completa el lado inverso (ventas) solo
        venta.vendedor = vendedor
        venta.producto = producto
        venta.cliente = cliente

        producto.stock -= Int64(cantidad) // Baja el stock

        try guardarODeshacer()
        return venta
    }

    /// Anular (solo supervisor): exige motivo, marca la venta y devuelve el stock
    static func anular(_ venta: Venta, motivo: String) throws {
        let texto = motivo.limpio
        guard !texto.isEmpty else { throw ErrorVenta.motivoVacio }
        guard !venta.anulada else { throw ErrorVenta.yaAnulada }

        venta.anulada = true
        venta.motivoAnulacion = texto
        venta.producto?.stock += venta.cantidad // Devuelve el stock

        try guardarODeshacer()
    }

    /// Borrar producto, cliente o usuario. Si tiene ventas, Core Data rechaza el save (Deny).
    static func borrar(_ objeto: NSManagedObject) throws {
        contexto.delete(objeto)
        do {
            try CoreDataStack.shared.guardar()
        } catch {
            contexto.rollback()
            throw ErrorVenta.tieneVentas
        }
    }

    private static func guardarODeshacer() throws {
        do {
            try CoreDataStack.shared.guardar()
        } catch {
            contexto.rollback()
            throw error
        }
    }
}
