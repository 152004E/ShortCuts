# Reglas y Directrices del Proyecto

## 1. Gestor de Paquetes
- **Uso exclusivo de `pnpm`:** Está estrictamente prohibido usar `npm`, `npx` o `yarn`.
- Todas las dependencias, scripts y comandos de ejecución deben realizarse con `pnpm` (por ejemplo: `pnpm install`, `pnpm dev`, `pnpm build`, `pnpm add <paquete>`).

## 2. Control de Versiones (Git)
- **Prohibido realizar commits y sincronizar con remotos:** Está prohibido ejecutar comandos como `git commit`, `git push`, `git pull`, `git fetch`, `git remote` o cualquier derivado.
- Los commits y operaciones con el repositorio remoto los realiza exclusivamente el usuario.
- Solo se permiten consultas locales de solo lectura como `git status`, `git diff` o `git log`.

## 3. Seguridad y Permisos del Sistema
- Prohibido el uso de `sudo` o `su`.
- Prohibido el borrado masivo de archivos (`rm -rf` en directorios padre o raíz).
- Prohibido acceder o modificar credenciales, claves SSH o variables de entorno (`.env`) sin consulta previa.

## 4. Buenas Prácticas de Código
- Mantener la integridad de los archivos del proyecto.
- Seguir los estándares de Astro y TypeScript configurados en el repositorio.
