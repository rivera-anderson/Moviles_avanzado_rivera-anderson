import CoreData

/// Catálogo de prueba para el supervisor. Deja listos los productos de los casos de prueba
/// (Laptop S/ 200 con stock 40, Mouse S/ 35) y un cliente de cada categoría.
enum DatosEjemplo {
    private static var contexto: NSManagedObjectContext { CoreDataStack.shared.contexto }

    static func cargar(registradoPor usuario: Usuario) {
        _ = producto("Laptop", "Cómputo", precio: 200, stock: 40)
        _ = producto("Mouse", "Accesorios", precio: 35, stock: 60)
        let teclado = producto("Teclado mecánico", "Accesorios", precio: 120, stock: 12)
        let monitor = producto("Monitor 27 pulgadas", "Monitores", precio: 950, stock: 9)
        let servidor = producto("Servidor rack", "Cómputo", precio: 6000, stock: 6)
        _ = producto("Audífonos", "Accesorios", precio: 80, stock: 4)

        let andina = cliente("Corporación Andina SAC", "20512345678")
        let colegio = cliente("Colegio San Martín", "20498765432")
        let maria = cliente("María López", "45678912")

        // Historial: deja a Andina como VIP, al colegio como Frecuente y a María como Regular
        ventaPasada(servidor, andina, cantidad: 1, haceDias: 3, vendedor: usuario)  // 7,080.00
        ventaPasada(monitor, colegio, cantidad: 1, haceDias: 5, vendedor: usuario)  // 1,121.00
        ventaPasada(teclado, maria, cantidad: 2, haceDias: 1, vendedor: usuario)    //   283.20
        ventaPasada(teclado, colegio, cantidad: 1, haceDias: 2, vendedor: usuario)
        ventaPasada(monitor, andina, cantidad: 1, haceDias: 6, vendedor: usuario)
        ventaPasada(teclado, andina, cantidad: 2, haceDias: 4, vendedor: usuario)

        try? CoreDataStack.shared.guardar()
    }

    private static func producto(_ nombre: String, _ categoria: String, precio: Double, stock: Int64) -> Producto {
        let producto = Producto(context: contexto)
        producto.nombre = nombre
        producto.categoria = categoria
        producto.precio = precio
        producto.stock = stock
        return producto
    }

    private static func cliente(_ nombre: String, _ documento: String) -> Cliente {
        let cliente = Cliente(context: contexto)
        cliente.nombre = nombre
        cliente.documento = documento
        return cliente
    }

    private static func ventaPasada(_ producto: Producto, _ cliente: Cliente, cantidad: Int,
                                    haceDias: Int, vendedor: Usuario) {
        let resumen = ReglasVenta.calcular(cantidad: cantidad, precioUnitario: producto.precio,
                                           categoria: cliente.categoria)
        let venta = Venta(context: contexto)
        venta.fecha = Calendar.current.date(byAdding: .day, value: -haceDias, to: Date())
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = resumen.descuento
        venta.igv = resumen.igv
        venta.total = resumen.total
        venta.vendedor = vendedor
        venta.producto = producto
        venta.cliente = cliente
        producto.stock -= Int64(cantidad)
    }
}
