import UIKit
import CoreData

/// A2 · Crear cuenta
final class RegistroViewController: UIViewController {
    private let campoNombre = CampoView(titulo: "Nombre completo", placeholder: "Ej. Lucía Paredes")
    private let campoUsuario = CampoView(titulo: "Usuario", placeholder: "Ej. lparedes")
    private let campoClave = CampoView(titulo: "Clave (mínimo 6 caracteres)", placeholder: "••••••", seguro: true)
    private let campoConfirmar = CampoView(titulo: "Confirmar clave", placeholder: "••••••", seguro: true)
    private let avisoClave = UILabel.aviso()
    private let selectorRol = UISegmentedControl(items: Rol.todos)
    private let mensajeError = UILabel.aviso()
    private let botonRegistrar = UIButton.principal("Registrarme")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta" // ① Título (el botón "‹ Ingresar" vuelve al login)
        view.backgroundColor = .fondo
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false

        let pila = crearPilaDesplazable(espaciado: 12)

        campoNombre.campo.autocapitalizationType = .words
        campoNombre.campo.textContentType = .name
        selectorRol.selectedSegmentIndex = 0
        selectorRol.heightAnchor.constraint(equalToConstant: 34).isActive = true
        mensajeError.textColor = .systemRed
        mensajeError.textAlignment = .center

        let pie = UILabel()
        pie.text = "Al registrarte entrarás directamente a la app con las pestañas de tu rol."
        pie.font = .systemFont(ofSize: 13)
        pie.textColor = .secondaryLabel
        pie.textAlignment = .center
        pie.numberOfLines = 0

        pila.addArrangedSubview(campoNombre)     // ② Nombre completo
        pila.addArrangedSubview(campoUsuario)    // ③ Usuario único, con aviso si ya existe
        pila.addArrangedSubview(campoClave)      // ④ Clave (mínimo 6)
        pila.addArrangedSubview(campoConfirmar)  //    y su confirmación
        pila.addArrangedSubview(avisoClave)
        let tituloRol = UILabel.seccion("Tu rol")
        pila.addArrangedSubview(tituloRol)       // ⑤ Rol: Vendedor o Supervisor
        pila.setCustomSpacing(18, after: pila.arrangedSubviews[pila.arrangedSubviews.count - 2])
        pila.setCustomSpacing(8, after: tituloRol)
        pila.addArrangedSubview(selectorRol)
        pila.setCustomSpacing(20, after: selectorRol)
        pila.addArrangedSubview(mensajeError)
        pila.addArrangedSubview(botonRegistrar)  // ⑥ Registrarme
        pila.setCustomSpacing(16, after: botonRegistrar)
        pila.addArrangedSubview(pie)

        campoUsuario.campo.addAction(UIAction { [weak self] _ in self?.revisarUsuario() }, for: .editingChanged)
        for campo in [campoNombre.campo, campoClave.campo, campoConfirmar.campo] {
            campo.addAction(UIAction { [weak self] _ in self?.revisarClaves() }, for: .editingChanged)
        }
        botonRegistrar.addAction(UIAction { [weak self] _ in self?.registrar() }, for: .touchUpInside)
        actualizarBoton()
    }

    private var rolElegido: String { Rol.todos[selectorRol.selectedSegmentIndex] }

    /// ③ Aviso en vivo dentro del campo: FetchRequest con "usuario ==[c] %@"
    private func revisarUsuario() {
        let texto = campoUsuario.texto.limpio
        mensajeError.isHidden = true
        if texto.isEmpty {
            campoUsuario.mostrarEstado(nil)
        } else if Consultas.usuarioExiste(texto) {
            campoUsuario.mostrarEstado("✕ Ya existe", color: .systemRed)
        } else {
            campoUsuario.mostrarEstado("✓ Disponible", color: .systemGreen)
        }
        actualizarBoton()
    }

    private func revisarClaves() {
        let clave = campoClave.texto
        let confirmar = campoConfirmar.texto
        mensajeError.isHidden = true
        if clave.isEmpty {
            avisoClave.isHidden = true
        } else if clave.count < 6 {
            mostrarAviso("La clave debe tener mínimo 6 caracteres (van \(clave.count)).", color: .ambar)
        } else if confirmar.isEmpty {
            avisoClave.isHidden = true
        } else if clave != confirmar {
            mostrarAviso("✕ Las claves no coinciden", color: .systemRed)
        } else {
            mostrarAviso("✓ Las claves coinciden", color: .systemGreen)
        }
        actualizarBoton()
    }

    private func mostrarAviso(_ texto: String, color: UIColor) {
        avisoClave.text = "  " + texto
        avisoClave.textColor = color
        avisoClave.isHidden = false
    }

    private func actualizarBoton() {
        botonRegistrar.isEnabled = [campoNombre, campoUsuario, campoClave, campoConfirmar]
            .allSatisfy { !$0.texto.limpio.isEmpty }
    }

    private func registrar() {
        view.endEditing(true)
        let nombre = campoNombre.texto.limpio
        let usuario = campoUsuario.texto.limpio.lowercased()
        let clave = campoClave.texto

        // Validaciones del registro
        guard !nombre.isEmpty, !usuario.isEmpty else { return error("Completa nombre y usuario.") }
        guard !usuario.contains(" ") else { return error("El usuario no puede tener espacios.") }
        guard !Consultas.usuarioExiste(usuario) else { return error("El usuario “\(usuario)” ya existe. Elige otro.") }
        guard clave.count >= 6 else { return error("La clave debe tener mínimo 6 caracteres.") }
        guard clave == campoConfirmar.texto else { return error("La clave y su confirmación no coinciden.") }

        let nuevo = Usuario(context: CoreDataStack.shared.contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario // Se guarda en minúsculas
        nuevo.clave = clave     // Práctica: texto plano (en una app real se guarda un hash)
        nuevo.rol = rolElegido

        do {
            try CoreDataStack.shared.guardar()
            Sesion.shared.iniciar(nuevo) // Entra directo a la app
        } catch {
            CoreDataStack.shared.contexto.rollback()
            self.error("No se pudo crear la cuenta: \(error.localizedDescription)")
        }
    }

    private func error(_ texto: String) {
        mensajeError.text = texto
        mensajeError.isHidden = false
        mensajeError.sacudir()
    }
}
