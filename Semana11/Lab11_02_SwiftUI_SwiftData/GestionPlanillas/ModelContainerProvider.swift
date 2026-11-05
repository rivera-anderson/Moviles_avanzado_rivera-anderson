import Foundation
import SwiftData

@MainActor // Garantiza que esta clase se ejecute en el hilo principal (UI-safe)
class ModelContainerProvider {
    // Patrón Singleton: compartimos una única instancia del contenedor en toda la app
    static let shared = ModelContainerProvider()

    let container: ModelContainer // Contenedor principal de SwiftData

    private init() {
        // Esquema: las clases modelo que queremos persistir
        let schema = Schema([Alumno.self, Curso.self])

        do {
            let carpeta = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first!
            // Nos aseguramos de que la carpeta exista (en una instalación nueva puede no existir)
            try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)

            // Dónde y cómo se guardará la base de datos SQLite
            let config = ModelConfiguration(
                "AlumnosData",
                schema: schema,
                url: carpeta.appendingPathComponent("AlumnosData.sqlite")
            )

            // Para ver dónde quedó el archivo
            print("Base de datos SQLite en: \(config.url.path)")

            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
