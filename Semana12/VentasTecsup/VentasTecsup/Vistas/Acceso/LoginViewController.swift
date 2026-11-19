import UIKit

/// A1 · Login
final class LoginViewController: UIViewController {
    private let campoUsuario = CampoView(titulo: "Usuario", placeholder: "usuario")
    private let campoClave = CampoView(titulo: "Clave", placeholder: "••••••", seguro: true)
    private let mensajeError = UILabel.aviso()
    private let botonIngresar = UIButton.principal("Ingresar")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fondo
        let pila = crearPilaDesplazable(espaciado: 16, margen: 28)

        // ① Logo y nombre
        let logo = UIImageView(image: UIImage(named: "LogoVentas"))
        logo.contentMode = .scaleAspectFill
        logo.layer.cornerRadius = 22
        logo.layer.cornerCurve = .continuous
        logo.clipsToBounds = true
        logo.translatesAutoresizingMaskIntoConstraints = false

        let marcoLogo = UIView()
        marcoLogo.layer.shadowColor = UIColor.marca.cgColor
        marcoLogo.layer.shadowOpacity = 0.25
        marcoLogo.layer.shadowRadius = 18
        marcoLogo.layer.shadowOffset = CGSize(width: 0, height: 10)
        marcoLogo.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: 92),
            logo.heightAnchor.constraint(equalToConstant: 92),
            logo.topAnchor.constraint(equalTo: marcoLogo.topAnchor),
            logo.bottomAnchor.constraint(equalTo: marcoLogo.bottomAnchor),
            logo.leadingAnchor.constraint(equalTo: marcoLogo.leadingAnchor),
            logo.trailingAnchor.constraint(equalTo: marcoLogo.trailingAnchor)
        ])

        let titulo = UILabel()
        titulo.text = "Ventas Tecsup"
        titulo.font = .systemFont(ofSize: 32, weight: .heavy)
        let subtitulo = UILabel()
        subtitulo.text = "Inicia sesión para continuar"
        subtitulo.font = .systemFont(ofSize: 17)
        subtitulo.textColor = .secondaryLabel

        let cabecera = UIStackView(vertical: [marcoLogo, titulo, subtitulo], espaciado: 6, alineacion: .center)
        cabecera.setCustomSpacing(22, after: marcoLogo)

        // ④ Mensaje de error genérico (no dice si falló el usuario o la clave)
        mensajeError.textColor = .systemRed
        mensajeError.textAlignment = .left
        let icono = NSTextAttachment(image: UIImage(systemName: "exclamationmark.triangle.fill")!
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal))
        let textoError = NSMutableAttributedString(string: "  ")
        textoError.append(NSAttributedString(attachment: icono))
        textoError.append(NSAttributedString(string: " Usuario o clave incorrectos"))
        mensajeError.attributedText = textoError

        // ⑥ Ir a Crear cuenta
        let botonRegistro = UIButton(type: .system)
        let textoRegistro = NSMutableAttributedString(string: "¿Primera vez? ", attributes: [
            .foregroundColor: UIColor.secondaryLabel, .font: UIFont.systemFont(ofSize: 16)
        ])
        textoRegistro.append(NSAttributedString(string: "Crear cuenta", attributes: [
            .foregroundColor: UIColor.marca, .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]))
        botonRegistro.setAttributedTitle(textoRegistro, for: .normal)

        pila.addArrangedSubview(UIView()) // pequeño aire arriba
        pila.setCustomSpacing(30, after: pila.arrangedSubviews[0])
        pila.addArrangedSubview(cabecera)
        pila.setCustomSpacing(30, after: cabecera)
        pila.setCustomSpacing(10, after: campoClave)
        pila.addArrangedSubview(campoUsuario)   // ② Usuario
        pila.addArrangedSubview(campoClave)     // ③ Clave oculta
        pila.addArrangedSubview(mensajeError)   // ④
        pila.addArrangedSubview(botonIngresar)  // ⑤ Ingresar
        pila.addArrangedSubview(botonRegistro)  // ⑥

        campoUsuario.campo.textContentType = .username
        campoUsuario.campo.returnKeyType = .next
        campoClave.campo.returnKeyType = .go
        campoUsuario.campo.delegate = self
        campoClave.campo.delegate = self

        for campo in [campoUsuario.campo, campoClave.campo] {
            campo.addAction(UIAction { [weak self] _ in self?.textoCambio() }, for: .editingChanged)
        }
        botonIngresar.addAction(UIAction { [weak self] _ in self?.ingresar() }, for: .touchUpInside)
        botonRegistro.addAction(UIAction { [weak self] _ in
            self?.performSegue(withIdentifier: "mostrarRegistro", sender: nil) // Segue del storyboard
        }, for: .touchUpInside)

        textoCambio()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backButtonTitle = "Ingresar" // "‹ Ingresar" en Crear cuenta
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func textoCambio() {
        mensajeError.isHidden = true
        botonIngresar.isEnabled = !campoUsuario.texto.limpio.isEmpty && !campoClave.texto.isEmpty
    }

    private func ingresar() {
        guard botonIngresar.isEnabled else { return }
        // Fetch con NSPredicate: usuario ==[c] %@ AND clave == %@
        guard let usuario = Consultas.login(usuario: campoUsuario.texto, clave: campoClave.texto) else {
            UIView.animate(withDuration: 0.2) { self.mensajeError.isHidden = false }
            campoClave.sacudir()
            campoUsuario.sacudir()
            return
        }
        view.endEditing(true)
        Sesion.shared.iniciar(usuario) // El SceneDelegate muestra las pestañas del rol
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == campoUsuario.campo {
            campoClave.campo.becomeFirstResponder()
        } else {
            ingresar()
        }
        return true
    }
}
