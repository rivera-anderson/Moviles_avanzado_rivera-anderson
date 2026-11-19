import UIKit

/// A3 · Productos
/// Vendedor: solo consultar y buscar. Supervisor: crear, editar y borrar.
final class ProductosViewController: ListaBaseViewController {
    private var productos: [Producto] = []
    private var categorias: [String] = []
    private var categoriaElegida: String? // nil = Todas
    private let chips = ChipsView()

    private var esSupervisor: Bool { Sesion.shared.esSupervisor }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"

        // ① Botón + (solo supervisor)
        if esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
                self?.abrirFormulario(nil)
            })
        }

        // ③ Chips de categoría: filtran con NSPredicate "categoria == %@"
        chips.alSeleccionar = { [weak self] indice in
            guard let self else { return }
            categoriaElegida = indice == 0 ? nil : categorias[indice - 1]
            recargar()
        }
        chips.heightAnchor.constraint(equalToConstant: 36).isActive = true
        // ② Búsqueda · ③ Chips
        ponerCabecera([crearBuscador("Buscar producto"), chips], completas: [ObjectIdentifier(chips)])
    }

    override func recargar() {
        categorias = Consultas.categorias()
        if let elegida = categoriaElegida, !categorias.contains(elegida) { categoriaElegida = nil }
        let indice = categoriaElegida.flatMap { categorias.firstIndex(of: $0) }.map { $0 + 1 } ?? 0
        chips.configurar(titulos: ["Todos"] + categorias, seleccionado: indice)

        productos = Consultas.productos(busqueda: busqueda, categoria: categoriaElegida)
        tableView.reloadData()
        actualizarVacio()
    }

    private func actualizarVacio() {
        guard categorias.isEmpty else {
            contentUnavailableConfiguration = nil
            chips.isHidden = false
            mostrarMensajeVacio(productos.isEmpty ? "Ningún producto coincide con la búsqueda." : nil,
                                icono: "magnifyingglass")
            return
        }
        // No hay ningún producto registrado
        chips.isHidden = true
        mostrarMensajeVacio(nil)
        var configuracion = UIContentUnavailableConfiguration.empty()
        configuracion.image = UIImage(systemName: "shippingbox")
        configuracion.text = "Sin productos"
        configuracion.secondaryText = esSupervisor
            ? "Crea el primero con + o carga el catálogo de ejemplo."
            : "El supervisor todavía no registra productos."
        if esSupervisor {
            var boton = UIButton.Configuration.filled()
            boton.title = "Cargar catálogo de ejemplo"
            boton.cornerStyle = .capsule
            boton.baseBackgroundColor = .marca
            configuracion.button = boton
            configuracion.buttonProperties.primaryAction = UIAction { _ in
                if let usuario = Sesion.shared.usuario { DatosEjemplo.cargar(registradoPor: usuario) }
            }
        }
        contentUnavailableConfiguration = configuracion
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: FilaCell.id, for: indexPath) as! FilaCell
        let producto = productos[indexPath.row]
        // ④ Fila con stock en color: verde > 10, ámbar 6 a 10, rojo ≤ 5
        celda.configurar(icono: .iniciales(producto.nombre ?? ""),
                         titulo: producto.nombre ?? "",
                         subtitulo: producto.categoria,
                         valor: Formato.soles(producto.precio),
                         insignia: ("\(producto.stock) u.", Formato.colorStock(producto.stock)))
        celda.selectionStyle = esSupervisor ? .default : .none
        return celda
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard !productos.isEmpty else { return nil }
        return esSupervisor
            ? "Vista del supervisor: toca un producto para editarlo y desliza para borrar (bloqueado si tiene ventas). El vendedor solo consulta: sin “+” y sin borrar."
            : "Solo consulta y búsqueda: crear, editar y borrar le corresponde al supervisor."
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard esSupervisor else { return }
        abrirFormulario(productos[indexPath.row])
    }

    // ⑤ Deslizar para borrar (solo supervisor; bloqueado si tiene ventas)
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard esSupervisor else { return sinAcciones() }
        let producto = productos[indexPath.row]
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminado in
            terminado(self?.borrar(producto) ?? false)
        }
        borrar.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    private func borrar(_ producto: Producto) -> Bool {
        if producto.cantidadVentas > 0 {
            mostrarAlerta("No se puede borrar",
                          "“\(producto.nombre ?? "")” tiene \(producto.cantidadVentas) venta(s) registrada(s). La regla Deny lo impide.")
            return false
        }
        do {
            try ServicioVentas.borrar(producto)
            return true
        } catch {
            mostrarAlerta("No se puede borrar", error.localizedDescription)
            return false
        }
    }

    private func abrirFormulario(_ producto: Producto?) {
        let navegacion = UINavigationController(rootViewController: Pantallas.productoForm(producto))
        present(navegacion, animated: true)
    }
}
