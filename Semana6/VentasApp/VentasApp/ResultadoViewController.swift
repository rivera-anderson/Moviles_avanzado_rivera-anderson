//
//  ResultadoViewController.swift
//  VentasApp
//
//  Created by Tecsup on 1/10/26.
//

import UIKit
class ResultadoViewController: UIViewController {

    // Variable donde recibiremos la información del modelo
    var oVentaModel: VentaModel?

    // OUTLETS DE SALIDA (Conectar a los 6 Labels de resultado)

    @IBOutlet weak var lblSubtotal: UILabel!
    
    @IBOutlet weak var lblIgv: UILabel!
    
    
    @IBOutlet weak var lblMontoBase: UILabel!
    
    
    @IBOutlet weak var lblIntereses: UILabel!
    
    
    @IBOutlet weak var lblTotal: UILabel!
    
    
    
    @IBOutlet weak var lblCuota: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Mostrar los datos formateados a soles
        if let venta = oVentaModel {
            lblSubtotal.text = String(format: "S/. %.2f", venta.subtotal)
            lblIgv.text = String(format: "S/. %.2f", venta.igv)
            lblMontoBase.text = String(format: "S/. %.2f", venta.montoBase)
            lblIntereses.text = String(format: "S/. %.2f", venta.interesesTotales)
            lblTotal.text = String(format: "S/. %.2f", venta.totalAPagar)
            lblCuota.text = String(format: "S/. %.2f", venta.cuotaMensual)
        }
    }

    // ACCIÓN DEL BOTÓN VOLVER
    @IBAction func btnVolver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
