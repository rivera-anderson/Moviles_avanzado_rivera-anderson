//
//  NuevaVentaViewController.swift
//  VentasApp
//
//  Created by Tecsup on 1/10/26.
//

import UIKit

class NuevaVentaViewController: UIViewController {

    // 1. OUTLETS DE ENTRADA (Conectar a los 5 campos de texto)
    
    @IBOutlet weak var tfNombreProducto: UITextField!
    
    @IBOutlet weak var tfPrecioUnitario: UITextField!
    
    
    @IBOutlet weak var tfCantidad: UITextField!
    
    
    @IBOutlet weak var tfMeses: UITextField!
    
    @IBOutlet weak var tfTasaInteres: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 2. PASO DE DATOS Y CÁLCULOS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            // Obtener valores numéricos ingresados por el usuario
            let precio = Double(tfPrecioUnitario.text ?? "") ?? 0.0
            let cantidad = Double(tfCantidad.text ?? "") ?? 0.0
            let meses = Double(tfMeses.text ?? "") ?? 0.0
            let tasaMensual = (Double(tfTasaInteres.text ?? "") ?? 0.0) / 100.0 // Porcentaje a decimal

            // Aplicar las fórmulas solicitadas
            let subtotalCalculado = precio * cantidad
            let igvCalculado = subtotalCalculado * 0.18
            let baseCalculada = subtotalCalculado + igvCalculado
            let interesesCalculados = baseCalculada * tasaMensual * meses
            let totalCalculado = baseCalculada + interesesCalculados
            let cuotaCalculada = meses > 0 ? (totalCalculado / meses) : 0.0

            // Empaquetar todo dentro del modelo VentaModel
            let oVenta = VentaModel(
                subtotal: subtotalCalculado,
                igv: igvCalculado,
                montoBase: baseCalculada,
                interesesTotales: interesesCalculados,
                totalAPagar: totalCalculado,
                cuotaMensual: cuotaCalculada
            )

            // Pasar el objeto al controlador de destino (Resultado)
            let destinoVC = segue.destination as! ResultadoViewController
            destinoVC.oVentaModel = oVenta
        }
    }
}
