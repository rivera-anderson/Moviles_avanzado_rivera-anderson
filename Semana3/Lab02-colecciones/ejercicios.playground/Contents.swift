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
var valorTotal1 = 0.0

for (_, precio) in productos {
    valorTotal1 += precio
}

print("Valor total: S/. \(valorTotal1)")

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


// Desarrollado por:  rivera anderson


// ===== TODO 8: Eliminar duplicados =====
var Numeros: [Int] = [10, 20, 10, 30, 40, 20, 50, 30]

print("Con duplicados: \(Numeros)")

let sinDuplicados = Array(Set(Numeros)).sorted()

print("Sin duplicados: \(sinDuplicados)")

// ===== TODO 9: Comparar asistencia =====

let lunes: Set<String> = [
    "Ana",
    "Carlos",
    "Beto",
    "Maria"
]

let martes: Set<String> = [
    "Carlos",
    "Beto",
    "Luis",
    "Pedro"
]

let ambosDias = lunes.intersection(martes)
let soloLunes = lunes.subtracting(martes)
let soloMartes = martes.subtracting(lunes)

print("===== ASISTENCIA =====")
print("Ambos días: \(ambosDias)")
print("Solo lunes: \(soloLunes)")
print("Solo martes: \(soloMartes)")

let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

print(a.intersection(b)) // PREDICT 5: [4, 5]
print(a.union(b).count)  // PREDICT 6: 8
print(a.subtracting(b))  // PREDICT 7: [1, 2, 3]

var repetidos: Set = ["A", "B", "A", "C", "B"]

print(repetidos.count) // PREDICT 8: 3


// Desarrollado por: rivera anderson


// ===== TODO 10: Inventario de productos =====

var precios1: [String: Double] = [
    "Laptop": 3500,
    "Mouse": 45,
    "Teclado": 120,
    "Monitor": 800
]

var stocks: [String: Int] = [
    "Laptop": 3,
    "Mouse": 10,
    "Teclado": 2,
    "Monitor": 7
]

// ===== Calcular valor total =====
var ValorTotal2 = 0.0

for (producto, precio) in precios1 {
    if let stock = stocks[producto] {
        ValorTotal2 += precio * Double(stock)
    }
}

print("===== INVENTARIO =====")
print("Valor total del inventario: S/. \(ValorTotal2)")

// ===== Mostrar productos con stock bajo =====
print("\n===== STOCK BAJO =====")

for (producto, stock) in stocks {
    if stock < 5 {
        print("\(producto): \(stock) unidades")
    }
}
// Desarrollado por: rivera anderson
import Foundation

// ===== CARRITO DE COMPRAS 2.0 =====
var nombresCarrito: [String] = []
var preciosCarrito: [Double] = []
var cantidades: [Int] = []

// TODO 11: Pedir productos
print("¿Cuántos productos va a comprar?")
let totalProductos = Int(readLine() ?? "") ?? 0

if totalProductos > 0 {
    for i in 1...totalProductos {
        print("\nProducto \(i) - Nombre:")
        nombresCarrito.append(readLine() ?? "")
        print("Precio unitario:")
        preciosCarrito.append(Double(readLine() ?? "") ?? 0)
        print("Cantidad:")
        cantidades.append(Int(readLine() ?? "") ?? 0)
    }
}

// TODO 12: Calcular subtotales
var subtotales: [Double] = []
if nombresCarrito.count > 0 {
    for i in 0..<nombresCarrito.count {
        let sub = preciosCarrito[i] * Double(cantidades[i])
        subtotales.append(sub)
    }
}

// TODO 13: Total del carrito
var totalCarrito = 0.0
for sub in subtotales {
    totalCarrito += sub
}

// TODO 14: Nombre del cliente
print("\nNombre del cliente:")
let cliente = readLine() ?? ""

// TODO 15: Descuento
var descPct = 0.0
if totalCarrito >= 5000 { descPct = 0.15 }
else if totalCarrito >= 2000 { descPct = 0.10 }
else if totalCarrito >= 500 { descPct = 0.05 }

let descuento = totalCarrito * descPct
let totalConDesc = totalCarrito - descuento

// TODO 16: IGV y total
let igv = totalConDesc * 0.18
let totalFinal = totalConDesc + igv

// TODO 17: Categoría
var categoria = ""
switch Int(totalCarrito) {
case 0..<500: 
    categoria = "Regular"
case 500..<2000: 
    categoria = "Frecuente"
case 2000..<5000: 
    categoria = "VIP"
default: 
    categoria = "Premium"
}

// TODO 18: Ticket
let sep = String(repeating: "=", count: 45)
print(sep)
print(" TICKET DE COMPRA 2.0")
print(" Cliente: \(cliente) (\(categoria))")
print(sep)
for i in 0..<nombresCarrito.count {
    print("\(nombresCarrito[i]) x\(cantidades[i]) S/. \(subtotales[i])")
}
print(sep)
print("Subtotal: S/. \(totalCarrito)")
if descPct > 0 {
    print("Descuento (\(descPct * 100)%): -S/. \(descuento)")
}
print("IGV (18%): S/. \(igv)")
print(sep)
print("TOTAL: S/. \(totalFinal)")
print(sep)
print("¡Gracias por su compra, \(cliente)!")