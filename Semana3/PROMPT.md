# Prompts — Proyecto Metro de Lima

## Docente: Juan Leon — Tecsup

## Herramienta: ChatGPT

## 1. Prompt - Base de Datos y Diccionarios

### Prompt (CTRFE):

Actúa como un Arquitecto de Datos Swift. Estoy desarrollando una aplicación de consola para mapear el Metro de Lima y tengo los datos exactos de 6 líneas y el BRT. Genera los diccionarios de Swift `[String: [String]]` para almacenar las estaciones y otro para las avenidas, usando arrays para listar los nombres (por ejemplo: "L1": ["Bayobar", "Santa Rosa"...]). Devuélveme solo el código con las variables, sin lógica de menú aún, y con comentarios descriptivos en cada línea.

## 2. Prompt - Diseño de Interfaz y Splash Screen

### Prompt (CTRFE):

Actúa como un Diseñador UI de Consola. Ya tengo los datos del metro y necesito una interfaz visual para la terminal. Crea una pantalla de inicio (Splash Screen) usando funciones `print()` con un logo ASCII Art estilo Spring Boot pero adaptado al "Metro de Lima" que requiera presionar ENTER para continuar mediante un `readLine()`. Después, inicializa una variable bandera `salir = false` para preparar el sistema.

## 3. Prompt - Bucle Principal y Búsquedas

### Prompt (CTRFE):

Como Desarrollador Swift Senior, necesito armar la lógica interactiva del menú usando los diccionarios creados. Implementa un bucle `while` con un menú tipo dashboard. Dentro, usa un `switch` con un bloque de código para dos opciones principales: la primera debe listar las estaciones iterando el array de la línea seleccionada, y la segunda debe buscar el nombre de una estación iterando el diccionario completo, ignorando mayúsculas y minúsculas con la propiedad `lowercased()`.

## 4. Prompt - Transbordos (Sets) y Tablas

### Prompt (CTRFE):

Como Ingeniero Backend, necesito agregar las funciones avanzadas para terminar el proyecto. Implementa en el menú una nueva opción que reciba dos líneas elegidas por el usuario, las convierta a tipo `Set` y use `.intersection()` para encontrar y mostrar las estaciones de transbordo exactas. Además, implementa una última opción que imprima las avenidas correspondientes en un formato de tabla ASCII con espacios calculados dinámicamente (`padding`). Devuélveme el código final integrado y documentado.
