import CoreData

/// Pila de Core Data: un único contenedor compartido en toda la app (singleton)
final class CoreDataStack {
    static let shared = CoreDataStack()

    let contenedor: NSPersistentContainer

    /// Contexto principal (hilo de la interfaz)
    var contexto: NSManagedObjectContext { contenedor.viewContext }

    private init() {
        // "Ventas" es el nombre del archivo Ventas.xcdatamodeld
        contenedor = NSPersistentContainer(name: "Ventas")
        contenedor.loadPersistentStores { descripcion, error in
            if let error {
                fatalError("No se pudo abrir la base de datos: \(error)")
            }
            print("Base de datos SQLite en: \(descripcion.url?.path ?? "-")")
        }
        contenedor.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Guarda solo si hay cambios pendientes
    func guardar() throws {
        guard contexto.hasChanges else { return }
        try contexto.save()
    }
}
