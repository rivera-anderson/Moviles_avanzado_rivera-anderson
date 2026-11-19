import UIKit

/// Lista para elegir cliente o producto en Nueva venta
final class SeleccionViewController: UITableViewController {
    struct Opcion {
        let titulo: String
        let subtitulo: String
        let insignia: (String, UIColor)
        let habilitada: Bool
        let elegida: Bool
    }

    private let opciones: [Opcion]
    private let vacio: String
    private let alElegir: (Int) -> Void

    /// Escena "Seleccion" de Main.storyboard; los datos llegan por este init
    init?(coder: NSCoder, titulo: String, opciones: [Opcion], vacio: String, alElegir: @escaping (Int) -> Void) {
        self.opciones = opciones
        self.vacio = vacio
        self.alElegir = alElegir
        super.init(coder: coder)
        title = titulo
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(FilaCell.self, forCellReuseIdentifier: FilaCell.id)
        if opciones.isEmpty {
            var configuracion = UIContentUnavailableConfiguration.empty()
            configuracion.text = vacio
            configuracion.image = UIImage(systemName: "tray")
            contentUnavailableConfiguration = configuracion
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        opciones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: FilaCell.id, for: indexPath) as! FilaCell
        let opcion = opciones[indexPath.row]
        celda.configurar(icono: .iniciales(opcion.titulo), titulo: opcion.titulo,
                         subtitulo: opcion.subtitulo, insignia: opcion.insignia)
        celda.accessoryType = opcion.elegida ? .checkmark : .none
        celda.contentView.alpha = opcion.habilitada ? 1 : 0.4
        celda.selectionStyle = opcion.habilitada ? .default : .none
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard opciones[indexPath.row].habilitada else { return }
        alElegir(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
