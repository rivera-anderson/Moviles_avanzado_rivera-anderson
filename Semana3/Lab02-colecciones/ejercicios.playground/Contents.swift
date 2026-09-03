// Desarrollado por: [TU NOMBRE]
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
