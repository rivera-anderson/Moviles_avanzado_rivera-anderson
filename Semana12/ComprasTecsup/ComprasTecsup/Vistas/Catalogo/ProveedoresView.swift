import SwiftUI
import SwiftData
import Foundation

/// B4 · Proveedores
/// Comprador: solo consultar y buscar. Supervisor: crear, editar y borrar.
struct ProveedoresView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var proveedorAEditar: Proveedor?
    @State private var mensajeBloqueo: String?

    private var esSupervisor: Bool { sesion.esSupervisor }

    private var filtrados: [Proveedor] {
        let texto = busqueda.limpio
        guard !texto.isEmpty else { return proveedores }
        return proveedores.filter {
            $0.nombre.localizedCaseInsensitiveContains(texto) || $0.ruc.contains(texto)
        }
    }

    var body: some View {
        List {
            Section {
                ForEach(filtrados) { proveedor in
                    FilaProveedor(proveedor: proveedor) // ② Insignia y total comprado
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if esSupervisor { proveedorAEditar = proveedor }
                        }
                }
                .onDelete(perform: esSupervisor ? { borrar($0) } : nil)
            } footer: {
                if !proveedores.isEmpty {
                    // ③ Valores calculados desde las compras del proveedor
                    Text("“Por pagar” y “comprado” se calculan de las compras del proveedor (relación proveedor ▸ compras).")
                }
            }
        }
        .overlay {
            if proveedores.isEmpty {
                ContentUnavailableView(
                    "Sin proveedores",
                    systemImage: "building.2",
                    description: Text(esSupervisor ? "Crea el primero con +." : "El supervisor todavía no registra proveedores.")
                )
            }
        }
        .searchable(text: $busqueda, prompt: "Buscar por nombre o RUC")
        .navigationTitle("Proveedores")
        .toolbar { barra }
        .sheet(isPresented: $mostrarNuevo) {
            ProveedorFormView()
        }
        .sheet(item: $proveedorAEditar) { proveedor in
            ProveedorFormView(proveedor: proveedor)
        }
        .alert("No se puede borrar", isPresented: Binding(
            get: { mensajeBloqueo != nil },
            set: { if !$0 { mensajeBloqueo = nil } }
        )) {
            Button("Entendido", role: .cancel) {}
        } message: {
            Text(mensajeBloqueo ?? "")
        }
    }

    @ToolbarContentBuilder
    private var barra: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            AvatarMenu()
            if esSupervisor {
                Button {
                    mostrarNuevo = true
                } label: {
                    Label("Nuevo proveedor", systemImage: "plus") // ① Botón + (solo supervisor)
                }
            }
        }
    }

    /// DELETE con la regla .deny: un proveedor con compras no se borra
    private func borrar(_ offsets: IndexSet) {
        for index in offsets {
            let proveedor = filtrados[index]
            if !proveedor.compras.isEmpty {
                mensajeBloqueo = "“\(proveedor.nombre)” tiene \(proveedor.compras.count) compra(s) registrada(s)."
                continue
            }
            modelContext.delete(proveedor)
        }
        try? modelContext.save()
    }
}

/// Fila de proveedor: iniciales, nombre, RUC, total comprado e insignia "por pagar" / "Al día"
struct FilaProveedor: View {
    let proveedor: Proveedor

    var body: some View {
        HStack(spacing: 12) {
            InicialesView(texto: proveedor.nombre)
            VStack(alignment: .leading, spacing: 2) {
                Text(proveedor.nombre)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text("RUC \(proveedor.ruc)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(Formato.soles(proveedor.totalComprado))
                    .font(.subheadline.weight(.semibold))
                Text("comprado")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            if proveedor.cantidadPorPagar > 0 {
                Insignia(texto: "\(proveedor.cantidadPorPagar) por pagar", color: .red)
            } else {
                Insignia(texto: "Al día", color: .green)
            }
        }
    }
}
