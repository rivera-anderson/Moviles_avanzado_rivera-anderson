import CoreData

typealias Rango = (inicio: Date, fin: Date)

/// Rangos de fechas para los filtros y el resumen
enum Fechas {
    private static var calendario: Calendar { Calendar.current }

    static func hoy(_ ahora: Date = Date()) -> Rango {
        let inicio = calendario.startOfDay(for: ahora)
        return (inicio, calendario.date(byAdding: .day, value: 1, to: inicio) ?? ahora)
    }

    static func ayer() -> Rango {
        let rangoHoy = hoy()
        return (calendario.date(byAdding: .day, value: -1, to: rangoHoy.inicio) ?? rangoHoy.inicio, rangoHoy.inicio)
    }

    static func mes(_ ahora: Date = Date()) -> Rango {
        guard let intervalo = calendario.dateInterval(of: .month, for: ahora) else { return hoy(ahora) }
        return (intervalo.start, intervalo.end)
    }

    static func diasAtras(_ dias: Int) -> Rango {
        hoy(calendario.date(byAdding: .day, value: -dias, to: Date()) ?? Date())
    }
}

/// Segmented Todas / Hoy / Mes
enum Periodo: Int, CaseIterable {
    case todas, hoy, mes

    var titulo: String {
        switch self {
        case .todas: return "Todas"
        case .hoy: return "Hoy"
        case .mes: return "Mes"
        }
    }

    var rango: Rango? {
        switch self {
        case .todas: return nil
        case .hoy: return Fechas.hoy()
        case .mes: return Fechas.mes()
        }
    }
}

/// Todas las lecturas a Core Data con NSFetchRequest + NSPredicate
enum Consultas {
    private static var contexto: NSManagedObjectContext { CoreDataStack.shared.contexto }

    private static let porNombre = NSSortDescriptor(
        key: "nombre", ascending: true,
        selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
    )

    // MARK: - Usuarios

    /// Usuario único sin distinguir mayúsculas: "usuario ==[c] %@"
    static func usuarioExiste(_ usuario: String) -> Bool {
        let pedido = NSFetchRequest<Usuario>(entityName: "Usuario")
        pedido.predicate = NSPredicate(format: "usuario ==[c] %@", usuario.limpio)
        return ((try? contexto.count(for: pedido)) ?? 0) > 0
    }

    /// Login: usuario (sin distinguir mayúsculas) y clave exacta
    static func login(usuario: String, clave: String) -> Usuario? {
        let pedido = NSFetchRequest<Usuario>(entityName: "Usuario")
        pedido.predicate = NSPredicate(format: "usuario ==[c] %@ AND clave == %@", usuario.limpio, clave)
        pedido.fetchLimit = 1
        return try? contexto.fetch(pedido).first
    }

    /// Chips del supervisor: vendedores y cualquiera que tenga ventas
    static func vendedores() -> [Usuario] {
        let pedido = NSFetchRequest<Usuario>(entityName: "Usuario")
        pedido.predicate = NSPredicate(format: "rol == %@ OR ventas.@count > 0", Rol.vendedor)
        pedido.sortDescriptors = [porNombre]
        return (try? contexto.fetch(pedido)) ?? []
    }

    // MARK: - Productos

    static func productos(busqueda: String = "", categoria: String? = nil) -> [Producto] {
        let pedido = NSFetchRequest<Producto>(entityName: "Producto")
        var condiciones: [NSPredicate] = []
        if let categoria {
            condiciones.append(NSPredicate(format: "categoria == %@", categoria))
        }
        let texto = busqueda.limpio
        if !texto.isEmpty {
            condiciones.append(NSPredicate(format: "nombre CONTAINS[cd] %@ OR categoria CONTAINS[cd] %@", texto, texto))
        }
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        pedido.sortDescriptors = [porNombre]
        return (try? contexto.fetch(pedido)) ?? []
    }

    /// Categorías distintas para los chips
    static func categorias() -> [String] {
        let nombres = Set(productos().compactMap { $0.categoria }.filter { !$0.isEmpty })
        return nombres.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }

