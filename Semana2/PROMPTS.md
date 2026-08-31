# Prompts utilizados — Laboratorio 02
## Herramienta de IA utilizada
ChatGPT
## Ejercicio 6 — Carrito mejorado
### Prompt (estructura CTRFE):
**CONTEXTO:** Soy un alumno de iOS aprendiendo a programar en Swift.
**TAREA:** Mejora la lógica de un carrito de compras usando variables e if/else.
**RESTRICCIONES:**
1. >= 3 unidades del mismo producto = 5% de descuento en el subtotal.
2. Si un cupón dice "DESCUENTO20" aplicar 20% más de descuento.
3. Total > 3000 soles da envío gratis, si no, cuesta 25 soles.
4. Ganar 1 punto entero por cada 100 soles gastados.
5. Si precio es negativo o cantidad 0 lanzar error.
CADA LÍNEA DE CÓDIGO TIENE QUE ESTAR COMENTADA EXPLICANDO QUÉ HACE EXACTAMENTE.
**FORMATO:** Código Swift.
**EJEMPLO:** `var puntos = Int(total / 100) // Transforma a Int para eliminar decimales`
### ¿Funcionó a la primera?
Sí, el código funciona perfectamente y respeta el orden lógico de ir restando los descuentos al subtotal original paso por paso.
### ¿La IA usó algo que no conocías?
Sí, la conversión de tipos `Double()` a `Int()` directamente en el cálculo matemático para redondear hacia abajo los puntos de fidelidad.
---
## Ejercicio 7 — Juego de adivinanza
### Prompt (estructura CTRFE):
**CONTEXTO:** Estoy aprendiendo los bucles while y condicionales lógicos en Swift.
**TAREA:** Crea un juego de adivinanza de números simulado.
**RESTRIONES:**
1. Número secreto fijo (ej: 42).
2. Simula 5 intentos usando 5 variables (intento1 = 20, etc).
3. Usa `while` para recorrer los turnos del 1 al 5.
4. Muestra si es "Muy alto", "Muy bajo" o "¡Correcto!".
5. Cuenta cuántos intentos le tomó.
6. Si pierde tras 5 turnos, muestra "Perdiste. El número era X".
Comenta CADA línea del programa.
**FORMATO:** Bloque de código Swift ejecutable.
**EJEMPLO:** `while turno <= 5 { // Inicia ciclo validando límite`
### ¿Funcionó a la primera?
Sí. El ciclo if/else if simuló perfectamente el input de un usuario a través de una variable temporal que iba cambiando en cada vuelta del while.
### ¿La IA usó algo que no conocías?
Sí. Utilizó la condición `&& !acertoJuego` en el while, combinando de manera lógica el contador numérico y una bandera booleana para frenar la ejecución instantáneamente si el usuario ganaba en el intento 2 o 3.
