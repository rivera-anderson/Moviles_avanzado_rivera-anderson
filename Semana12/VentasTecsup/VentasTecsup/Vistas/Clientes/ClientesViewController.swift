import UIKit

/// A4 · Clientes
/// Vendedor: crear, editar y consultar. Supervisor: además borrar.
final class ClientesViewController: ListaBaseViewController {
    private var clientes: [Cliente] = []
    private var esSupervisor: Bool { Sesion.shared.esSupervisor }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        ponerCabecera([crearBuscador("Buscar por nombre o documento")])
        // ① Botón + (ambos roles pueden crear clientes)
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
            self?.abrirFormulario(nil)
        })
    }

    override func recargar() {
        clientes = Consultas.clientes(busqueda: busqueda)
        tableView.reloadData()
        if clientes.isEmpty {
            mostrarMensajeVacio(busqueda.limpio.isEmpty
                                ? "Sin clientes todavía.\nCrea el primero con +."
                                : "Ningún cliente coincide con la búsqueda.",
                                icono: "person.2")
        } else {
            mostrarMensajeVacio(nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: FilaCell.id, for: indexPath) as! FilaCell
        let cliente = clientes[indexPath.row]
        let categoria = cliente.categoria // ③ Calculada con las ventas no anuladas
        // ② Iniciales, nombre, documento y total comprado
        celda.configurar(icono: .iniciales(cliente.nombre ?? ""),
                         titulo: cliente.nombre ?? "",
                         subtitulo: Formato.documento(cliente.documento),
                         valor: Formato.soles(cliente.totalComprado),
                         valorSub: "comprado",
                         insignia: (categoria.rawValue, categoria.color))
        celda.selectionStyle = .default
        return celda
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard !clientes.isEmpty else { return nil }
        var texto = "Categoría y “comprado” se calculan con las ventas no anuladas; no se guardan."
        if esSupervisor { texto += " Desliza para borrar (bloqueado si tiene ventas)." }
        return texto
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        abrirFormulario(clientes[indexPath.row]) // Editar (ambos roles)
    }

    // Borrar: solo supervisor y bloqueado si tiene ventas (Deny)
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard esSupervisor else { return sinAcciones() }
        let cliente = clientes[indexPath.row]
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminado in
            terminado(self?.borrar(cliente) ?? false)
        }
        borrar.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    private func borrar(_ cliente: Cliente) -> Bool {
        if cliente.cantidadVentas > 0 {
            mostrarAlerta("No se puede borrar",
                          "“\(cliente.nombre ?? "")” tiene \(cliente.cantidadVentas) venta(s) registrada(s). La regla Deny lo impide.")
            return false
        }
        do {
            try ServicioVentas.borrar(cliente)
            return true
        } catch {
            mostrarAlerta("No se puede borrar", error.localizedDescription)
            return false
        }
    }

    private func abrirFormulario(_ cliente: Cliente?) {
        let navegacion = UINavigationController(rootViewController: Pantallas.clienteForm(cliente))
        present(navegacion, animated: true)
    }
}
