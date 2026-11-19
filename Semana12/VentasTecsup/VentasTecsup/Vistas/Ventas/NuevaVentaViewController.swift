import UIKit
import CoreData

/// A5 · Nueva venta (vendedor)
final class NuevaVentaViewController: UITableViewController {
    private enum Seccion: Int, CaseIterable { case datos, resumen }

    private var cliente: Cliente?
    private var producto: Producto?
    private let contador = ContadorView()
    private let botonRegistrar = UIButton.principal("Registrar venta")

    private var cantidad: Int { contador.valor }

    /// Se crea desde Main.storyboard
    required init?(coder: NSCoder) { super.init(coder: coder) }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nueva venta" // La pestaña se llama "Venta"
        navigationItem.largeTitleDisplayMode = .never
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionHeaderTopPadding = 8
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")

        tableView.tableHeaderView = cabeceraVendedor()   // ①
        tableView.tableFooterView = pieConBoton()        // ⑥

        contador.alCambiar = { [weak self] in self?.actualizar() }
        botonRegistrar.addAction(UIAction { [weak self] _ in self?.registrar() }, for: .touchUpInside)

        NotificationCenter.default.addObserver(self, selector: #selector(datosGuardados),
                                               name: .NSManagedObjectContextDidSave,
                                               object: CoreDataStack.shared.contexto)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        validarSeleccion()
        actualizar()
    }

    @objc private func datosGuardados() {
        validarSeleccion()
        actualizar()
    }

    /// Si borraron lo elegido, se limpia
    private func validarSeleccion() {
        if let cliente, cliente.isDeleted || cliente.managedObjectContext == nil { self.cliente = nil }
        if let producto, producto.isDeleted || producto.managedObjectContext == nil { self.producto = nil }
    }

    // MARK: - ① Vendedor de la sesión (automático, no editable)

    private func cabeceraVendedor() -> UIView {
        let usuario = Sesion.shared.usuario
        let iniciales = InicialesView(tamano: 40)
        iniciales.mostrar(usuario?.nombreMostrado ?? "")

        let nombre = UILabel()
        let texto = NSMutableAttributedString(string: usuario?.nombreMostrado ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.marca
        ])
        texto.append(NSAttributedString(string: " · \(usuario?.rol ?? "")", attributes: [
            .font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.marca
        ]))
        nombre.attributedText = texto
        let ayuda = UILabel()
        ayuda.text = "Sesión iniciada · la venta se registra a tu nombre"
        ayuda.font = .systemFont(ofSize: 13)
        ayuda.textColor = UIColor.marca.withAlphaComponent(0.85)
        ayuda.numberOfLines = 0

        let fila = UIStackView(horizontal: [iniciales, UIStackView(vertical: [nombre, ayuda], espaciado: 2)], espaciado: 12)
        let tarjeta = UIView()
        tarjeta.backgroundColor = UIColor.marca.withAlphaComponent(0.10)
        tarjeta.layer.cornerRadius = 16
        tarjeta.layer.cornerCurve = .continuous
        fila.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(fila)

        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 92))
        contenedor.addSubview(tarjeta)
        NSLayoutConstraint.activate([
            tarjeta.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8),
            tarjeta.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor, constant: -8),
            tarjeta.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
            tarjeta.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20),
            fila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 12),
            fila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -12),
            fila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 14),
            fila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -14)
        ])
        return contenedor
    }

    private func pieConBoton() -> UIView {
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 90))
        botonRegistrar.translatesAutoresizingMaskIntoConstraints = false
        contenedor.addSubview(botonRegistrar)
        NSLayoutConstraint.activate([
            botonRegistrar.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8),
            botonRegistrar.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
            botonRegistrar.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20)
        ])
        return contenedor
    }

    // MARK: - Cálculo

    private var resumen: ResumenVenta {
        guard let producto, cantidad > 0 else { return .cero }
        return ReglasVenta.calcular(cantidad: cantidad, precioUnitario: producto.precio,
                                    categoria: cliente?.categoria ?? .regular)
    }

    /// No recarga la fila de Cantidad: así el teclado no se cierra mientras se escribe
    private func actualizar() {
        if tableView.numberOfSections == Seccion.allCases.count {
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)], with: .none)
                tableView.reloadSections(IndexSet(integer: Seccion.resumen.rawValue), with: .none)
            }
            tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.textLabel?.attributedText = textoCantidad()
        } else {
            tableView.reloadData()
        }
        botonRegistrar.isEnabled = cliente != nil && producto != nil && cantidad > 0
    }

    // MARK: - Tabla

    override func numberOfSections(in tableView: UITableView) -> Int { Seccion.allCases.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Seccion(rawValue: section) == .datos ? 3 : 4
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Seccion(rawValue: section) == .resumen ? "Resumen (calculado)" : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
        celda.textLabel?.font = .systemFont(ofSize: 17)
        celda.detailTextLabel?.font = .systemFont(ofSize: 17)
        celda.selectionStyle = .none

        if Seccion(rawValue: indexPath.section) == .datos {
            switch indexPath.row {
            case 0: // ② Cliente
                celda.textLabel?.text = "Cliente"
                celda.detailTextLabel?.text = cliente?.nombre ?? "Elegir"
                celda.accessoryType = .disclosureIndicator
                celda.selectionStyle = .default
            case 1: // ③ Producto
                celda.textLabel?.text = "Producto"
                celda.detailTextLabel?.text = producto?.nombre ?? "Elegir"
                celda.accessoryType = .disclosureIndicator
                celda.selectionStyle = .default
            default: // ④ Cantidad con stepper y stock disponible
                celda.textLabel?.attributedText = textoCantidad()
                celda.accessoryView = contador
            }
        } else {
            let montos = resumen
            let esVIP = cliente?.categoria == .vip
            let filas: [(String, String)] = [
                ("Subtotal", Formato.soles(montos.subtotal)),
                (esVIP ? "Descuento VIP 10%" : "Descuento", "− " + Formato.soles(montos.descuento)),
                ("IGV 18%", Formato.soles(montos.igv)),
                ("Total", Formato.soles(montos.total))
            ]
            celda.textLabel?.text = filas[indexPath.row].0
            celda.detailTextLabel?.text = filas[indexPath.row].1
            celda.detailTextLabel?.textColor = .secondaryLabel
            if indexPath.row == 3 { // ⑤ Total
                celda.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
                celda.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .bold)
                celda.detailTextLabel?.textColor = .label
            }
        }
        return celda
    }

    /// "Cantidad (stock 40)": en rojo si la cantidad supera el stock
    private func textoCantidad() -> NSAttributedString {
        let texto = NSMutableAttributedString(string: "Cantidad", attributes: [.font: UIFont.systemFont(ofSize: 17)])
        if let producto {
            let excede = Int64(cantidad) > producto.stock
            texto.append(NSAttributedString(string: " (stock \(producto.stock))", attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: excede ? UIColor.systemRed : UIColor.secondaryLabel
            ]))
        }
        return texto
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard Seccion(rawValue: indexPath.section) == .datos else { return }
        if indexPath.row == 0 { elegirCliente() }
        if indexPath.row == 1 { elegirProducto() }
    }

    private func elegirCliente() {
        let clientes = Consultas.clientes()
        let opciones = clientes.map { item in
            SeleccionViewController.Opcion(
                titulo: item.nombre ?? "",
                subtitulo: "\(Formato.documento(item.documento)) · comprado \(Formato.soles(item.totalComprado))",
                insignia: (item.categoria.rawValue, item.categoria.color),
                habilitada: true, elegida: item == cliente)
        }
        let pantalla = Pantallas.seleccion(titulo: "Cliente", opciones: opciones,
                                               vacio: "No hay clientes. Créalos en la pestaña Clientes.") { [weak self] indice in
            self?.cliente = clientes[indice]
            self?.actualizar()
        }
        navigationController?.pushViewController(pantalla, animated: true)
    }

    private func elegirProducto() {
        let productos = Consultas.productos()
        let opciones = productos.map { item in
            SeleccionViewController.Opcion(
                titulo: item.nombre ?? "",
                subtitulo: "\(Formato.soles(item.precio)) · \(item.categoria ?? "")",
                insignia: ("\(item.stock) u.", Formato.colorStock(item.stock)),
                habilitada: item.stock > 0, elegida: item == producto)
        }
        let pantalla = Pantallas.seleccion(titulo: "Producto", opciones: opciones,
                                               vacio: "El supervisor todavía no registra productos.") { [weak self] indice in
            self?.producto = productos[indice]
            self?.actualizar()
        }
        navigationController?.pushViewController(pantalla, animated: true)
    }

    // MARK: - ⑥ Registrar venta

    private func registrar() {
        view.endEditing(true)
        guard let producto, let cliente else { return }
        let stockAntes = producto.stock
        do {
            let venta = try ServicioVentas.registrar(cantidad: cantidad, producto: producto,
                                                     cliente: cliente, vendedor: Sesion.shared.usuario)
            mostrarAlerta("Venta registrada",
                          "\(cliente.nombre ?? "") · \(producto.nombre ?? "") × \(venta.cantidad)\n"
                          + "Total \(Formato.soles(venta.total))\n"
                          + "Stock: \(stockAntes) → \(producto.stock) u.")
            contador.valor = 1
            actualizar()
        } catch ErrorVenta.stockInsuficiente(let pedido, let disponible) {
            // Regla de stock: alerta y no se registra
            mostrarAlerta("Stock insuficiente",
                          "Pediste \(pedido) u. de \(producto.nombre ?? "") y solo hay \(disponible) u. La venta no se registró y el stock no cambió.")
        } catch {
            mostrarAlerta("No se registró la venta", error.localizedDescription)
        }
    }
}

