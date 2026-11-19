import UIKit

/// A6 · Mis ventas (vendedor): solo ve las suyas y no puede anular
final class MisVentasViewController: ListaBaseViewController {
    private var ventas: [Venta] = []
    private var periodo: Periodo = .todas
    private let tarjetaHoy = TarjetaMonto(titulo: "Hoy")
    private let tarjetaMes = TarjetaMonto(titulo: "Mes")
    private let segmentos = UISegmentedControl(items: Periodo.allCases.map(\.titulo))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis ventas"
        navigationItem.rightBarButtonItem = .inicialesSesion()

        // ② Segmented Todas / Hoy / Mes
        segmentos.selectedSegmentIndex = periodo.rawValue
        segmentos.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            periodo = Periodo(rawValue: segmentos.selectedSegmentIndex) ?? .todas
            recargar()
        }, for: .valueChanged)

        // ① Indicadores propios: hoy y mes
        let indicadores = UIStackView(horizontal: [tarjetaHoy, tarjetaMes], espaciado: 12, alineacion: .fill)
        indicadores.distribution = .fillEqually
        segmentos.heightAnchor.constraint(equalToConstant: 34).isActive = true

        // ③ Búsqueda por cliente
        ponerCabecera([indicadores, segmentos, crearBuscador("Buscar por cliente")])
    }

    override func recargar() {
        guard let yo = Sesion.shared.usuario else { return }
        let hoy = Consultas.totales(en: Fechas.hoy(), vendedor: yo)
        let mes = Consultas.totales(en: Fechas.mes(), vendedor: yo)
        tarjetaHoy.mostrar(Formato.soles(hoy.importe), nota: "\(hoy.cantidad) venta(s)")
        tarjetaMes.mostrar(Formato.soles(mes.importe), nota: "\(mes.cantidad) venta(s)")

        // ④ Predicate "vendedor == %@" con el usuario de la sesión
        ventas = Consultas.ventas(vendedor: yo, periodo: periodo, cliente: busqueda)
        tableView.reloadData()
        mostrarMensajeVacio(ventas.isEmpty ? "No tienes ventas en este periodo." : nil, icono: "cart")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: FilaCell.id, for: indexPath) as! FilaCell
        // ④ Venta propia · ⑤ Venta anulada (tachada, con etiqueta, sin botón)
        celda.mostrarPropia(ventas[indexPath.row])
        return celda
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        ventas.isEmpty ? nil : "Solo aparecen las ventas de este vendedor."
    }

    // El vendedor no puede anular: ninguna fila tiene acciones
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        sinAcciones()
    }
}

/// Tarjeta "Hoy / S/ 548.70 / 3 ventas"
final class TarjetaMonto: UIView {
    private let valor = UILabel()
    private let nota = UILabel()

    init(titulo: String, tamanoValor: CGFloat = 26) {
        super.init(frame: .zero)
        backgroundColor = .tarjeta
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        let etiqueta = UILabel()
        etiqueta.text = titulo
        etiqueta.font = .systemFont(ofSize: 14)
        etiqueta.textColor = .secondaryLabel
        valor.font = .systemFont(ofSize: tamanoValor, weight: .bold)
        valor.adjustsFontSizeToFitWidth = true
        valor.minimumScaleFactor = 0.6
        valor.text = Formato.soles(0)
        nota.font = .systemFont(ofSize: 13, weight: .medium)
        nota.textColor = .secondaryLabel

        let pila = UIStackView(vertical: [etiqueta, valor, nota], espaciado: 3)
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            pila.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            pila.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func mostrar(_ texto: String, nota textoNota: String?, colorNota: UIColor = .secondaryLabel) {
        valor.text = texto
        nota.text = textoNota
        nota.textColor = colorNota
        nota.isHidden = textoNota == nil
    }
}
