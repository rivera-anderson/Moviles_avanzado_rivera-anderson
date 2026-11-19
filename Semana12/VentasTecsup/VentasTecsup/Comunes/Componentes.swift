import UIKit

// MARK: - Círculo con iniciales

final class InicialesView: UILabel {
    init(tamano: CGFloat = 42) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        textColor = .white
        font = .systemFont(ofSize: tamano * 0.36, weight: .bold)
        layer.cornerRadius = tamano * 0.27 // Cuadrado redondeado como en la maqueta
        layer.cornerCurve = .continuous
        clipsToBounds = true
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: tamano),
            heightAnchor.constraint(equalToConstant: tamano)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func mostrar(_ texto: String) {
        attributedText = nil
        text = Formato.iniciales(texto)
        backgroundColor = Formato.colorPara(texto)
    }

    /// Símbolo blanco sobre un fondo de color (✓ venta válida, ✕ anulada)
    func mostrarIcono(_ simbolo: String, fondo: UIColor) {
        let configuracion = UIImage.SymbolConfiguration(pointSize: font.pointSize, weight: .bold)
        let imagen = UIImage(systemName: simbolo, withConfiguration: configuracion)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        attributedText = imagen.map { NSAttributedString(attachment: NSTextAttachment(image: $0)) }
        backgroundColor = fondo
    }
}

// MARK: - Insignia (etiqueta de color con fondo suave)

final class InsigniaLabel: UILabel {
    private let relleno = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)

    init() {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 11, weight: .bold)
        textAlignment = .center
        layer.cornerRadius = 9
        clipsToBounds = true
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: relleno))
    }

    override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        return CGSize(width: base.width + relleno.left + relleno.right,
                      height: base.height + relleno.top + relleno.bottom)
    }

    func mostrar(_ texto: String?, color: UIColor) {
        text = texto
        textColor = .white          // Etiqueta sólida: texto blanco sobre el color
        backgroundColor = color
        isHidden = (texto == nil)
        invalidateIntrinsicContentSize()
    }
}

// MARK: - Tarjeta redondeada con título opcional

final class TarjetaView: UIView {
    let pila = UIStackView()

    init(titulo: String? = nil, espaciado: CGFloat = 12, tituloSimple: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = .tarjeta
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous

        pila.axis = .vertical
        pila.spacing = espaciado
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            pila.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            pila.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        if let titulo {
            if tituloSimple {
                let etiqueta = UILabel()
                etiqueta.text = titulo
                etiqueta.font = .systemFont(ofSize: 14)
                etiqueta.textColor = .secondaryLabel
                pila.addArrangedSubview(etiqueta)
            } else {
                pila.addArrangedSubview(UILabel.seccion(titulo))
            }
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func agregar(_ vistas: UIView...) {
        vistas.forEach { pila.addArrangedSubview($0) }
    }
}

// MARK: - Tarjeta de indicador (título, valor grande y nota)

final class TarjetaIndicador: UIView {
    private let valor = UILabel()
    private let nota = UILabel()

    init(titulo: String, icono: String, color: UIColor = .marca) {
        super.init(frame: .zero)
        backgroundColor = .tarjeta
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous

        let imagen = UIImageView(image: UIImage(systemName: icono))
        imagen.tintColor = color
        imagen.contentMode = .scaleAspectFit
        imagen.preferredSymbolConfiguration = .init(pointSize: 13, weight: .semibold)

        let etiqueta = UILabel()
        etiqueta.text = titulo
        etiqueta.font = .systemFont(ofSize: 13, weight: .medium)
        etiqueta.textColor = .secondaryLabel
        etiqueta.adjustsFontSizeToFitWidth = true
        etiqueta.minimumScaleFactor = 0.8

        let cabecera = UIStackView(arrangedSubviews: [imagen, etiqueta])
        cabecera.spacing = 6

        valor.font = .redondeada(22, .bold)
        valor.adjustsFontSizeToFitWidth = true
        valor.minimumScaleFactor = 0.6
        valor.text = "—"

        nota.font = .systemFont(ofSize: 12, weight: .medium)
        nota.textColor = .secondaryLabel
        nota.numberOfLines = 2

        let pila = UIStackView(arrangedSubviews: [cabecera, valor, nota])
        pila.axis = .vertical
        pila.spacing = 6
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            pila.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            pila.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func mostrar(valor texto: String, nota textoNota: String?, colorNota: UIColor = .secondaryLabel) {
        valor.text = texto
        nota.text = textoNota
        nota.textColor = colorNota
    }
}

// MARK: - Campo de texto con título (login, registro y formularios)

final class CampoView: UIView {
    let campo = UITextField()
    /// Texto corto a la derecha del campo (ej. "✓ Disponible")
    let estado = UILabel()

    init(titulo: String, placeholder: String, seguro: Bool = false, teclado: UIKeyboardType = .default) {
        super.init(frame: .zero)
        backgroundColor = .tarjeta
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        let etiqueta = UILabel()
        etiqueta.text = titulo.uppercased()
        etiqueta.font = .systemFont(ofSize: 12, weight: .semibold)
        etiqueta.textColor = .secondaryLabel

        campo.placeholder = placeholder
        campo.font = .systemFont(ofSize: 17)
        campo.isSecureTextEntry = seguro
        campo.keyboardType = teclado
        campo.autocorrectionType = .no
        campo.autocapitalizationType = .none
        campo.spellCheckingType = .no
        campo.clearButtonMode = seguro ? .never : .whileEditing
        if seguro { campo.textContentType = .oneTimeCode } // Evita la sugerencia de clave del sistema

        estado.font = .systemFont(ofSize: 14, weight: .medium)
        estado.isHidden = true
        estado.setContentHuggingPriority(.required, for: .horizontal)
        estado.setContentCompressionResistancePriority(.required, for: .horizontal)
        let filaCampo = UIStackView(horizontal: [campo, estado], espaciado: 8)

        let pila = UIStackView(arrangedSubviews: [etiqueta, filaCampo])
        pila.axis = .vertical
        pila.spacing = 4
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            pila.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            pila.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            campo.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enfocar)))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    var texto: String { campo.text ?? "" }

    func mostrarEstado(_ texto: String?, color: UIColor = .systemGreen) {
        estado.text = texto
        estado.textColor = color
        estado.isHidden = texto == nil
    }

    @objc private func enfocar() { campo.becomeFirstResponder() }
}

// MARK: - Chips horizontales (categorías y vendedores)

final class ChipsView: UIView {
    var alSeleccionar: ((Int) -> Void)?
    private(set) var seleccionado = 0
    private var titulos: [String] = []
    private var botones: [UIButton] = []
    private let scroll = UIScrollView()
    private let pila = UIStackView()

