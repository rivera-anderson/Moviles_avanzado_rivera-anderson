import SwiftUI
import SwiftData
import Foundation

/// B1 · Inicio de sesión
struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var mensajeError: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // ① Logo y nombre
                    LogoApp()
                        .padding(.top, 48)
                    VStack(spacing: 4) {
                        Text("Compras Tecsup")
                            .font(.title.bold())
                        Text("Inicia sesión para continuar")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 12)

                    // ② Usuario
                    CampoTarjeta(etiqueta: "Usuario") {
                        TextField("usuario", text: $usuario)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }

                    // ③ Clave oculta
                    CampoTarjeta(etiqueta: "Clave") {
                        SecureField("••••••", text: $clave)
                    }

                    // ④ Mensaje de error genérico (no dice si falló el usuario o la clave)
                    if let mensajeError {
                        MensajeError(texto: mensajeError)
                    }

                    // ⑤ Ingresar
                    Button(action: ingresar) {
                        Text("Ingresar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(usuario.limpio.isEmpty || clave.isEmpty)

                    // ⑥ Ir a Crear cuenta
                    HStack(spacing: 4) {
                        Text("¿Primera vez?")
                            .foregroundStyle(.secondary)
                        NavigationLink("Crear cuenta") {
                            RegistroView()
                        }
                        .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal, 24)
            }
            .background(Color.fondoAgrupado)
            .navigationTitle("Ingresar") // Texto del botón "volver" en Crear cuenta
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func ingresar() {
        // Guardamos el texto en constantes antes de usarlo dentro del #Predicate
        let usuarioBuscado = usuario.limpio.lowercased()
        let claveIngresada = clave

        var descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate<Usuario> { $0.usuario == usuarioBuscado && $0.clave == claveIngresada }
        )
        descriptor.fetchLimit = 1

        if let encontrado = try? modelContext.fetch(descriptor).first {
            mensajeError = nil
            sesion.iniciar(encontrado) // RaizView muestra las pestañas del rol
        } else {
            mensajeError = "Usuario o clave incorrectos"
        }
    }
}

#Preview {
    LoginView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
