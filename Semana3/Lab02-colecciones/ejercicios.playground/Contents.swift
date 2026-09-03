// Desarrollado por: rivera anderson
import Foundation

// ===== TODO 1: Registro de 5 alumnos =====
var alumnos: [String] = ["Ana", "Carlos", "Beto", "Maria", "Luis"]

print("Alumnos: \(alumnos)")

// ===== TODO 2: Buscar un alumno =====
let buscar = "Carlos"

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// ===== TODO 3: Notas con clasificación =====
var notasClase: [Double] = [15, 18, 12, 14, 10]

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota
    
    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")
// ===== FIX: 3 errores =====
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Fresa")

var colores = ["Rojo", "Azul", "Verde"]
colores.append("Amarillo")

let numeros = [10, 20, 30, 40, 50]
print(numeros[4])
// ===== Predict ====

var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
lista.append(6)

print(lista)       // [2, 3, 4, 5, 6]
print(lista.count) // 5

var nombres = ["Ana", "Carlos", "Beto"]

print(nombres.sorted()) // ["Ana", "Beto", "Carlos"]
print(nombres)          // ["Ana", "Carlos", "Beto"]


// Desarrollado por: rivera anderson
import Foundation

// ===== TODO 4: Catálogo de productos =====
var productos: [String: Double] = [
    "Laptop": 3500,
    "Mouse": 45,
    "Teclado": 120,
    "Monitor": 800
]

// ===== TODO 5: Mostrar catálogo =====
print("===== CATÁLOGO =====")

for (nombre, precio) in productos {
    print("\(nombre): S/. \(precio)")
}

// ===== TODO 6: Valor total =====
var valorTotal = 0.0

for (_, precio) in productos {
    valorTotal += precio
}

print("Valor total: S/. \(valorTotal)")

// ===== TODO 7: Buscar producto =====
let buscarProd = "Laptop"

if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)")
} else {
    print("Producto no encontrado")
}

var edades: [String: Int] = [
    "Ana": 20,
    "Luis": 22,
    "María": 19
]

var mayores: [String] = []

for (nombre, edad) in edades {
    if edad >= 21 {
        mayores.append(nombre)
    }
}

print("Mayores de 21: \(mayores)")

// ¿Qué hace?
// Busca las personas que tienen 21 años o más.

// ¿Qué imprime?
// Mayores de 21: ["Luis"]

