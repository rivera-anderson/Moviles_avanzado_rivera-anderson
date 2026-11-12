import SwiftUI
import UIKit
import Foundation

// MARK: - Colores de la app

extension Color {
    static let marca = Color(red: 0.059, green: 0.529, blue: 0.447)   // Verde azulado de la maqueta
    static let ambar = Color(red: 0.93, green: 0.55, blue: 0.10)
    static let fondoAgrupado = Color(uiColor: .systemGroupedBackground)
    static let fondoTarjeta = Color(uiColor: .secondarySystemGroupedBackground)
}

extension String {
    /// Texto sin espacios ni saltos de línea al inicio o al final
    var limpio: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

// MARK: - Formato de montos, fechas e iniciales

enum Formato {
    /// 7080 -> "S/ 7,080.00"
    static func soles(_ valor: Double) -> String {
        let numero = valor.formatted(
            .number.precision(.fractionLength(2)).locale(Locale(identifier: "en_US"))
        )
        return "S/ " + numero
    }

    private static let formatoDiaMes: DateFormatter = {
        let formato = DateFormatter()
        formato.dateFormat = "dd/MM"
        return formato
    }()

    /// Fecha corta "03/11"
    static func diaMes(_ fecha: Date) -> String {
        formatoDiaMes.string(from: fecha)
    }

    /// "Laptop Pro 14" -> "LP", "TecnoImport" -> "TE"
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
    static func colorPara(_ texto: String) -> Color {
        let paleta: [Color] = [.marca, .blue, .purple, .indigo, .teal, .orange, .pink, .brown]
        let suma = texto.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return paleta[suma % paleta.count]
    }

    /// Stock en color: verde más de 10, ámbar de 6 a 10, rojo 5 o menos
    static func colorStock(_ stock: Int) -> Color {
        if stock > 10 { return .green }
        if stock >= 6 { return .ambar }
        return .red
    }

    static func colorEstado(_ estado: String) -> Color {
        switch estado {
        case EstadoCompra.aprobada: return .green
        case EstadoCompra.rechazada: return .red
        default: return .ambar
        }
    }
}

// MARK: - Avatar de la sesión (menú con Cerrar sesión)

struct AvatarMenu: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        if let usuario = sesion.usuario {
            Menu {
                Section {
                    Text(usuario.nombre)
                    Text("@\(usuario.usuario) · \(usuario.rol)")
                }
                Button(role: .destructive) {
                    sesion.cerrarSesion()
                } label: {
                    Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                }
            } label: {
                Text(Formato.iniciales(usuario.nombre))
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(Color.marca))
            }
            .accessibilityLabel("Cuenta de \(usuario.nombre)")
        }
    }
}

// MARK: - Piezas pequeñas reutilizables

/// Etiqueta en forma de cápsula: "40 u.", "Pendiente", "VENCIDA"…
struct Insignia: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Capsule().fill(color))
    }
}

/// Cuadro de color con las iniciales de un producto o proveedor
struct InicialesView: View {
    let texto: String
    var lado: CGFloat = 36

    var body: some View {
        Text(Formato.iniciales(texto))
            .font(.subheadline.bold())
            .foregroundStyle(.white)
            .frame(width: lado, height: lado)
            .background(RoundedRectangle(cornerRadius: 9).fill(Formato.colorPara(texto)))
    }
}

/// Ícono según el estado de la compra
struct IconoEstado: View {
    let estado: String

    private var simbolo: String {
        switch estado {
        case EstadoCompra.aprobada: return "checkmark"
        case EstadoCompra.rechazada: return "xmark"
        default: return "hourglass"
        }
    }

    var body: some View {
        Image(systemName: simbolo)
            .font(.subheadline.bold())
            .foregroundStyle(.white)
            .frame(width: 34, height: 34)
            .background(RoundedRectangle(cornerRadius: 9).fill(Formato.colorEstado(estado)))
    }
}

/// Campo con etiqueta en mayúsculas dentro de una tarjeta (login y registro)
struct CampoTarjeta<Contenido: View, Accesorio: View>: View {
    let etiqueta: String
    let contenido: Contenido
    let accesorio: Accesorio

    init(etiqueta: String,
         @ViewBuilder contenido: () -> Contenido,
         @ViewBuilder accesorio: () -> Accesorio) {
        self.etiqueta = etiqueta
        self.contenido = contenido()
        self.accesorio = accesorio()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(etiqueta.uppercased())
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                accesorio
            }
            contenido
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.fondoTarjeta))
    }
}

extension CampoTarjeta where Accesorio == EmptyView {
    init(etiqueta: String, @ViewBuilder contenido: () -> Contenido) {
        self.init(etiqueta: etiqueta, contenido: contenido, accesorio: { EmptyView() })
    }
}

/// Tarjeta de indicador para el Resumen (B9)
struct TarjetaIndicador: View {
    let titulo: String
    let valor: String
    var detalle: String? = nil
    var colorDetalle: Color = .secondary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(valor)
                .font(.title3.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            if let detalle {
                Text(detalle)
                    .font(.caption)
                    .foregroundStyle(colorDetalle)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.fondoTarjeta))
    }
}

/// Logo de la app (misma imagen que el ícono)
struct LogoApp: View {
    var lado: CGFloat = 76

    var body: some View {
        Image("LogoCompras")
            .resizable()
            .scaledToFit()
            .frame(width: lado, height: lado)
            .clipShape(RoundedRectangle(cornerRadius: lado * 0.22, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
    }
}

/// Mensaje de error en rojo con ícono de advertencia
struct MensajeError: View {
    let texto: String

    var body: some View {
        Label(texto, systemImage: "exclamationmark.triangle.fill")
            .font(.footnote)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
