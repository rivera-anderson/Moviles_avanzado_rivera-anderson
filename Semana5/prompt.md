# Prompt de la Aplicación: Calculadora de Préstamos

> **Estructura utilizada: RTCFC** (Role, Task, Context, Format, Constraint)

**1. Role (Rol):**
Actúa como un desarrollador Senior de aplicaciones móviles iOS experto en el lenguaje Swift y el framework UIKit.

**2. Task (Tarea):**
Desarrolla una aplicación móvil funcional llamada "Calculadora de Préstamos". Debes construir toda la interfaz gráfica (UI) 100% por código usando `UIStackView` y Auto Layout, sin depender del archivo `Main.storyboard`.

**3. Context (Contexto):**
Esta es una actividad académica para la Semana 5. La aplicación debe calcular la "cuota mensual" y el "monto total a pagar" de un préstamo usando la fórmula matemática de amortización. El usuario deberá ingresar tres datos fundamentales a través de la pantalla:
- Capital inicial (monto del préstamo).
- Tasa de interés anual (%).
- Plazo del préstamo (en años).

Fórmula a implementar para calcular la Cuota Mensual (M):
`M = P * (r(1+r)^n) / ((1+r)^n - 1)`
Donde:
- `P` = Capital inicial
- `r` = Tasa de interés mensual (tasa anual / 12)
- `n` = Número total de pagos (años * 12)

**4. Format (Formato):**
Proporciona únicamente el código fuente completo del archivo `ViewController.swift`. El código debe estar perfectamente estructurado, limpio y debe incluir comentarios explicativos en español detallando qué hace cada bloque de la lógica y la interfaz.

**5. Constraint (Restricciones):**
- Está estrictamente prohibido el uso de SwiftUI; debe ser exclusivamente UIKit.
- Prohibido el uso del entorno visual (Storyboards o .xib). Toda vista y restricción debe crearse en el método `viewDidLoad`.
- El teclado para ingresar datos debe ser numérico (`.decimalPad` o `.numberPad`) y debe incluir la funcionalidad de ocultarse al tocar la pantalla.
- Valida que los datos ingresados sean correctos (mayores a 0) antes de calcular para evitar errores matemáticos (como la división por cero).
- El resultado final debe presentarse al usuario formateado obligatoriamente como moneda (símbolo $ y dos decimales).
