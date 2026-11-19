import UIKit
import CoreData

/// Base de las pantallas con lista: tabla agrupada, cabecera (búsqueda, chips, segmented)
/// y recarga automática cada vez que se guarda algo en Core Data.
class ListaBaseViewController: UITableViewController, UISearchBarDelegate {
    /// Texto escrito en la barra de búsqueda
    var busqueda = ""

    /// Se crea desde Main.storyboard (la tabla es "Inset Grouped" en el storyboard)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FilaCell.self, forCellReuseIdentifier: FilaCell.id)
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionHeaderTopPadding = 4
        navigationItem.largeTitleDisplayMode = .never

        // Cuando cualquier pantalla guarda, esta lista se vuelve a leer
        NotificationCenter.default.addObserver(self, selector: #selector(datosGuardados),
                                               name: .NSManagedObjectContextDidSave,
                                               object: CoreDataStack.shared.contexto)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recargar()
    }

    @objc private func datosGuardados() {
        guard isViewLoaded else { return }
        recargar()
    }

    /// Cada pantalla lee sus datos aquí
    func recargar() {}

    // MARK: - Búsqueda dentro de la pantalla (como en la maqueta)

    func crearBuscador(_ placeholder: String) -> UISearchBar {
        let buscador = UISearchBar()
        buscador.searchBarStyle = .minimal
        buscador.placeholder = placeholder
        buscador.autocapitalizationType = .none
        buscador.delegate = self
        return buscador
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        busqueda = searchText
        recargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Cabecera

    /// Pone varias filas arriba de la tabla. `completas` ocupan todo el ancho (chips).
    func ponerCabecera(_ filas: [UIView], completas: Set<ObjectIdentifier> = []) {
        let contenedor = UIView()
        let pila = UIStackView(vertical: [], espaciado: 10)
        pila.translatesAutoresizingMaskIntoConstraints = false
        for fila in filas {
            if completas.contains(ObjectIdentifier(fila)) {
                pila.addArrangedSubview(fila)
            } else {
                // La barra de búsqueda minimal ya trae ~8 pt de margen propio
                let margen: CGFloat = fila is UISearchBar ? 12 : 20
                let envoltura = UIView()
                fila.translatesAutoresizingMaskIntoConstraints = false
                envoltura.addSubview(fila)
                NSLayoutConstraint.activate([
                    fila.topAnchor.constraint(equalTo: envoltura.topAnchor),
                    fila.bottomAnchor.constraint(equalTo: envoltura.bottomAnchor),
                    fila.leadingAnchor.constraint(equalTo: envoltura.leadingAnchor, constant: margen),
                    fila.trailingAnchor.constraint(equalTo: envoltura.trailingAnchor, constant: -margen)
                ])
                pila.addArrangedSubview(envoltura)
            }
        }
        contenedor.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8),
            pila.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor),
            pila.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor),
            pila.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor, constant: -4)
        ])
        tableView.tableHeaderView = contenedor
        ajustarCabecera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ajustarCabecera()
    }

    /// La tabla no calcula sola la altura de la cabecera: la medimos con Auto Layout
    private func ajustarCabecera() {
        guard let cabecera = tableView.tableHeaderView, tableView.bounds.width > 0 else { return }
        let tamano = cabecera.systemLayoutSizeFitting(
            CGSize(width: tableView.bounds.width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        if abs(cabecera.frame.height - tamano.height) > 0.5 || cabecera.frame.width != tableView.bounds.width {
            cabecera.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tamano.height)
            tableView.tableHeaderView = cabecera
        }
    }

    /// Mensaje centrado cuando la lista queda vacía (no tapa la cabecera)
    func mostrarMensajeVacio(_ texto: String?, icono: String = "tray") {
        guard let texto else {
            tableView.backgroundView = nil
            return
        }
        let imagen = UIImageView(image: UIImage(systemName: icono))
        imagen.tintColor = .tertiaryLabel
        imagen.preferredSymbolConfiguration = .init(pointSize: 36, weight: .regular)
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.textColor = .secondaryLabel
        etiqueta.font = .systemFont(ofSize: 15)
        etiqueta.numberOfLines = 0
        etiqueta.textAlignment = .center
        let pila = UIStackView(vertical: [imagen, etiqueta], espaciado: 10, alineacion: .center)
        pila.translatesAutoresizingMaskIntoConstraints = false

        let fondo = UIView()
        fondo.addSubview(pila)
        let alturaCabecera = tableView.tableHeaderView?.frame.height ?? 0
        NSLayoutConstraint.activate([
            pila.centerXAnchor.constraint(equalTo: fondo.centerXAnchor),
            pila.centerYAnchor.constraint(equalTo: fondo.centerYAnchor, constant: alturaCabecera / 2),
            pila.leadingAnchor.constraint(greaterThanOrEqualTo: fondo.leadingAnchor, constant: 40),
            pila.trailingAnchor.constraint(lessThanOrEqualTo: fondo.trailingAnchor, constant: -40)
        ])
        tableView.backgroundView = fondo
    }

    /// Sin acciones al deslizar
    func sinAcciones() -> UISwipeActionsConfiguration {
        UISwipeActionsConfiguration(actions: [])
    }
}
