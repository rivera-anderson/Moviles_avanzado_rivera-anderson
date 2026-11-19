import SwiftUI
import SwiftData
import Foundation

/// B3 · Productos
/// Comprador: solo consultar y buscar. Supervisor: crear, editar y borrar.
struct ProductosView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    // READ: consulta automática, se redibuja sola cuando cambian los productos
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var productoAEditar: Producto?
    @State private var mensajeBloqueo: String?

    private var esSupervisor: Bool { sesion.esSupervisor }

    // ② Búsqueda por nombre o categoría
    private var filtrados: [Producto] {
        let texto = busqueda.limpio
        guard !texto.isEmpty else { return productos }
        return productos.filter {
            $0.nombre.localizedCaseInsensitiveContains(texto) || $0.categoria.localizedCaseInsensitiveContains(texto)
        }
    }

    // ④ Valor del inventario = Σ stock × costo promedio
    private var valorInventario: Double {
        productos.reduce(0) { $0 + $1.valorInventario }
    }

    var body: some View {
        List {
            Section {
                ForEach(filtrados) { producto in
                    FilaProducto(producto: producto) // ③ Fila con costo promedio y stock en color
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if esSupervisor { productoAEditar = producto } // Editar (solo supervisor)
                        }
                }
                // ⑤ Deslizar para borrar: solo supervisor (para el comprador se pasa nil y no hay swipe)
                .onDelete(perform: esSupervisor ? { borrar($0) } : nil)
            }

            if !productos.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Valor del inventario (stock × costo promedio)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(Formato.soles(valorInventario))
                            .font(.title3.bold())
                    }
                } footer: {
                    Text(esSupervisor
                         ? "Toca un producto para editarlo. Desliza a la izquierda para borrar (bloqueado si tiene compras)."
                         : "Solo consulta y búsqueda. Crear, editar y borrar le corresponde al supervisor.")
                }
            }
        }
        .overlay {
            if productos.isEmpty {
                ContentUnavailableView {
                    Label("Sin productos", systemImage: "shippingbox")
                } description: {
                    Text(esSupervisor ? "Crea el primero con + o carga el catálogo de ejemplo." : "El supervisor todavía no registra productos.")
                } actions: {
                    if esSupervisor {
                        Button("Cargar catálogo de ejemplo") {
                            DatosEjemplo.cargarCatalogo(en: modelContext)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .searchable(text: $busqueda, prompt: "Buscar")
        .navigationTitle("Productos") // ① Título
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                AvatarMenu()
                if esSupervisor {
                    Button {
                        mostrarNuevo = true
                    } label: {
                        Label("Nuevo producto", systemImage: "plus") // ① Botón + (solo supervisor)
                    }
                }
            }
        }
        .sheet(isPresented: $mostrarNuevo) {
            ProductoFormView()
        }
        .sheet(item: $productoAEditar) { producto in
            ProductoFormView(producto: producto)
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

    /// DELETE con la regla .deny: un producto con compras no se borra
    private func borrar(_ offsets: IndexSet) {
        for index in offsets {
            let producto = filtrados[index] // Índices de la lista que se ve en pantalla
            if !producto.compras.isEmpty {
                mensajeBloqueo = "“\(producto.nombre)” tiene \(producto.compras.count) compra(s) registrada(s)."
                continue
            }
            modelContext.delete(producto)
        }
        try? modelContext.save()
    }
}

/// Fila de producto: iniciales, nombre, categoría, costo promedio y stock en color
struct FilaProducto: View {
    let producto: Producto

    var body: some View {
        HStack(spacing: 12) {
            InicialesView(texto: producto.nombre)
            VStack(alignment: .leading, spacing: 2) {
                Text(producto.nombre)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(producto.categoria)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(Formato.soles(producto.costoPromedio))
                    .font(.subheadline.weight(.semibold))
                Text("costo prom.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Insignia(texto: "\(producto.stock) u.", color: Formato.colorStock(producto.stock))
        }
    }
}
