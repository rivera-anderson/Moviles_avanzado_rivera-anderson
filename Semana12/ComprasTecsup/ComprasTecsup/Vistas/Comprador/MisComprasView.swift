import SwiftUI
import SwiftData
import Foundation

/// B6 · Mis compras (solo comprador)
struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion
    @State private var filtro: FiltroMisCompras = .todas

    var body: some View {
        VStack(spacing: 0) {
            // ① Segmented Todas / Pendientes / Rechazadas
            Picker("Filtro", selection: $filtro) {
                ForEach(FiltroMisCompras.allCases) { opcion in
                    Text(opcion.rawValue).tag(opcion)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 8)

            ListaMisCompras(usuario: sesion.usuario?.usuario ?? "", filtro: filtro)
        }
        .background(Color.fondoAgrupado)
        .navigationTitle("Mis compras")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AvatarMenu()
            }
        }
    }
}

/// Lista con @Query dinámico: el #Predicate filtra por el comprador de la sesión
/// (④ el comprador solo ve las suyas) y por el estado elegido en el segmented.
private struct ListaMisCompras: View {
    @Query private var compras: [Compra]

    init(usuario: String, filtro: FiltroMisCompras) {
        _compras = Query(
            filter: ReglasCompra.predicadoMisCompras(usuario: usuario, filtro: filtro),
            sort: [SortDescriptor(\Compra.fecha, order: .reverse)]
        )
    }

    var body: some View {
        List {
            Section {
                ForEach(compras) { compra in
                    FilaCompra(compra: compra) // ② Pendiente · ③ Rechazada con su motivo
                }
            } footer: {
                if !compras.isEmpty {
                    Text("El comprador solo ve sus compras; no puede pagar ni aprobar.")
                }
            }
        }
        .overlay {
            if compras.isEmpty {
                ContentUnavailableView(
                    "Sin compras",
                    systemImage: "cart",
                    description: Text("Las compras que registres en la pestaña Compra aparecerán aquí.")
                )
            }
        }
    }
}

/// Fila de compra: ícono de estado, proveedor, producto × cantidad, total y estado
struct FilaCompra: View {
    let compra: Compra

    private var condicionPago: String {
        compra.alCredito ? "Crédito · vence \(Formato.diaMes(compra.vence))" : "Contado"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            IconoEstado(estado: compra.estado)
            VStack(alignment: .leading, spacing: 2) {
                Text(compra.proveedor?.nombre ?? "Proveedor")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text("\(compra.producto?.nombre ?? "Producto") × \(compra.cantidad) · \(Formato.diaMes(compra.fecha))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(condicionPago)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                if compra.estado == EstadoCompra.rechazada, let motivo = compra.motivoRechazo {
                    Text("Motivo: \(motivo)")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(Formato.soles(compra.total))
                    .font(.subheadline.weight(.semibold))
                Insignia(texto: compra.estado, color: Formato.colorEstado(compra.estado))
            }
        }
    }
}
