
import AppKit
// ===== EJERCICIO 1: CONDICIONALES =====
let nota = 15.0
if nota >= 13.0 {
   print("Aprobado con \(nota)")
} else {
   print("Desaprobado con \(nota)")
}
// --- TODO 1: Validar si una persona es mayor de edad ---
let edad = 17
if edad >= 18 {
   print("Es mayor de edad")
} else {
   print("Es menor de edad")
}
// --- TODO 2: Clasificar una nota con else if ---
let miNota = 16.0
if miNota >= 18 {
   print("Excelente")
} else if miNota >= 15 {
   print("Bueno")
} else if miNota >= 13 {
   print("Aprobado")
} else {
   print("Desaprobado")
}
// --- TODO 3: Verificar si un número es positivo, negativo o cero ---
let numero = -5
if numero > 0 {
   print("Positivo")
} else if numero < 0 {
   print("Negativo")
} else {
   print("Cero")
}
// ===== FIX: Encuentra y corrige los 3 errores =====
let temperatura = 35
if temperatura > 30 {
   print("Hace calor")
} else if temperatura > 20 { // FIX 1: Faltaba abrir la llave {
   print("Clima agradable")
} else {
   print("Hace frío")
}
let saldo = 100.0
let compra = 150.0
if saldo >= compra { // FIX 2: Era >= para que la compra se pueda realizar
   print("Compra realizada")
} else {
   // FIX 3: El cálculo era compra - saldo para que no dé negativo
   print("Saldo insuficiente: te faltan \(compra - saldo)")
}
let hora = 25
if hora >= 0 && hora < 12 {
   print("Buenos días")
} else if hora >= 12 && hora < 18 {
   print("Buenas tardes")
} else if hora >= 18 && hora <= 23 {
   print("Buenas noches")
} else {
   print("Hora inválida")
}

// 1.3 Predicciones

import Foundation

// PREDICT 1
let x = 10
if x > 5 && x < 20 {
    print("Dentro del rango")
} else {
    print("Fuera del rango")
}

// PREDICT 2
let y = 15
if y > 20 {
    print("Mayor que 20")
} else if y > 10 {
    print("Mayor que 10")
} else if y > 5 {
    print("Mayor que 5")
}

// PREDICT 3
let esLunes = true
let llueve = false
if esLunes && llueve {
    print("Lunes lluvioso")
} else if esLunes || llueve {
    print("Es lunes O llueve")
} else {
    print("Ni lunes ni llueve")
}
// PREDICT 1: Imprime "Dentro del rango"
// PREDICT 2: Imprime "Mayor que 10" (No imprime el 5 porque en un if/else if, al cumplirse la primera condición verdadera, se sale de toda la estructura).
// PREDICT 3: Imprime "Es lunes O llueve"
// ===== EJERCICIO 2: SWITCH =====
let diaSemana = 3
switch diaSemana {
case 1: print("Lunes")
case 2: print("Martes")
case 3: print("Miércoles")
case 4: print("Jueves")
case 5: print("Viernes")
case 6: print("Sábado")
case 7: print("Domingo")
default: print("Día inválido")
}
// --- TODO 4: Clasificar nota numérica a letra ---
let notaSwitch = 16
switch notaSwitch {
case 18...20: print("A")
case 15...17: print("B")
case 13...14: print("C")
case 11...12: print("D")
case 0...10: print("F")
default: print("Nota inválida")
}
// --- TODO 5: Calculadora simple con switch ---
let num1 = 20.0
let num2 = 5.0
let operacion = "+"
switch operacion {
case "+": print("Resultado: \(num1 + num2)")
case "-": print("Resultado: \(num1 - num2)")
case "*": print("Resultado: \(num1 * num2)")
case "/":
   if num2 != 0 {
       print("Resultado: \(num1 / num2)")
   } else {
       print("Error: División por cero")
   }
default: print("Operación no válida")
}
// --- TODO 6: Categoría de producto por precio ---
let precio = 350.0
switch precio {
case 0..<100: print("Económico")
case 100..<500: print("Medio")
case 500..<1000: print("Premium")
case 1000...: print("Lujo")
default: print("Precio inválido")
}
// PREDICT: ¿Qué imprime?
let mes = 2
switch mes {
case 1, 3, 5, 7, 8, 10, 12: print("31 días")
case 4, 6, 9, 11: print("30 días")
case 2: print("28 o 29 días")
default: print("Mes inválido")
} // PREDICT 4: 28 o 29 días

let letra: Character = "a"
switch letra {
case "a", "e", "i", "o", "u": print("Vocal")
default: print("Consonante")
} // PREDICT 5: Vocal


// ===== EJERCICIO 3: FOR-IN =====
for i in 1...5 {
   print("Número: \(i)")
}
// --- TODO 7: Tabla de multiplicar del 7 ---
for i in 1...12 {
   print("7 x \(i) = \(7 * i)")
}
// --- TODO 8: Sumatoria del 1 al 100 ---
var suma = 0
for i in 1...100 {
   suma = suma + i
}
print("La suma del 1 al 100 es: \(suma)")
// --- TODO 9: Calcular el factorial de 8 ---
var factorial = 1
for i in 1...8 {
   factorial = factorial * i
}
print("8! = \(factorial)")
// --- TODO 10: Patrón de asteriscos ---
for i in 1...5 {
   print(String(repeating: "*", count: i))
}
// ===== FIX: Encuentra los 2 errores =====
for i in 1...20 {
   if i % 2 == 0 { // FIX 4: Era == 0 para pares. == 1 imprime impares.
       print(i)
   }
}
// FIX 5: 1...10 cuenta hacia adelante. Para atrás usamos stride.
for i in stride(from: 10, through: 1, by: -1) {
   print(i)
}