    /// Stock bajo: 5 unidades o menos
    static func productosStockBajo() -> [Producto] {
        let pedido = NSFetchRequest<Producto>(entityName: "Producto")
        pedido.predicate = NSPredicate(format: "stock <= %@", NSNumber(value: ReglasVenta.limiteStockBajo))
        pedido.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true), porNombre]
        return (try? contexto.fetch(pedido)) ?? []
    }

    // MARK: - Clientes

    static func clientes(busqueda: String = "") -> [Cliente] {
        let pedido = NSFetchRequest<Cliente>(entityName: "Cliente")
        let texto = busqueda.limpio
        if !texto.isEmpty {
            pedido.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", texto, texto)
        }
        pedido.sortDescriptors = [porNombre]
        return (try? contexto.fetch(pedido)) ?? []
    }

    // MARK: - Ventas

    /// Ventas con filtros: por vendedor (relación), por periodo (fechas) y por cliente (búsqueda)
    static func ventas(vendedor: Usuario?, periodo: Periodo = .todas, cliente busqueda: String = "") -> [Venta] {
        let pedido = NSFetchRequest<Venta>(entityName: "Venta")
        var condiciones: [NSPredicate] = []
        if let vendedor {
            condiciones.append(NSPredicate(format: "vendedor == %@", vendedor))
        }
        if let rango = periodo.rango {
            condiciones.append(NSPredicate(format: "fecha >= %@ AND fecha < %@",
                                           rango.inicio as NSDate, rango.fin as NSDate))
        }
        let texto = busqueda.limpio
        if !texto.isEmpty {
            condiciones.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", texto))
        }
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        pedido.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        return (try? contexto.fetch(pedido)) ?? []
    }

    /// Ventas NO anuladas en un rango (para indicadores y gráfico)
    static func ventasValidas(en rango: Rango, vendedor: Usuario? = nil) -> [Venta] {
        let pedido = NSFetchRequest<Venta>(entityName: "Venta")
        var condiciones = [
            NSPredicate(format: "anulada == NO"),
            NSPredicate(format: "fecha >= %@ AND fecha < %@", rango.inicio as NSDate, rango.fin as NSDate)
        ]
        if let vendedor {
            condiciones.append(NSPredicate(format: "vendedor == %@", vendedor))
        }
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        return (try? contexto.fetch(pedido)) ?? []
    }

    /// Cantidad e importe de ventas no anuladas
    static func totales(en rango: Rango, vendedor: Usuario? = nil) -> (cantidad: Int, importe: Double) {
        let lista = ventasValidas(en: rango, vendedor: vendedor)
        return (lista.count, lista.reduce(0) { $0 + $1.total })
    }

    /// IGV del mes: suma del IGV de las ventas no anuladas
    static func igvDelMes() -> Double {
        ventasValidas(en: Fechas.mes()).reduce(0) { $0 + $1.igv }
    }

    static func cantidadAnuladas(en rango: Rango) -> Int {
        let pedido = NSFetchRequest<Venta>(entityName: "Venta")
        pedido.predicate = NSPredicate(format: "anulada == YES AND fecha >= %@ AND fecha < %@",
                                       rango.inicio as NSDate, rango.fin as NSDate)
        return (try? contexto.count(for: pedido)) ?? 0
    }

    /// Gráfico: importe vendido en cada uno de los últimos 7 días (el último es hoy)
    static func ultimos7Dias() -> [(dia: Date, importe: Double)] {
        (0..<7).reversed().map { atras in
            let rango = Fechas.diasAtras(atras)
            return (rango.inicio, totales(en: rango).importe)
        }
    }

    /// Ranking de vendedores del mes por importe (relación venta ▸ vendedor)
    static func rankingDelMes() -> [(vendedor: Usuario, cantidad: Int, importe: Double)] {
        let grupos = Dictionary(grouping: ventasValidas(en: Fechas.mes())) { $0.vendedor }
        return grupos.compactMap { vendedor, ventas -> (Usuario, Int, Double)? in
            guard let vendedor else { return nil }
            return (vendedor, ventas.count, ventas.reduce(0) { $0 + $1.total })
        }
        .sorted { $0.2 > $1.2 }
        .map { (vendedor: $0.0, cantidad: $0.1, importe: $0.2) }
    }
}
