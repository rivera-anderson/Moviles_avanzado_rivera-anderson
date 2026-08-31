
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
