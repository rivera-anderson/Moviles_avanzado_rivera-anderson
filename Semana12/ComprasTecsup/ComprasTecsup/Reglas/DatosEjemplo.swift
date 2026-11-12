import Foundation
import SwiftData

/// Catálogo inicial para probar rápido (solo lo puede cargar el supervisor desde Productos vacío).
/// No crea usuarios ni compras: esos se registran desde la app para probar los flujos.
enum DatosEjemplo {
    static func cargarCatalogo(en contexto: ModelContext) {
        let productos = [
            // Caso de prueba 3: producto con stock 40 y costo promedio 110.00
            Producto(nombre: "Laptop Pro 14", categoria: "Laptops", stock: 40, costoPromedio: 110.00),
            Producto(nombre: "Monitor 24\"", categoria: "Monitores", stock: 9, costoPromedio: 300.00),
            Producto(nombre: "Mouse inalámbrico", categoria: "Accesorios", stock: 120, costoPromedio: 18.50),
            Producto(nombre: "Teclado mecánico", categoria: "Accesorios", stock: 4, costoPromedio: 80.00)
        ]
        let proveedores = [
            Proveedor(nombre: "Distribuidora Lima SAC", ruc: "20100000011"),
            Proveedor(nombre: "TecnoImport EIRL", ruc: "20100000012"),
            Proveedor(nombre: "Mayorista Sur SAC", ruc: "20100000013")
        ]
        for producto in productos { contexto.insert(producto) }
        for proveedor in proveedores { contexto.insert(proveedor) }
        try? contexto.save()
    }
}
