import SwiftUI
import SwiftData
import Foundation

/// Crear o editar un producto (solo supervisor)
struct ProductoFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let producto: Producto? // nil = producto nuevo

    @State private var nombre: String
    @State private var categoria: String
    @State private var stockTexto: String
    @State private var costoTexto: String

    init(producto: Producto? = nil) {
        self.producto = producto
        _nombre = State(initialValue: producto?.nombre ?? "")
        _categoria = State(initialValue: producto?.categoria ?? "")
        _stockTexto = State(initialValue: producto.map { String($0.stock) } ?? "")
        _costoTexto = State(initialValue: producto.map { String(format: "%.2f", $0.costoPromedio) } ?? "")
    }

    private var stock: Int? { Int(stockTexto.limpio) }
    private var costo: Double? { Double(costoTexto.limpio.replacingOccurrences(of: ",", with: ".")) }

    /// Con compras registradas, el stock y el costo promedio solo cambian al aprobar compras
    private var tieneCompras: Bool { !(producto?.compras.isEmpty ?? true) }

    private var esValido: Bool {
        guard !nombre.limpio.isEmpty, !categoria.limpio.isEmpty,
              let stock, let costo else { return false }
        return stock >= 0 && costo >= 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Producto") {
                    TextField("Nombre", text: $nombre)
                    TextField("Categoría (Laptops, Monitores…)", text: $categoria)
                }
                Section {
                    TextField("Stock", text: $stockTexto)
                        .keyboardType(.numberPad)
                    TextField("Costo promedio (S/)", text: $costoTexto)
                        .keyboardType(.decimalPad)
                } header: {
                    Text(producto == nil ? "Inventario inicial" : "Inventario")
                } footer: {
                    if tieneCompras {
                        Text("Este producto ya tiene compras: su stock y costo promedio solo cambian al aprobar compras.")
                    }
                }
                .disabled(tieneCompras)
            }
            .navigationTitle(producto == nil ? "Nuevo producto" : "Editar producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: guardar)
                        .disabled(!esValido)
                }
            }
        }
    }

    private func guardar() {
        guard esValido, let stock, let costo else { return }
        if let producto {
            // UPDATE: basta cambiar las propiedades del objeto
            producto.nombre = nombre.limpio
            producto.categoria = categoria.limpio
            if !tieneCompras {
                producto.stock = stock
                producto.costoPromedio = costo
            }
        } else {
            // CREATE
            let nuevo = Producto(nombre: nombre.limpio, categoria: categoria.limpio, stock: stock, costoPromedio: costo)
            modelContext.insert(nuevo)
        }
        try? modelContext.save()
        dismiss()
    }
}
