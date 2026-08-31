
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
