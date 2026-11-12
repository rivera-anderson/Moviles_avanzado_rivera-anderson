import SwiftUI
import SwiftData
import Foundation

/// B7 · Aprobar (solo supervisor)
struct AprobarView: View {
    @Environment(\.modelContext) private var modelContext

    // Compras pendientes de aprobación (las de S/ 5,000 o más), la más antigua primero
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }, sort: \Compra.fecha)
    private var pendientes: [Compra]

    @State private var compraARechazar: Compra?
    @State private var mensajeError: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(pendientes) { compra in
                    // ② Tarjeta de la compra pendiente con quién la solicitó
                    TarjetaAprobacion(
                        compra: compra,
                        alAprobar: { aprobar(compra) },
                        alRechazar: { compraARechazar = compra }
                    )
                }
                if !pendientes.isEmpty {
                    Text("Al rechazar se pide un motivo, que el comprador verá en “Mis compras”.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .background(Color.fondoAgrupado)
        .overlay {
            if pendientes.isEmpty {
                ContentUnavailableView(
                    "Nada por aprobar",
                    systemImage: "checkmark.seal",
                    description: Text("Las compras desde S/ 5,000 aparecerán aquí.")
                )
            }
        }
        .navigationTitle("Aprobar")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AvatarMenu() // ① Avatar de la sesión
            }
        }
        .sheet(item: $compraARechazar) { compra in
            RechazoView(compra: compra)
        }
        .alert("No se pudo aprobar", isPresented: Binding(
            get: { mensajeError != nil },
            set: { if !$0 { mensajeError = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mensajeError ?? "")
        }
    }

    private func aprobar(_ compra: Compra) {
        do {
            try ServicioCompras.aprobar(compra, en: modelContext)
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}

/// Tarjeta con el detalle de la compra, la vista previa del efecto y los botones
struct TarjetaAprobacion: View {
    let compra: Compra
    let alAprobar: () -> Void
    let alRechazar: () -> Void

    private var titulo: String {
        "\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.producto?.nombre ?? "Producto")"
    }
    private var solicitante: String {
        "Solicitó: \(compra.comprador?.nombre ?? "—") · \(Formato.diaMes(compra.fecha))"
    }
    private var condicionPago: String {
        compra.alCredito ? "Crédito 30 días · vence \(Formato.diaMes(compra.vence))" : "Contado"
    }

    // ③ Vista previa del efecto: stock y costo promedio antes y después
    private var stockAntes: Int { compra.producto?.stock ?? 0 }
    private var stockDespues: Int { stockAntes + compra.cantidad }
    private var costoAntes: Double { compra.producto?.costoPromedio ?? 0 }
    private var costoDespues: Double {
        ReglasCompra.nuevoCostoPromedio(stockActual: stockAntes, costoActual: costoAntes,
                                        cantidad: compra.cantidad, costoUnitario: compra.costoUnitario)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(titulo)
                        .font(.headline)
                    Text(solicitante)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Insignia(texto: EstadoCompra.pendiente, color: .ambar)
            }

            Divider()

            VStack(alignment: .leading, spacing: 3) {
                Text("\(compra.cantidad) u. × \(Formato.soles(compra.costoUnitario)) = \(Formato.soles(compra.subtotal))")
                Text("IGV 18% \(Formato.soles(compra.igv)) · Total \(Formato.soles(compra.total))")
                    .fontWeight(.semibold)
                Text(condicionPago)
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)

            VStack(alignment: .leading, spacing: 3) {
                Text("Si apruebas:")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("Stock \(stockAntes) → \(stockDespues)")
                Text("Costo promedio \(Formato.soles(costoAntes)) → \(Formato.soles(costoDespues))")
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.marca.opacity(0.12)))

            // ④ Rechazar (pide motivo) o Aprobar
            HStack(spacing: 12) {
                Button(role: .destructive, action: alRechazar) {
                    Text("Rechazar").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button(action: alAprobar) {
                    Text("Aprobar").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .controlSize(.large)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.fondoTarjeta))
    }
}

/// Hoja para rechazar: el motivo es obligatorio (el botón está desactivado mientras esté vacío)
struct RechazoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let compra: Compra
    @State private var motivo = ""
    @State private var mensajeError: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Compra") {
                    Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.producto?.nombre ?? "Producto")")
                    Text("\(compra.cantidad) u. · Total \(Formato.soles(compra.total))")
                        .foregroundStyle(.secondary)
                }
                Section {
                    TextField("Ej. Precio por encima del mercado", text: $motivo, axis: .vertical)
                        .lineLimit(2...4)
                } header: {
                    Text("Motivo (obligatorio)")
                } footer: {
                    Text("El comprador verá este motivo en “Mis compras”. Rechazar no cambia stock ni costo promedio.")
                }
                if let mensajeError {
                    Text(mensajeError)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Rechazar compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Rechazar", role: .destructive, action: rechazar)
                        .disabled(motivo.limpio.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func rechazar() {
        do {
            try ServicioCompras.rechazar(compra, motivo: motivo, en: modelContext)
            dismiss()
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}
