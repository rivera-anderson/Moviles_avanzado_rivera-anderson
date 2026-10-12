//
//  VentasModel.swift
//  VentasApp
//
//  Created by Tecsup on 1/10/26.
//

import Foundation

class VentaModel: NSObject {
    var subtotal: Double = 0.0
    var igv: Double = 0.0
    var montoBase: Double = 0.0
    var interesesTotales: Double = 0.0
    var totalAPagar: Double = 0.0
    var cuotaMensual: Double = 0.0
    
    init(subtotal: Double, igv: Double, montoBase: Double, interesesTotales: Double, totalAPagar: Double, cuotaMensual: Double) {
        self.subtotal = subtotal
        self.igv = igv
        self.montoBase = montoBase
        self.interesesTotales = interesesTotales
        self.totalAPagar = totalAPagar
        self.cuotaMensual = cuotaMensual
    }
}
