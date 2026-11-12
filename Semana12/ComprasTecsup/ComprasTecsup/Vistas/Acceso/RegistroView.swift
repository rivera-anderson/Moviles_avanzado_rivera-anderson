import SwiftUI
import SwiftData
import Foundation

/// B2 · Crear cuenta
struct RegistroView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol = Rol.comprador
    @State private var usuarioDisponible: Bool? // nil mientras el campo está vacío
    @State private var mensajeError: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // ② Nombre completo
                CampoTarjeta(etiqueta: "Nombre completo") {
                    TextField("Ej. Lucía Paredes", text: $nombre)
                        .textContentType(.name)
                }

                // ③ Usuario único, con aviso si ya existe
                CampoTarjeta(etiqueta: "Usuario") {
                    TextField("usuario", text: $usuario)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } accesorio: {
                    if let disponible = usuarioDisponible {
                        Label(disponible ? "Disponible" : "Ya existe",
                              systemImage: disponible ? "checkmark" : "xmark")
                            .font(.caption.bold())
                            .foregroundStyle(disponible ? Color.green : Color.red)
                    }
                }

                // ④ Clave (mínimo 6) y su confirmación
                CampoTarjeta(etiqueta: "Clave (mínimo 6 caracteres)") {
                    SecureField("••••••", text: $clave)
                }
                CampoTarjeta(etiqueta: "Confirmar clave") {
                    SecureField("••••••", text: $confirmacion)
                }

                // ⑤ Rol
                VStack(alignment: .leading, spacing: 6) {
                    Text("TU ROL")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Picker("Rol", selection: $rol) {
                        ForEach(Rol.todos, id: \.self) { opcion in
                            Text(opcion).tag(opcion)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if let mensajeError {
                    MensajeError(texto: mensajeError)
                }

                // ⑥ Registrarme (entra directo a la app)
                Button(action: registrarme) {
                    Text("Registrarme")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)

                Text("Al registrarte entrarás directamente a la app con las pestañas de tu rol.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
        }
        .background(Color.fondoAgrupado)
        .navigationTitle("Crear cuenta") // ① Título (el botón volver lleva al login)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: usuario) {
            verificarDisponibilidad()
        }
    }

    // MARK: - Lógica

    private var usuarioNormalizado: String { usuario.limpio.lowercased() }

    private func verificarDisponibilidad() {
        let texto = usuarioNormalizado
        usuarioDisponible = texto.isEmpty ? nil : !existeUsuario(texto)
    }

    /// Usuario único (sin distinguir mayúsculas): FetchDescriptor con #Predicate + fetchCount.
    /// Funciona porque el usuario siempre se guarda en minúsculas.
    private func existeUsuario(_ texto: String) -> Bool {
        let buscado = texto // Guardamos el texto en un let antes de usarlo en el #Predicate
        let descriptor = FetchDescriptor<Usuario>(predicate: #Predicate<Usuario> { $0.usuario == buscado })
        let cantidad = (try? modelContext.fetchCount(descriptor)) ?? 0
        return cantidad > 0
    }

    private func registrarme() {
        let nombreLimpio = nombre.limpio
        let usuarioLimpio = usuarioNormalizado

        guard !nombreLimpio.isEmpty, !usuarioLimpio.isEmpty else {
            mensajeError = "Completa tu nombre y tu usuario."
            return
        }
        guard !existeUsuario(usuarioLimpio) else {
            mensajeError = "El usuario \"\(usuarioLimpio)\" ya existe. Elige otro."
            return
        }
        guard clave.count >= 6 else {
            mensajeError = "La clave debe tener al menos 6 caracteres."
            return
        }
        guard clave == confirmacion else {
            mensajeError = "La clave y su confirmación no coinciden."
            return
        }

        let nuevo = Usuario(nombre: nombreLimpio, usuario: usuarioLimpio, clave: clave, rol: rol)
        modelContext.insert(nuevo)
        do {
            try modelContext.save()
            mensajeError = nil
            sesion.iniciar(nuevo) // Entra directo a la app con las pestañas de su rol
        } catch {
            mensajeError = "No se pudo registrar: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationStack {
        RegistroView()
    }
    .environment(Sesion())
    .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
