import SwiftUI
import SwiftData
import Foundation

/// B9 · Resumen del supervisor
/// Todo se calcula con consultas a la base: nada de esto se guarda aparte.
struct ResumenView: View {
    @Query private var productos: [Producto]
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(filter: #Predicate<Compra> { $0.estado == "Aprobada" }) private var aprobadas: [Compra]
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }) private var pendientes: [Compra]

    // ② Valor del inventario = Σ stock × costo promedio
    private var inventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }

    // ③ Crédito fiscal = Σ IGV de las compras aprobadas
    private var creditoFiscal: Double { aprobadas.reduce(0) { $0 + $1.igv } }

    // Por pagar = Σ total de aprobadas a crédito y no pagadas
    private var porPagar: Double {
        aprobadas.filter { $0.estaPorPagar }.reduce(0) { $0 + $1.total }
    }

    // ④ Compras por aprobar (cantidad e importe)
    private var importePorAprobar: Double { pendientes.reduce(0) { $0 + $1.total } }

    // ⑤ Total comprado por proveedor (de mayor a menor)
    private var proveedoresConCompras: [Proveedor] {
        proveedores
            .filter { $0.totalComprado > 0 }
            .sorted { $0.totalComprado > $1.totalComprado }
    }
    private var maximoProveedor: Double { proveedoresConCompras.first?.totalComprado ?? 0 }

    private let columnas = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                LazyVGrid(columns: columnas, spacing: 12) {
                    TarjetaIndicador(titulo: "Inventario", valor: Formato.soles(inventario))
                    TarjetaIndicador(titulo: "Crédito fiscal", valor: Formato.soles(creditoFiscal),
                                     detalle: "IGV de compras aprobadas")
                    TarjetaIndicador(titulo: "Por pagar", valor: Formato.soles(porPagar))
                    TarjetaIndicador(titulo: "Por aprobar", valor: "\(pendientes.count)",
                                     detalle: Formato.soles(importePorAprobar), colorDetalle: .ambar)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Total comprado por proveedor")
                        .font(.subheadline.weight(.semibold))
                    if proveedoresConCompras.isEmpty {
                        Text("Todavía no hay compras aprobadas.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    ForEach(proveedoresConCompras) { proveedor in
                        BarraProveedor(nombre: proveedor.nombre,
                                       total: proveedor.totalComprado,
                                       maximo: maximoProveedor)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.fondoTarjeta))
            }
            .padding()
        }
        .background(Color.fondoAgrupado)
        .navigationTitle("Resumen")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AvatarMenu() // ① Avatar de la sesión
            }
        }
    }
}

/// Nombre del proveedor, su total y una barra proporcional al mayor
struct BarraProveedor: View {
    let nombre: String
    let total: Double
    let maximo: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(nombre)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text("· \(Formato.soles(total))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.secondary.opacity(0.15))
                    Capsule()
                        .fill(Color.marca)
                        .frame(width: maximo > 0 ? geo.size.width * (total / maximo) : 0)
                }
            }
            .frame(height: 8)
        }
    }
}
