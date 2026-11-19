import UIKit

/// Celda reutilizable: iniciales · título/subtítulo · monto · insignia.
/// La usan Productos, Clientes, Mis ventas y Ventas del equipo.
final class FilaCell: UITableViewCell {
    static let id = "FilaCell"

    /// Qué se muestra a la izquierda
    enum Icono {
        case iniciales(String)
        case simbolo(String, fondo: UIColor)
    }

    private let iniciales = InicialesView(tamano: 40)
    private let titulo = UILabel()
    private let subtitulo = UILabel()
    private let detalle = UILabel()
    private let insigniaAbajo = InsigniaLabel()
    private let valor = UILabel()
    private let valorSub = UILabel()
    private let insignia = InsigniaLabel()
    private let pilaValores = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titulo.font = .systemFont(ofSize: 17, weight: .semibold)
        subtitulo.font = .systemFont(ofSize: 14)
        subtitulo.textColor = .secondaryLabel
        detalle.font = .systemFont(ofSize: 12)
        detalle.textColor = .secondaryLabel
        detalle.numberOfLines = 2
        valor.font = .systemFont(ofSize: 16, weight: .semibold)
        valor.textAlignment = .right
        valorSub.font = .systemFont(ofSize: 12)
        valorSub.textColor = .secondaryLabel
        valorSub.textAlignment = .right

        // La insignia de abajo ("Anulada") va alineada a la izquierda bajo el subtítulo
        let filaInsigniaAbajo = UIStackView(horizontal: [insigniaAbajo, UIView.espaciador()], espaciado: 0)
        let textos = UIStackView(vertical: [titulo, subtitulo, detalle, filaInsigniaAbajo], espaciado: 2)
        textos.setCustomSpacing(4, after: detalle)
        textos.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textos.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        pilaValores.axis = .vertical
        pilaValores.alignment = .trailing
        pilaValores.spacing = 1
        pilaValores.addArrangedSubview(valor)
        pilaValores.addArrangedSubview(valorSub)
        pilaValores.setContentHuggingPriority(.required, for: .horizontal)
        pilaValores.setContentCompressionResistancePriority(.required, for: .horizontal)
        valor.setContentCompressionResistancePriority(.required, for: .horizontal)

        let fila = UIStackView(horizontal: [iniciales, textos, pilaValores, insignia], espaciado: 12)
        fila.setCustomSpacing(10, after: pilaValores)
        fila.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fila)
        NSLayoutConstraint.activate([
            fila.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            fila.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            fila.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            fila.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
        selectionStyle = .none
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func configurar(icono: Icono,
                    titulo textoTitulo: String,
                    subtitulo textoSubtitulo: String? = nil,
                    detalle textoDetalle: String? = nil,
                    valor textoValor: String? = nil,
                    valorSub textoValorSub: String? = nil,
                    insignia datosInsignia: (texto: String, color: UIColor)? = nil,
                    insigniaAbajo datosAbajo: (texto: String, color: UIColor)? = nil,
                    tachado: Bool = false) {
        switch icono {
        case .iniciales(let texto): iniciales.mostrar(texto)
        case .simbolo(let simbolo, let fondo): iniciales.mostrarIcono(simbolo, fondo: fondo)
        }

        // Venta anulada: texto en gris y monto tachado
        titulo.text = textoTitulo
        titulo.textColor = tachado ? .secondaryLabel : .label
        var atributos: [NSAttributedString.Key: Any] = [.foregroundColor: tachado ? UIColor.secondaryLabel : UIColor.label]
        if tachado { atributos[.strikethroughStyle] = NSUnderlineStyle.single.rawValue }
        valor.attributedText = NSAttributedString(string: textoValor ?? "", attributes: atributos)

        subtitulo.text = textoSubtitulo
        subtitulo.isHidden = textoSubtitulo == nil
        detalle.text = textoDetalle
        detalle.isHidden = textoDetalle == nil
        valorSub.text = textoValorSub
        valorSub.isHidden = textoValorSub == nil
        pilaValores.isHidden = textoValor == nil

        insignia.mostrar(datosInsignia?.texto, color: datosInsignia?.color ?? .clear)
        insigniaAbajo.mostrar(datosAbajo?.texto, color: datosAbajo?.color ?? .clear)
        insigniaAbajo.superview?.isHidden = datosAbajo == nil
    }
}
