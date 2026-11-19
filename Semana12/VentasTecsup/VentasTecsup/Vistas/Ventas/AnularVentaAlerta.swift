import UIKit

/// A8 · Anular venta: alerta con el resumen, motivo obligatorio y botón Anular
/// deshabilitado mientras el motivo esté vacío.
enum AnularVentaAlerta {

    static func crear(venta: Venta, alTerminar: @escaping (Result<Void, Error>) -> Void) -> UIAlertController {
        // ① Resumen de la venta; avisa que el stock se devolverá
        let mensaje = "\(venta.cliente?.nombre ?? "Cliente") · \(venta.producto?.nombre ?? "Producto") × \(venta.cantidad) · \(Formato.soles(venta.total))\nEl stock se devolverá (+\(venta.cantidad))."
        let alerta = UIAlertController(title: "Anular venta", message: mensaje, preferredStyle: .alert)

        // ③ Anular (empieza deshabilitado)
        let anular = UIAlertAction(title: "Anular", style: .destructive) { [weak alerta] _ in
            let motivo = alerta?.textFields?.first?.text ?? ""
            do {
                try ServicioVentas.anular(venta, motivo: motivo)
                alTerminar(.success(()))
            } catch {
                alTerminar(.failure(error))
            }
        }
        anular.isEnabled = false

        // ② Motivo obligatorio
        alerta.addTextField { campo in
            campo.placeholder = "Motivo (obligatorio)"
            campo.autocapitalizationType = .sentences
            campo.addAction(UIAction { [weak campo] _ in
                anular.isEnabled = !(campo?.text ?? "").limpio.isEmpty
            }, for: .editingChanged)
        }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(anular)
        return alerta
    }
}