// PREDICT: ¿Cuántas veces se ejecuta y qué imprime al final?
var total = 0
for i in 1...5 {
total += i
}
print(total) // PREDICT 6: ¿Valor? 15 ¿Cuántas iteraciones? 5
var texto = ""
for _ in 1...3 {
texto += "Hola "
}
print(texto)
// PREDICT 7: "Hola Hola Hola "
// ¿Para qué sirve _ en vez de i?
// (El guion bajo _ sirve para ignorar la variable iteradora cuando no se usa).

// ===== EJERCICIO 4: WHILE =====
var contador = 5
while contador > 0 {
   print("Cuenta regresiva: \(contador)")
   contador -= 1
}
print("¡Despegue!")
// --- TODO 11: Ahorro mensual ---
var ahorro = 0.0
var meses = 0
let meta = 2000.0
let ahorroMensual = 150.0
while ahorro < meta {
   ahorro += ahorroMensual
   meses += 1
}
print("Necesita \(meses) meses para juntar S/. \(meta)")
// --- TODO 12: División sucesiva ---
var numeroV = 1000.0
var divisiones = 0
while numeroV >= 1.0 {
   numeroV = numeroV / 2
   divisiones += 1
   print("División \(divisiones): \(numeroV)")
}
print("Se dividió \(divisiones) veces")
// --- TODO 13: Validar datos con repeat-while ---
let intento1 = 25
let intento2 = -3
let intento3 = 15
var intentoActual = intento1
var esValido = false
var numIntento = 1
repeat {
   if intentoActual >= 0 && intentoActual <= 20 {
       esValido = true
       print("Nota \(intentoActual) válida en intento \(numIntento)")
   } else {
       print("Nota \(intentoActual) inválida, intento \(numIntento)")
       if numIntento == 1 { intentoActual = intento2 }
       if numIntento == 2 { intentoActual = intento3 }
       numIntento += 1
   }
} while !esValido

import Foundation

// PREDICT 8:
// ¿Valor final?: 1
// ¿Cuántas vueltas?: 4

var a = 100
while a > 1 {
    a = a / 3
}
print(a)
// PREDICT 9:
// ¿Valor final?: 1  ¿Cuántas vueltas?: 1
// ¿Por qué repeat-while ejecuta al menos una vez?
// Porque primero entra al bloque { }, ejecuta las instrucciones y evalúa la condición al final. Por eso la primera pasada es obligatoria.
var b = 0
repeat {
    b += 1
} while b < 0
print(b)

// ===== EJERCICIO 5: CARRITO DE COMPRAS =====
let prod1 = "Laptop"
let precio1 = 3500.0
let cant1 = 1
let prod2 = "Mouse"
let precio2 = 45.50
let cant2 = 2
let prod3 = "Teclado"
let precio3 = 120.00
let cant3 = 1
let prod4 = "Monitor"
let precio4 = 890.00
let cant4 = 1
let prod5 = "USB Cable"
let precio5 = 15.00
let cant5 = 3
// --- TODO 14: Calcula el subtotal de cada producto ---
let sub1 = precio1 * Double(cant1)
let sub2 = precio2 * Double(cant2)
let sub3 = precio3 * Double(cant3)
let sub4 = precio4 * Double(cant4)
let sub5 = precio5 * Double(cant5)
// --- TODO 15: Calcula el subtotal general ---
let subtotalGeneral = sub1 + sub2 + sub3 + sub4 + sub5
// --- TODO 16: Aplica descuento según monto de compra ---
var porcentajeDescuento = 0.0
if subtotalGeneral >= 5000 {
   porcentajeDescuento = 0.15
} else if subtotalGeneral >= 2000 {
   porcentajeDescuento = 0.10
} else if subtotalGeneral >= 500 {
   porcentajeDescuento = 0.05
} else {
   porcentajeDescuento = 0.0
}
let descuento = subtotalGeneral * porcentajeDescuento
let subtotalConDescuento = subtotalGeneral - descuento
// --- TODO 17: Categoría de cliente según monto ---
let montoParaCategoria = Int(subtotalGeneral)
var categoriaCliente = ""
switch montoParaCategoria {
case 0..<500: categoriaCliente = "Regular"
case 500..<2000: categoriaCliente = "Frecuente"
case 2000..<5000: categoriaCliente = "VIP"
default: categoriaCliente = "Premium"
}
// --- TODO 18: Calcula IGV y total ---
let igv = subtotalConDescuento * 0.18
let totalFinal = subtotalConDescuento + igv
// --- TODO 19: Imprime el ticket de compra ---
var separador = ""
for _ in 1...40 {
   separador += "="
}
print(separador)
print("          TICKET DE COMPRA")
print(" Cliente: \(categoriaCliente)")
print(separador)
print("\(prod1) x\(cant1) \tS/. \(sub1)")
print("\(prod2) x\(cant2) \tS/. \(sub2)")
print("\(prod3) x\(cant3) \tS/. \(sub3)")
print("\(prod4) x\(cant4) \tS/. \(sub4)")
print("\(prod5) x\(cant5) \tS/. \(sub5)")
print(separador)
print("Subtotal: \t\tS/. \(subtotalGeneral)")
print("Descuento (\(porcentajeDescuento * 100)%): \t-S/. \(descuento)")
print("Subtotal c/desc: \tS/. \(subtotalConDescuento)")
print("IGV (18%): \t\tS/. \(igv)")
print(separador)
print("TOTAL: \t\t\tS/. \(totalFinal)")
print(separador)
print("¡Gracias por su compra!")
