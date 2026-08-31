

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

// ===== EJERCICIO 6: CARRITO MEJORADO (CON IA) =====
let productoAI = "Audífonos" // Asignamos el nombre del producto
let precioAI = 250.0 // Asignamos el precio del producto
let cantidadAI = 4 // Asignamos la cantidad a comprar
let cuponAI = "DESCUENTO20" // Asignamos el código del cupón
// 1. Validación de precio y cantidad
if precioAI < 0 || cantidadAI <= 0 { // Verificamos si el precio es negativo o cantidad es cero
   print("Error: Precio o cantidad inválidos.") // Imprimimos mensaje de error
} else {
   var subtotalAI = precioAI * Double(cantidadAI) // Calculamos el primer subtotal multiplicando
  
   // 2. Descuento por cantidad (5% extra)
   if cantidadAI >= 3 { // Evaluamos si la cantidad es 3 o mayor
       let dctoVolumen = subtotalAI * 0.05 // Obtenemos el 5% del subtotal
       subtotalAI -= dctoVolumen // Restamos el descuento al subtotal
       print("Descuento del 5% aplicado por volumen.") // Avisamos en consola
   }
  
   // 3. Cupón de descuento (20% adicional)
   if cuponAI == "DESCUENTO20" { // Validamos si el texto del cupón es exacto
       let dctoCupon = subtotalAI * 0.20 // Obtenemos el 20% del subtotal actual
       subtotalAI -= dctoCupon // Restamos el cupón al subtotal
       print("Cupón del 20% aplicado con éxito.") // Confirmamos el cupón
   }
  
   // 4. Envío gratis
   var envioAI = 0.0 // Variable para el costo del envío
   if subtotalAI > 3000.0 { // Comprobamos si la compra pasa los 3000
       print("Envío gratis aplicable.") // Informamos envío gratis
   } else {
       envioAI = 25.0 // Asignamos 25 al costo de envío
       print("Costo de envío: S/. 25.00") // Imprimimos tarifa
   }
  
   let totalPagoAI = subtotalAI + envioAI // Sumamos el subtotal final con el envío
   print("Total Final a Pagar: S/. \(totalPagoAI)") // Mostramos el total
  
   // 5. Puntos de fidelidad
   let puntosAI = Int(totalPagoAI / 100.0) // Dividimos entre 100 y pasamos a Int para quitar decimales
   print("Ganaste \(puntosAI) puntos de fidelidad.") // Mostramos los puntos
}
// ===== EJERCICIO 7: JUEGO DE ADIVINANZA (CON IA) =====
let secretoAI = 42 // Definimos el número ganador
let t1 = 20 // Intento simulado 1
let t2 = 80 // Intento simulado 2
let t3 = 35 // Intento simulado 3
let t4 = 42 // Intento simulado 4 (gana aquí)
let t5 = 90 // Intento simulado 5
var intentoAct = 1 // Iniciamos contador de turnos
var valorPrueba = 0 // Variable para guardar la prueba del turno
var acertoJuego = false // Bandera booleana de victoria
// Bucle while con límite de 5 intentos y que no haya ganado
while intentoAct <= 5 && !acertoJuego { // Doble condición
  
   if intentoAct == 1 { valorPrueba = t1 } // Turno 1 carga t1
   else if intentoAct == 2 { valorPrueba = t2 } // Turno 2 carga t2
   else if intentoAct == 3 { valorPrueba = t3 } // Turno 3 carga t3
   else if intentoAct == 4 { valorPrueba = t4 } // Turno 4 carga t4
   else if intentoAct == 5 { valorPrueba = t5 } // Turno 5 carga t5
  
   print("Intento \(intentoAct): \(valorPrueba)") // Mostramos turno y valor
  
   // Validaciones del juego
   if valorPrueba > secretoAI { // Si el número es más grande
       print("Muy alto.") // Pista de bajar
   } else if valorPrueba < secretoAI { // Si el número es más bajo
       print("Muy bajo.") // Pista de subir
   } else { // Si es exacto
       print("¡Correcto! Adivinaste el número.") // Celebra victoria
       acertoJuego = true // Cambia bandera para romper el while
       print("Lo lograste en \(intentoAct) intentos.") // Muestra score
   }
  
   intentoAct += 1 // Suma 1 al contador para el siguiente turno
}
// Fuera del bucle comprobamos si perdió
if !acertoJuego { // Si la bandera de victoria sigue falsa
   print("Perdiste. El número era: \(secretoAI)") // Muestra mensaje de derrota
}
