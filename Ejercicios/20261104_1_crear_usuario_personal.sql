-- 1. Crear el usuario administrador
CREATE USER 'cdieguez'@'localhost' IDENTIFIED BY 'cdieguez_cifo_2026';

-- 2. Otorgarle absolutamente todos los permisos (rol de root)
GRANT ALL PRIVILEGES ON *.* TO 'cdieguez'@'localhost' WITH GRANT OPTION;

-- 3. Aplicar los cambios en el sistema
FLUSH PRIVILEGES;