    init() {
        super.init(frame: .zero)
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        pila.spacing = 8
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroll)
        scroll.addSubview(pila)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            pila.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            pila.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            pila.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func configurar(titulos nuevos: [String], seleccionado indice: Int) {
        seleccionado = indice
        if nuevos != titulos {
            titulos = nuevos
            botones.forEach { $0.removeFromSuperview() }
            botones = nuevos.indices.map { indice in
                let boton = UIButton(type: .system)
                boton.addAction(UIAction { [weak self] _ in
                    guard let self else { return }
                    seleccionado = indice
                    pintar()
                    alSeleccionar?(indice)
                }, for: .touchUpInside)
                pila.addArrangedSubview(boton)
                return boton
            }
        }
        pintar()
    }

    private func pintar() {
        for (indice, boton) in botones.enumerated() {
            let activo = indice == seleccionado
            var configuracion = activo ? UIButton.Configuration.filled() : UIButton.Configuration.gray()
            configuracion.title = titulos[indice]
            configuracion.cornerStyle = .capsule
            configuracion.baseBackgroundColor = activo ? .marca : .tarjeta
            configuracion.baseForegroundColor = activo ? .white : .label
            configuracion.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14)
            configuracion.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
                var nuevos = atributos
                nuevos.font = .systemFont(ofSize: 14, weight: activo ? .semibold : .regular)
                return nuevos
            }
            boton.configuration = configuracion
        }
    }
}

// MARK: - Gráfico de barras simple (últimos 7 días)

final class BarrasView: UIView {
    private let pila = UIStackView()

    init() {
        super.init(frame: .zero)
        pila.distribution = .fillEqually
        pila.spacing = 8
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: topAnchor),
            pila.leadingAnchor.constraint(equalTo: leadingAnchor),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor),
            pila.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func mostrar(_ datos: [(etiqueta: String, valor: Double)]) {
        pila.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let maximo = max(datos.map(\.valor).max() ?? 0, 1)

        for (indice, dato) in datos.enumerated() {
            let esUltimo = indice == datos.count - 1
            let columna = UIView()

            let carril = UIView()
            let barra = UIView()
            barra.backgroundColor = esUltimo ? .marca : UIColor.marca.withAlphaComponent(0.16)
            barra.layer.cornerRadius = 5

            let monto = UILabel()
            monto.text = esUltimo && dato.valor > 0 ? compacto(dato.valor) : ""
            monto.font = .systemFont(ofSize: 10, weight: .semibold)
            monto.textColor = .secondaryLabel
            monto.textAlignment = .center
            monto.adjustsFontSizeToFitWidth = true
            monto.minimumScaleFactor = 0.7

            let etiqueta = UILabel()
            etiqueta.text = dato.etiqueta
            etiqueta.font = .systemFont(ofSize: 11)
            etiqueta.textColor = .secondaryLabel
            etiqueta.textAlignment = .center

            [carril, barra, monto, etiqueta].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
            columna.addSubview(carril)
            carril.addSubview(barra)
            columna.addSubview(monto)
            columna.addSubview(etiqueta)

            let proporcion = CGFloat(max(dato.valor / maximo, 0.03))
            NSLayoutConstraint.activate([
                etiqueta.bottomAnchor.constraint(equalTo: columna.bottomAnchor),
                etiqueta.leadingAnchor.constraint(equalTo: columna.leadingAnchor),
                etiqueta.trailingAnchor.constraint(equalTo: columna.trailingAnchor),

                carril.topAnchor.constraint(equalTo: columna.topAnchor, constant: 18),
                carril.bottomAnchor.constraint(equalTo: etiqueta.topAnchor, constant: -6),
                carril.leadingAnchor.constraint(equalTo: columna.leadingAnchor, constant: 4),
                carril.trailingAnchor.constraint(equalTo: columna.trailingAnchor, constant: -4),

                barra.bottomAnchor.constraint(equalTo: carril.bottomAnchor),
                barra.leadingAnchor.constraint(equalTo: carril.leadingAnchor),
                barra.trailingAnchor.constraint(equalTo: carril.trailingAnchor),
                barra.heightAnchor.constraint(equalTo: carril.heightAnchor, multiplier: proporcion),

                monto.bottomAnchor.constraint(equalTo: barra.topAnchor, constant: -3),
                monto.leadingAnchor.constraint(equalTo: columna.leadingAnchor),
                monto.trailingAnchor.constraint(equalTo: columna.trailingAnchor)
            ])
            pila.addArrangedSubview(columna)
        }
    }

    /// 1250 -> "1.3k"
    private func compacto(_ valor: Double) -> String {
        valor >= 1000 ? String(format: "%.1fk", valor / 1000) : String(format: "%.0f", valor)
    }
}

