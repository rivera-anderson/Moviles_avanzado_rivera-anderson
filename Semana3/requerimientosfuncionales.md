# Requerimientos Funcionales - Sistema Metro de Lima

**Autor:** Rivera Anderson

**RF01: Consulta de Estaciones (Listado Iterativo)**
El sistema debe permitir al usuario seleccionar una línea de transporte (Línea 1 a 6, o BRT) mediante un menú numerado y desplegar un reporte enumerado de todas sus estaciones correspondientes. Además, el reporte debe incluir la longitud total de la línea en kilómetros.

**RF02: Búsqueda Global de Estaciones (Case-Insensitive)**
El sistema debe poseer un motor de búsqueda que reciba el nombre de una estación y determine de manera exacta en qué línea o líneas opera actualmente. Esta búsqueda no debe ser sensible a mayúsculas o minúsculas para mejorar la experiencia de usuario.

**RF03: Cálculo de Transbordos (Intersecciones)**
El sistema debe permitir seleccionar dos líneas de transporte distintas y calcular algorítmicamente (mediante Teoría de Conjuntos) si existe un cruce entre ambas. En caso de existir, debe detallar el nombre de la estación o estaciones de transbordo.

**RF04: Reporte de Rutas y Avenidas (Formato Tabular)**
El sistema debe ofrecer una opción para consultar el recorrido vial de una línea. La salida de este reporte debe presentarse en una tabla ASCII estructurada con columnas alineadas dinámicamente que muestren el Orden y el Distrito/Avenida.

**RF05: Dashboard Interactivo y Navegación Constante**
El sistema debe iniciar con una pantalla de presentación (Splash Screen) y luego mantener al usuario en un bucle de navegación (Menú Principal) que no se cierre hasta que se seleccione explícitamente la opción "Salir del sistema". Después de cada consulta, el sistema debe pausarse y requerir que el usuario presione "ENTER" para limpiar y retornar al menú.
