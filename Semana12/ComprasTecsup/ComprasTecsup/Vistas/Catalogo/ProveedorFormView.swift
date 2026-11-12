import SwiftUI
import SwiftData
import Foundation

/// Crear o editar un proveedor (solo supervisor)
struct ProveedorFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let proveedor: Proveedor? // nil = proveedor nuevo

    @State private var nombre: String
    @State private var ruc: String

    init(proveedor: Proveedor? = nil) {
        self.proveedor = proveedor
        _nombre = State(initialValue: proveedor?.nombre ?? "")
        _ruc = State(initialValue: proveedor?.ruc ?? "")
    }

    /// RUC peruano: 11 dígitos
    private var rucValido: Bool {
        let texto = ruc.limpio
        return texto.count == 11 && texto.allSatisfy { $0.isNumber }
    }

    private var esValido: Bool { !nombre.limpio.isEmpty && rucValido }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Razón social", text: $nombre)
                    TextField("RUC (11 dígitos)", text: $ruc)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Proveedor")
                } footer: {
                    if !ruc.isEmpty && !rucValido {
                        Text("El RUC debe tener exactamente 11 dígitos.")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(proveedor == nil ? "Nuevo proveedor" : "Editar proveedor")
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
        guard esValido else { return }
        if let proveedor {
            proveedor.nombre = nombre.limpio // UPDATE
            proveedor.ruc = ruc.limpio
        } else {
            modelContext.insert(Proveedor(nombre: nombre.limpio, ruc: ruc.limpio)) // CREATE
        }
        try? modelContext.save()
        dismiss()
    }
}
