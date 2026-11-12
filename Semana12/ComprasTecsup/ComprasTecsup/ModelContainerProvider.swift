import Foundation
import SwiftData

@MainActor // Garantiza que esta clase se ejecute en el hilo principal (UI-safe)
class ModelContainerProvider {
    // Patrón Singleton: una única instancia del contenedor en toda la app
    static let shared = ModelContainerProvider()

    let container: ModelContainer // Contenedor principal de SwiftData

    private init() {
        // Esquema: las cuatro clases @Model que se guardan
        let schema = Schema([Usuario.self, Proveedor.self, Producto.self, Compra.self])

        do {
            let carpeta = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first!
            // En una instalación nueva la carpeta puede no existir todavía
            try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)

            // Dónde y cómo se guardará la base de datos SQLite
            let config = ModelConfiguration(
                "ComprasData",
                schema: schema,
                url: carpeta.appendingPathComponent("ComprasData.sqlite")
            )

            // Para ver dónde quedó el archivo
            print("Base de datos SQLite en: \(config.url.path)")

            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
