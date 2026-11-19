import UIKit

// MARK: - Colores de la app

extension UIColor {
    /// Azul de la marca Ventas
    static let marca = UIColor(red: 0.176, green: 0.420, blue: 0.957, alpha: 1)
    static let ambar = UIColor(red: 0.93, green: 0.55, blue: 0.10, alpha: 1)
    static let fondo = UIColor.systemGroupedBackground
    static let tarjeta = UIColor.secondarySystemGroupedBackground
}

extension UIFont {
    /// Fuente redondeada para montos
    static func redondeada(_ tamano: CGFloat, _ peso: UIFont.Weight) -> UIFont {
        let base = UIFont.systemFont(ofSize: tamano, weight: peso)
        guard let descriptor = base.fontDescriptor.withDesign(.rounded) else { return base }
        return UIFont(descriptor: descriptor, size: tamano)
    }
}

extension String {
    /// Texto sin espacios ni saltos de línea al inicio o al final
    var limpio: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

// MARK: - Formato de montos, fechas e iniciales

enum Formato {
    private static let numero: NumberFormatter = {
        let formato = NumberFormatter()
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        formato.locale = Locale(identifier: "en_US")
        return formato
    }()

    /// 424.8 -> "S/ 424.80"
    static func soles(_ valor: Double) -> String {
        "S/ " + (numero.string(from: NSNumber(value: valor)) ?? "0.00")
    }

    private static func formateador(_ patron: String) -> DateFormatter {
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_PE")
        formato.dateFormat = patron
        return formato
    }

    private static let formatoFechaHora = formateador("dd/MM · HH:mm")
    private static let formatoLargo = formateador("EEEE d 'de' MMMM")

    /// "19/11 · 10:30"
    static func fechaHora(_ fecha: Date?) -> String {
        guard let fecha else { return "—" }
        return formatoFechaHora.string(from: fecha)
    }

    private static let formatoCorto = formateador("dd/MM")

    /// "03/11"
    static func fechaCorta(_ fecha: Date?) -> String {
        guard let fecha else { return "—" }
        return formatoCorto.string(from: fecha)
    }

    /// Letra del día como en la maqueta: L M X J V S D
    static func letraDia(_ fecha: Date) -> String {
        ["D", "L", "M", "X", "J", "V", "S"][Calendar.current.component(.weekday, from: fecha) - 1]
    }

    /// 8 dígitos = DNI, 11 dígitos = RUC
    static func documento(_ numero: String?) -> String {
        let texto = numero ?? ""
        return (texto.count == 11 ? "RUC " : "DNI ") + texto
    }

    /// "Martes 3 de noviembre"
    static func fechaSaludo(_ fecha: Date) -> String {
        let texto = formatoLargo.string(from: fecha)
        return texto.prefix(1).uppercased() + texto.dropFirst()
    }

    /// "miércoles 19 de noviembre"
    static func fechaLarga(_ fecha: Date) -> String {
        formatoLargo.string(from: fecha)
    }

    /// "Corporación Andina" -> "CA", "Mouse" -> "MO"
    static func iniciales(_ texto: String) -> String {
        let palabras = texto.split(separator: " ").filter { $0.first?.isLetter ?? false }
        let letras: String
        if palabras.count >= 2 {
            letras = palabras.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        } else {
            letras = String(texto.prefix(2))
        }
        return letras.isEmpty ? "?" : letras.uppercased()
    }

    /// Color fijo para cada nombre (el mismo nombre siempre tiene el mismo color)
    static func colorPara(_ texto: String) -> UIColor {
        let paleta: [UIColor] = [.marca, .systemIndigo, .systemPurple, .systemTeal,
                                 .systemOrange, .systemPink, .systemGreen, .systemBrown]
        let suma = texto.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return paleta[suma % paleta.count]
    }

    /// Stock en color: verde más de 10, ámbar de 6 a 10, rojo 5 o menos
    static func colorStock(_ stock: Int64) -> UIColor {
        if stock > 10 { return .systemGreen }
        if stock >= 6 { return .ambar }
        return .systemRed
    }
}
