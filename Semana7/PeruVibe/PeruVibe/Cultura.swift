//
//  Cultura.swift
//  PeruVibe
//
//  Created by Tecsup on 15/10/26.
//

import UIKit

import Foundation

// Definición de Lugar como NSObject
class Lugar: NSObject {
    var nombre: String
    var region: String
    var descripcion: String
    var imagenNombre: String

    init(nombre: String, region: String, descripcion: String, imagenNombre: String) {
        self.nombre = nombre
        self.region = region
        self.descripcion = descripcion
        self.imagenNombre = imagenNombre
    }
}

// Definición de Cultura como NSObject
class Cultura: NSObject {
    var nombre: String
    var region: String
    var imagenNombre: String
    var lugares: [Lugar]

    init(nombre: String, region: String, imagenNombre: String, lugares: [Lugar]) {
        self.nombre = nombre
        self.region = region
        self.imagenNombre = imagenNombre
        self.lugares = lugares
    }
}
