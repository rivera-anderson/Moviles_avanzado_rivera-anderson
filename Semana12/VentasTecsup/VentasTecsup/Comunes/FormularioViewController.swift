import UIKit

/// Base de los formularios modales (producto y cliente): Cancelar / Guardar y una pila de campos
class FormularioViewController: UIViewController {
    private(set) var pila = UIStackView()
    let mensajeError = UILabel.aviso()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fondo
        pila = crearPilaDesplazable(espaciado: 14)
        mensajeError.textColor = .systemRed

        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        })
        let botonGuardar = UIBarButtonItem(title: "Guardar", primaryAction: UIAction { [weak self] _ in
            self?.guardar()
        })
        botonGuardar.style = .done
        navigationItem.rightBarButtonItem = botonGuardar
    }

    /// Cada formulario valida y guarda aquí
    func guardar() {}

    func mostrarError(_ texto: String?) {
        mensajeError.text = texto
        mensajeError.isHidden = texto == nil
        if texto != nil { mensajeError.sacudir() }
    }

    /// Nota gris debajo de un grupo de campos
    func nota(_ texto: String) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.font = .systemFont(ofSize: 13)
        etiqueta.textColor = .secondaryLabel
        etiqueta.numberOfLines = 0
        return etiqueta
    }
}
