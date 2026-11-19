import UIKit
import CoreData

/// A9 · Resumen del supervisor
final class ResumenViewController: UIViewController {
    private let fecha = UILabel()
    private let saludo = UILabel()
    private let insigniaRol = InsigniaLabel()
    private let vendidoHoy = TarjetaMonto(titulo: "Vendido hoy")
    private let igvMes = TarjetaMonto(titulo: "IGV del mes")
    private let barras = BarrasView()
    private let pilaRanking = UIStackView(vertical: [], espaciado: 14)
    private let pilaStockBajo = UIStackView(vertical: [], espaciado: 12)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        view.backgroundColor = .fondo
        let pila = crearPilaDesplazable(espaciado: 14)

        // ① Saludo con nombre y rol
        fecha.font = .systemFont(ofSize: 14)
        fecha.textColor = .secondaryLabel
        saludo.font = .systemFont(ofSize: 28, weight: .bold)
        let textos = UIStackView(vertical: [fecha, saludo], espaciado: 2)
        let filaRol = UIStackView(vertical: [insigniaRol, UIView()], espaciado: 0, alineacion: .trailing)
        pila.addArrangedSubview(UIStackView(horizontal: [textos, UIView.espaciador(), filaRol], alineacion: .fill))

        // ② Indicadores: vendido hoy (vs ayer) e IGV del mes
        let indicadores = UIStackView(horizontal: [vendidoHoy, igvMes], espaciado: 12, alineacion: .fill)
        indicadores.distribution = .fillEqually
        pila.addArrangedSubview(indicadores)

        // ③ Gráfico de barras de los últimos 7 días
        let tarjetaGrafico = TarjetaView(titulo: "Ventas de los últimos 7 días (S/)", espaciado: 12, tituloSimple: true)
        tarjetaGrafico.agregar(barras)
        pila.addArrangedSubview(tarjetaGrafico)

        // ④ Ranking de vendedores del mes
        let tarjetaRanking = TarjetaView(titulo: "Ranking de vendedores (mes)", espaciado: 12, tituloSimple: true)
        tarjetaRanking.agregar(pilaRanking)
        pila.addArrangedSubview(tarjetaRanking)

        // ⑤ Productos con stock bajo
        let tarjetaStock = TarjetaView(titulo: "Stock bajo (≤ 5)", espaciado: 10, tituloSimple: true)
        tarjetaStock.agregar(pilaStockBajo)
        pila.addArrangedSubview(tarjetaStock)

        NotificationCenter.default.addObserver(self, selector: #selector(datosGuardados),
                                               name: .NSManagedObjectContextDidSave,
                                               object: CoreDataStack.shared.contexto)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated) // La maqueta no tiene barra
        recargar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func datosGuardados() { recargar() }

    private func recargar() {
        guard let usuario = Sesion.shared.usuario else { return }
        fecha.text = Formato.fechaSaludo(Date())
        saludo.text = "Hola, \(usuario.primerNombre)"
        insigniaRol.mostrar(usuario.rol, color: .systemPurple)

        // Vendido hoy comparado con ayer (solo ventas no anuladas)
        let hoy = Consultas.totales(en: Fechas.hoy()).importe
        let ayer = Consultas.totales(en: Fechas.ayer()).importe
        let comparacion = comparar(hoy, ayer)
        vendidoHoy.mostrar(Formato.soles(hoy), nota: comparacion.texto, colorNota: comparacion.color)

        // IGV del mes = suma del IGV de las ventas no anuladas del mes
        igvMes.mostrar(Formato.soles(Consultas.igvDelMes()), nota: " ")

        let dias = Consultas.ultimos7Dias()
        barras.mostrar(dias.map { (Formato.letraDia($0.dia), $0.importe) })

        armarRanking()
        armarStockBajo()
    }

    /// "▲ 12% vs ayer" en verde o "▼ 8% vs ayer" en rojo
    private func comparar(_ actual: Double, _ anterior: Double) -> (texto: String, color: UIColor) {
        if actual == 0 && anterior == 0 { return ("Igual que ayer", .secondaryLabel) }
        if anterior == 0 { return ("▲ ayer sin ventas", .systemGreen) }
        let porcentaje = Int(((actual - anterior) / anterior * 100).rounded())
        if porcentaje > 0 { return ("▲ \(porcentaje)% vs ayer", .systemGreen) }
        if porcentaje < 0 { return ("▼ \(abs(porcentaje))% vs ayer", .systemRed) }
        return ("Igual que ayer", .secondaryLabel)
    }

    /// Nombre · monto y una barra proporcional al mejor vendedor
    private func armarRanking() {
        pilaRanking.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let ranking = Consultas.rankingDelMes()
        guard let mejor = ranking.first?.importe, mejor > 0 else {
            pilaRanking.addArrangedSubview(textoGris("Todavía no hay ventas este mes."))
            return
        }
        for item in ranking.prefix(5) {
            let texto = NSMutableAttributedString(string: item.vendedor.nombreMostrado, attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold), .foregroundColor: UIColor.label
            ])
            texto.append(NSAttributedString(string: " · \(Formato.soles(item.importe))", attributes: [
                .font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.secondaryLabel
            ]))
            let etiqueta = UILabel()
            etiqueta.attributedText = texto

            let barra = UIProgressView(progressViewStyle: .default)
            barra.progressTintColor = .marca
            barra.trackTintColor = .systemGray5
            barra.progress = Float(item.importe / mejor)
            barra.transform = CGAffineTransform(scaleX: 1, y: 2)

            pilaRanking.addArrangedSubview(UIStackView(vertical: [etiqueta, barra], espaciado: 8))
        }
    }

    private func armarStockBajo() {
        pilaStockBajo.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let productos = Consultas.productosStockBajo()
        guard !productos.isEmpty else {
            pilaStockBajo.addArrangedSubview(textoGris("Ningún producto con stock bajo."))
            return
        }
        for producto in productos {
            let nombre = UILabel()
            nombre.text = "\(producto.nombre ?? "") · \(producto.stock) u."
            nombre.font = .systemFont(ofSize: 17, weight: .semibold)
            nombre.numberOfLines = 0
            let reponer = InsigniaLabel()
            reponer.mostrar("Reponer", color: .systemRed)
            pilaStockBajo.addArrangedSubview(UIStackView(horizontal: [nombre, UIView.espaciador(), reponer]))
        }
    }

    private func textoGris(_ texto: String) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.font = .systemFont(ofSize: 15)
        etiqueta.textColor = .secondaryLabel
        return etiqueta
    }
}
