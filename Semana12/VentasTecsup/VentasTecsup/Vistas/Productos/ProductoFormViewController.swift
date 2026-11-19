import UIKit
import CoreData

/// Crear o editar un producto (solo supervisor)
final class ProductoFormViewController: FormularioViewController {
    private let producto: Producto? // nil = producto nuevo

    private let campoNombre = CampoView(titulo: "Nombre", placeholder: "Ej. Laptop")
    private let campoCategoria = CampoView(titulo: "Categoría", placeholder: "Ej. Cómputo, Accesorios…")
    private let campoPrecio = CampoView(titulo: "Precio de venta (S/)", placeholder: "0.00", teclado: .decimalPad)
    private let campoStock = CampoView(titulo: "Stock", placeholder: "0", teclado: .numberPad)

    /// Escena "ProductoForm" de Main.storyboard; el producto llega por este init
    init?(coder: NSCoder, producto: Producto?) {
        self.producto = producto
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = producto == nil ? "Nuevo producto" : "Editar producto"
        navigationItem.largeTitleDisplayMode = .never
        campoNombre.campo.autocapitalizationType = .sentences
        campoCategoria.campo.autocapitalizationType = .words

        if let producto {
            campoNombre.campo.text = producto.nombre
            campoCategoria.campo.text = producto.categoria
            campoPrecio.campo.text = String(format: "%.2f", producto.precio)
            campoStock.campo.text = "\(producto.stock)"
        }

        pila.addArrangedSubview(UILabel.seccion("Producto"))
        pila.addArrangedSubview(campoNombre)
        pila.addArrangedSubview(campoCategoria)
        pila.addArrangedSubview(atajosCategoria())
        pila.addArrangedSubview(UILabel.seccion("Precio e inventario"))
        pila.addArrangedSubview(campoPrecio)
        pila.addArrangedSubview(campoStock)
        if let producto, producto.cantidadVentas > 0 {
            pila.addArrangedSubview(nota("Este producto tiene \(producto.cantidadVentas) venta(s): el stock baja con cada venta y vuelve al anularla."))
        }
        pila.addArrangedSubview(mensajeError)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if producto == nil { campoNombre.campo.becomeFirstResponder() }
    }

    /// Botones rápidos con las categorías que ya existen
    private func atajosCategoria() -> UIView {
        let chips = ChipsView()
        let existentes = Consultas.categorias()
        chips.configurar(titulos: existentes, seleccionado: -1)
        chips.alSeleccionar = { [weak self] indice in self?.campoCategoria.campo.text = existentes[indice] }
        chips.heightAnchor.constraint(equalToConstant: existentes.isEmpty ? 0 : 36).isActive = true
        chips.isHidden = existentes.isEmpty
        // La pila tiene margen propio: compensamos el margen interno de los chips
        let contenedor = UIView()
        chips.translatesAutoresizingMaskIntoConstraints = false
        contenedor.addSubview(chips)
        NSLayoutConstraint.activate([
            chips.topAnchor.constraint(equalTo: contenedor.topAnchor),
            chips.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor),
            chips.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: -20),
            chips.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: 20)
        ])
        contenedor.isHidden = existentes.isEmpty
        return contenedor
    }

    override func guardar() {
        let nombre = campoNombre.texto.limpio
        let categoria = campoCategoria.texto.limpio
        let precio = Double(campoPrecio.texto.replacingOccurrences(of: ",", with: "."))
        let stock = Int64(campoStock.texto.limpio)

        guard !nombre.isEmpty else { return mostrarError("Escribe el nombre del producto.") }
        guard !categoria.isEmpty else { return mostrarError("Escribe la categoría.") }
        guard let precio, precio > 0 else { return mostrarError("El precio debe ser un número mayor a 0.") }
        guard let stock, stock >= 0 else { return mostrarError("El stock debe ser un número entero (0 o más).") }

        // CREATE o UPDATE: basta cambiar las propiedades del objeto y guardar
        let objeto = producto ?? Producto(context: CoreDataStack.shared.contexto)
        objeto.nombre = nombre
        objeto.categoria = categoria
        objeto.precio = ReglasVenta.redondear(precio)
        objeto.stock = stock

        do {
            try CoreDataStack.shared.guardar()
            dismiss(animated: true)
        } catch {
            CoreDataStack.shared.contexto.rollback()
            mostrarError("No se pudo guardar: \(error.localizedDescription)")
        }
    }
}