// MARK: - Ayudas

extension UILabel {
    /// Título pequeño de sección ("CLIENTE", "RESUMEN"...)
    static func seccion(_ texto: String) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = texto.uppercased()
        etiqueta.font = .systemFont(ofSize: 12, weight: .semibold)
        etiqueta.textColor = .secondaryLabel
        return etiqueta
    }

    /// Texto de ayuda o aviso debajo de un campo
    static func aviso() -> UILabel {
        let etiqueta = UILabel()
        etiqueta.font = .systemFont(ofSize: 13, weight: .medium)
        etiqueta.numberOfLines = 0
        etiqueta.isHidden = true
        return etiqueta
    }
}

extension UIButton {
    /// Botón principal en forma de cápsula con el color de la marca
    static func principal(_ titulo: String, icono: String? = nil) -> UIButton {
        var configuracion = UIButton.Configuration.filled()
        configuracion.title = titulo
        configuracion.cornerStyle = .fixed
        configuracion.background.cornerRadius = 14
        configuracion.baseBackgroundColor = .marca
        configuracion.baseForegroundColor = .white
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        if let icono {
            configuracion.image = UIImage(systemName: icono)
            configuracion.imagePadding = 8
        }
        configuracion.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = .systemFont(ofSize: 17, weight: .semibold)
            return nuevos
        }
        return UIButton(configuration: configuracion)
    }
}

extension UIStackView {
    convenience init(horizontal vistas: [UIView], espaciado: CGFloat = 12, alineacion: UIStackView.Alignment = .center) {
        self.init(arrangedSubviews: vistas)
        axis = .horizontal
        spacing = espaciado
        alignment = alineacion
    }

    convenience init(vertical vistas: [UIView], espaciado: CGFloat = 4, alineacion: UIStackView.Alignment = .fill) {
        self.init(arrangedSubviews: vistas)
        axis = .vertical
        spacing = espaciado
        alignment = alineacion
    }
}

extension UIView {
    /// Espacio flexible para empujar vistas en una pila horizontal
    static func espaciador() -> UIView {
        let vista = UIView()
        vista.setContentHuggingPriority(.defaultLow, for: .horizontal)
        vista.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return vista
    }

    /// Animación de "no" (login incorrecto)
    func sacudir() {
        let animacion = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animacion.values = [-10, 10, -8, 8, -4, 4, 0]
        animacion.duration = 0.4
        layer.add(animacion, forKey: "sacudir")
    }
}

extension UIViewController {
    func mostrarAlerta(_ titulo: String, _ mensaje: String?) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Entendido", style: .cancel))
        present(alerta, animated: true)
    }

    /// Scroll vertical con una pila adentro. Se encoge cuando aparece el teclado.
    func crearPilaDesplazable(espaciado: CGFloat = 14, margen: CGFloat = 20) -> UIStackView {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.keyboardDismissMode = .interactive
        scroll.alwaysBounceVertical = true

        let pila = UIStackView()
        pila.axis = .vertical
        pila.spacing = espaciado
        pila.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scroll)
        scroll.addSubview(pila)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 12),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -28),
            pila.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: margen),
            pila.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -2 * margen)
        ])
        return pila
    }
}

extension UIBarButtonItem {
    /// Iniciales del usuario de la sesión en la barra (como "LP" o "CR" en la maqueta)
    static func inicialesSesion() -> UIBarButtonItem {
        let iniciales = Formato.iniciales(Sesion.shared.usuario?.nombreMostrado ?? "")
        let item = UIBarButtonItem(title: iniciales, style: .plain, target: nil, action: nil)
        item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .semibold)], for: .normal)
        item.isEnabled = true
        return item
    }
}
