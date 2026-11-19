import UIKit
import CoreData

/// Crear o editar un cliente (vendedor y supervisor)
final class ClienteFormViewController: FormularioViewController {
    private let cliente: Cliente? // nil = cliente nuevo

    private let campoNombre = CampoView(titulo: "Nombre o razón social", placeholder: "Ej. María López")
    private let campoDocumento = CampoView(titulo: "Documento (DNI o RUC)", placeholder: "8 u 11 dígitos", teclado: .numberPad)

    /// Escena "ClienteForm" de Main.storyboard; el cliente llega por este init
    init?(coder: NSCoder, cliente: Cliente?) {
        self.cliente = cliente
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cliente == nil ? "Nuevo cliente" : "Editar cliente"
        navigationItem.largeTitleDisplayMode = .never
        campoNombre.campo.autocapitalizationType = .words

        pila.addArrangedSubview(UILabel.seccion("Cliente"))
        pila.addArrangedSubview(campoNombre)
        pila.addArrangedSubview(campoDocumento)
        pila.addArrangedSubview(mensajeError)

        if let cliente {
            campoNombre.campo.text = cliente.nombre
            campoDocumento.campo.text = cliente.documento
            pila.addArrangedSubview(tarjetaCategoria(cliente))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if cliente == nil { campoNombre.campo.becomeFirstResponder() }
    }

    /// Categoría y total calculados con las ventas del cliente
    private func tarjetaCategoria(_ cliente: Cliente) -> UIView {
        let categoria = cliente.categoria
        let tarjeta = TarjetaView(titulo: "Calculado con sus ventas")
        let insignia = InsigniaLabel()
        insignia.mostrar(categoria.rawValue, color: categoria.color)
        let total = UILabel()
        total.text = Formato.soles(cliente.totalComprado)
        total.font = .redondeada(22, .bold)
        let fila = UIStackView(horizontal: [total, UIView.espaciador(), insignia])
        let detalle = UILabel()
        detalle.font = .systemFont(ofSize: 13)
        detalle.textColor = .secondaryLabel
        detalle.numberOfLines = 0
        let anuladas = cliente.cantidadVentas - cliente.ventasValidas.count
        detalle.text = "\(cliente.ventasValidas.count) venta(s) válidas" + (anuladas > 0 ? " · \(anuladas) anulada(s) que no cuentan" : "")
            + (categoria == .vip ? "\nTiene 10 % de descuento en cada venta." : "")
        tarjeta.agregar(fila, detalle)
        return tarjeta
    }

    override func guardar() {
        let nombre = campoNombre.texto.limpio
        let documento = campoDocumento.texto.limpio

        guard !nombre.isEmpty else { return mostrarError("Escribe el nombre del cliente.") }
        guard documento.allSatisfy(\.isNumber), documento.count == 8 || documento.count == 11 else {
            return mostrarError("El documento debe tener 8 dígitos (DNI) u 11 dígitos (RUC).")
        }

        let objeto = cliente ?? Cliente(context: CoreDataStack.shared.contexto)
        objeto.nombre = nombre
        objeto.documento = documento

        do {
            try CoreDataStack.shared.guardar()
            dismiss(animated: true)
        } catch {
            CoreDataStack.shared.contexto.rollback()
            mostrarError("No se pudo guardar: \(error.localizedDescription)")
        }
    }
}
