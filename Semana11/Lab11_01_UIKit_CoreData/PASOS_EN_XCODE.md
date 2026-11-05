# Lab 11 · Parte 1 — Qué hacer en Xcode (Mac)

1. **Crear proyecto:** File ▸ New ▸ Project ▸ iOS ▸ App
   - Product Name: `apple_lab11_01_UIKit_CoreData`
   - Interface: **Storyboard** · Language: **Swift** · Storage: **Core Data**
   - Guardar dentro de `Semana11/` y **desmarcar** "Create Git repository on my Mac".

2. **Modelo (.xcdatamodeld):**
   - Entidad `Contacto`: `nombre`, `telefono`, `direccion` (String).
   - Entidad `Grupo`: `nombre` (String).
   - En `Contacto` ▸ Relationship `grupo` → Grupo, **To One**.
   - En `Grupo` ▸ Relationship `contactos` → Contacto, **To Many**, Inverse `grupo`, Delete Rule **Nullify**.
   - Revisar que `grupo` tenga Inverse = `contactos`.

3. **Main.storyboard:**
   - View Controller ▸ Editor ▸ Embed In ▸ Navigation Controller.
   - Table View a pantalla completa, con constraints a los 4 bordes.
   - Celda prototipo: Style **Subtitle**, Identifier **Cell**.
   - Bar Button Item a la derecha, System Item **Add**. Título: "Lista de Contactos - Tecsup".

4. **Código:** reemplazar el `ViewController.swift` del proyecto por el de esta carpeta y
   arrastrar `ViewController+Relacion.swift` al proyecto.

5. **Conexiones** (círculo junto a cada línea → arrastrar al storyboard):
   - `@IBOutlet TablaContacto` → el Table View.
   - `@IBAction agregarContacto` → el botón +.

6. ▶️ Ejecutar y probar: agregar 3 contactos, reiniciar, editar, eliminar con swipe.
   Pasos 11 y 12: descomentar las líneas de prueba en `viewDidLoad`, ejecutar y volver a comentar.