/// Stepper "− 2 +" con borde, como en la maqueta. El número también se puede escribir.
final class ContadorView: UIView {
    var alCambiar: (() -> Void)?
    private let campo = UITextField()

    var valor: Int {
        get { Int(campo.text ?? "") ?? 0 }
        set { campo.text = "\(max(newValue, 1))" }
    }

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 112, height: 36))
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 9

        let menos = boton("minus") { [weak self] in self?.cambiar(-1) }
        let mas = boton("plus") { [weak self] in self?.cambiar(+1) }
        campo.text = "1"
        campo.textAlignment = .center
        campo.keyboardType = .numberPad
        campo.font = .systemFont(ofSize: 17, weight: .semibold)
        campo.addAction(UIAction { [weak self] _ in self?.alCambiar?() }, for: .editingChanged)
        campo.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if valor < 1 { valor = 1 }
            alCambiar?()
        }, for: .editingDidEnd)

        let pila = UIStackView(horizontal: [menos, campo, mas], espaciado: 0, alineacion: .fill)
        pila.frame = bounds
        pila.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menos.widthAnchor.constraint(equalToConstant: 34).isActive = true
        mas.widthAnchor.constraint(equalToConstant: 34).isActive = true
        addSubview(pila)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    private func boton(_ simbolo: String, accion: @escaping () -> Void) -> UIButton {
        let boton = UIButton(type: .system)
        boton.setImage(UIImage(systemName: simbolo, withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)), for: .normal)
        boton.tintColor = .label
        boton.addAction(UIAction { _ in accion() }, for: .touchUpInside)
        return boton
    }

    private func cambiar(_ paso: Int) {
        valor = max(valor + paso, 1)
        alCambiar?()
    }
}
