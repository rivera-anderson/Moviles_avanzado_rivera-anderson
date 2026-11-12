import SwiftUI
import SwiftData
import Foundation

/// B8 · Por pagar (solo supervisor)
struct PorPagarView: View {
    @State private var filtro: FiltroPorPagar = .pendientes
    @State private var busqueda = ""

    var body: some View {
        VStack(spacing: 0) {
            // ① Segmented Pendientes / Vencidas / Pagadas
            Picker("Filtro", selection: $filtro) {
                ForEach(FiltroPorPagar.allCases) { opcion in
                    Text(opcion.rawValue).tag(opcion)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 8)

            ListaPorPagar(filtro: filtro, busqueda: busqueda)
        }
        .background(Color.fondoAgrupado)
        .searchable(text: $busqueda, prompt: "Buscar proveedor")
        .navigationTitle("Por pagar")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AvatarMenu() // Avatar de la sesión
            }
        }
    }
}

/// Lista con @Query dinámico: el #Predicate del filtro elegido se arma en el init
private struct ListaPorPagar: View {
    @Environment(\.modelContext) private var modelContext

    // Compras del filtro elegido (Pendientes / Vencidas / Pagadas)
    @Query private var compras: [Compra]

    // ⑤ Para el total por pagar: todas las aprobadas a crédito y no pagadas
    @Query(filter: #Predicate<Compra> { $0.estado == "Aprobada" && $0.alCredito && !$0.pagada })
    private var sinPagar: [Compra]

    let filtro: FiltroPorPagar
    let busqueda: String

    @State private var mensajeError: String?

    init(filtro: FiltroPorPagar, busqueda: String) {
        self.filtro = filtro
        self.busqueda = busqueda
        _compras = Query(
            filter: ReglasCompra.predicadoPorPagar(filtro: filtro, hoy: Date()),
            sort: [SortDescriptor(\Compra.vence)]
        )
    }

    /// Búsqueda por proveedor sobre el resultado de la consulta
    private var visibles: [Compra] {
        let texto = busqueda.limpio
        guard !texto.isEmpty else { return compras }
        return compras.filter { ($0.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(texto) }
    }

    private var totalPorPagar: Double {
        sinPagar.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        List {
            Section {
                ForEach(visibles) { compra in
                    FilaPorPagar(compra: compra) // ② Compra a crédito · ③ Etiqueta VENCIDA
                        .swipeActions(edge: .trailing) {
                            // ④ Deslizar Pagar (solo supervisor: esta pestaña solo la tiene el supervisor)
                            if !compra.pagada {
                                Button("Pagar") { pagar(compra) }
                                    .tint(.green)
                            }
                        }
                }
            } footer: {
                if filtro != .pagadas && !visibles.isEmpty {
                    Text("Desliza una fila a la izquierda para marcarla como pagada.")
                }
            }

            Section {
                HStack {
                    Text("Total por pagar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(Formato.soles(totalPorPagar))
                        .font(.title3.bold())
                }
            } footer: {
                Text("Solo cuentan compras aprobadas a crédito y no pagadas.")
            }
        }
        .overlay {
            if visibles.isEmpty {
                ContentUnavailableView(
                    "Sin compras \(filtro.rawValue.lowercased())",
                    systemImage: "creditcard",
                    description: Text("Aquí aparecen las compras aprobadas a crédito.")
                )
                .padding(.bottom, 120)
            }
        }
        .alert("No se pudo pagar", isPresented: Binding(
            get: { mensajeError != nil },
            set: { if !$0 { mensajeError = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mensajeError ?? "")
        }
    }

    private func pagar(_ compra: Compra) {
        do {
            try ServicioCompras.pagar(compra, en: modelContext)
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}

/// Fila de cuenta por pagar: iniciales, proveedor, producto, vencimiento, total y estado
struct FilaPorPagar: View {
    let compra: Compra

    private var detalle: String {
        "\(compra.producto?.nombre ?? "Producto") × \(compra.cantidad) · vence \(Formato.diaMes(compra.vence))"
    }

    var body: some View {
        HStack(spacing: 12) {
            InicialesView(texto: compra.proveedor?.nombre ?? "?")
            VStack(alignment: .leading, spacing: 2) {
                Text(compra.proveedor?.nombre ?? "Proveedor")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(detalle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(Formato.soles(compra.total))
                    .font(.subheadline.weight(.semibold))
                if compra.estaVencida {
                    Insignia(texto: "VENCIDA", color: .red)
                } else if compra.pagada {
                    Insignia(texto: "Pagada", color: .green)
                }
            }
        }
    }
}
