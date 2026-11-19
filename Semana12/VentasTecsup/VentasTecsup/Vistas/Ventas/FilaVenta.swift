import UIKit

extension FilaCell {
    /// Fila de "Mis ventas": ✓ verde o ✕ rojo, cliente, "03/11 · Laptop × 2" y total.
    /// Anulada: gris, monto tachado y etiqueta "Anulada".
    func mostrarPropia(_ venta: Venta) {
        let producto = venta.producto?.nombre ?? "Producto"
        configurar(icono: venta.anulada
                       ? .simbolo("xmark", fondo: UIColor.systemRed.withAlphaComponent(0.55))
                       : .simbolo("checkmark", fondo: .systemGreen),
                   titulo: venta.cliente?.nombre ?? "Cliente",
                   subtitulo: "\(Formato.fechaCorta(venta.fecha)) · \(producto) × \(venta.cantidad)",
                   valor: Formato.soles(venta.total),
                   insigniaAbajo: venta.anulada ? ("Anulada", .systemRed) : nil,
                   tachado: venta.anulada)
    }

    /// Fila de "Ventas del equipo": iniciales del cliente y "Carlos · Laptop × 2"
    /// (el nombre del vendedor sale de la relación venta ▸ vendedor)
    func mostrarDelEquipo(_ venta: Venta) {
        let cliente = venta.cliente?.nombre ?? "Cliente"
        let producto = venta.producto?.nombre ?? "Producto"
        let vendedor = venta.vendedor?.primerNombre ?? "—"
        configurar(icono: .iniciales(cliente),
                   titulo: cliente,
                   subtitulo: "\(vendedor) · \(producto) × \(venta.cantidad)",
                   detalle: venta.anulada ? "Motivo: \(venta.motivoAnulacion ?? "—")" : nil,
                   valor: Formato.soles(venta.total),
                   insigniaAbajo: venta.anulada ? ("Anulada", .systemRed) : nil,
                   tachado: venta.anulada)
    }
}
