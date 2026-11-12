import SwiftUI
import SwiftData

@main // Punto de entrada principal de la aplicación
struct ComprasTecsupApp: App {
    // Sesión: recuerda al usuario conectado mientras la app está abierta
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            RaizView() // Muestra el login o las pestañas según haya sesión
                .environment(sesion) // Cualquier vista puede leer la sesión con @Environment(Sesion.self)
                .tint(.marca)
                // Contenedor persistente para toda la app (SwiftData guarda en un archivo SQLite)
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
