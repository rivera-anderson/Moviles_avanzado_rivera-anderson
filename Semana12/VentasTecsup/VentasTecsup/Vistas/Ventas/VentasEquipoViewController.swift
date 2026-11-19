import UIKit

/// A7 · Ventas del equipo (supervisor): ve todas, filtra por periodo y vendedor, y anula con motivo
final class VentasEquipoViewController: ListaBaseViewController {
    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []
    private var vendedorElegido: Usuario? // nil = Todos
    private var periodo: Periodo = .todas
    private let segmentos = UISegmentedControl(items: Periodo.allCases.map(\.titulo))
    private let chips = ChipsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ventas del equipo" // La pestaña se llama "Ventas"
        navigationItem.rightBarButtonItem = .inicialesSesion()

        // Periodo: NSPredicate "fecha >= %@ AND fecha < %@"
        segmentos.selectedSegmentIndex = periodo.rawValue
        segmentos.heightAnchor.constraint(equalToConstant: 34).isActive = true
        segmentos.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            periodo = Periodo(rawValue: segmentos.selectedSegmentIndex) ?? .todas
            recargar()
        }, for: .valueChanged)

        // ① Chips por vendedor: NSPredicate "vendedor == %@"
        chips.heightAnchor.constraint(equalToConstant: 36).isActive = true
        chips.alSeleccionar = { [weak self] indice in
            guard let self else { return }
            vendedorElegido = indice == 0 ? nil : vendedores[indice - 1]
            recargar()
        }

        ponerCabecera([segmentos, chips, crearBuscador("Buscar por cliente")],
                      completas: [ObjectIdentifier(chips)])
    }

    override func recargar() {
        vendedores = Consultas.vendedores()
        if let elegido = vendedorElegido, !vendedores.contains(elegido) { vendedorElegido = nil }
        let indice = vendedorElegido.flatMap { vendedores.firstIndex(of: $0) }.map { $0 + 1 } ?? 0
        chips.configurar(titulos: ["Todos"] + vendedores.map(\.nombreMostrado), seleccionado: indice)

        ventas = Consultas.ventas(vendedor: vendedorElegido, periodo: periodo, cliente: busqueda)
        tableView.reloadData()
        mostrarMensajeVacio(ventas.isEmpty ? "No hay ventas con estos filtros." : nil, icono: "list.bullet.rectangle")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: FilaCell.id, for: indexPath) as! FilaCell
        // ② Venta con el nombre del vendedor (relación venta ▸ vendedor)
        celda.mostrarDelEquipo(ventas[indexPath.row])
        return celda
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        // ④ Nota de la relación
        ventas.isEmpty ? nil : "El nombre del vendedor se lee de la relación venta ▸ vendedor."
    }

    // ③ Deslizar para Anular (solo supervisor, y solo si no está anulada)
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let venta = ventas[indexPath.row]
        guard Sesion.shared.esSupervisor, !venta.anulada else { return sinAcciones() }
        let anular = UIContextualAction(style: .normal, title: "Anular") { [weak self] _, _, terminado in
            terminado(true)
            self?.pedirAnulacion(venta)
        }
        anular.backgroundColor = .systemRed
        let configuracion = UISwipeActionsConfiguration(actions: [anular])
        configuracion.performsFirstActionWithFullSwipe = false
        return configuracion
    }

    /// A8 · Alerta de anulación
    private func pedirAnulacion(_ venta: Venta) {
        let alerta = AnularVentaAlerta.crear(venta: venta) { [weak self] resultado in
            if case .failure(let error) = resultado {
                self?.mostrarAlerta("No se pudo anular", error.localizedDescription)
            }
        }
        present(alerta, animated: true)
    }
}
