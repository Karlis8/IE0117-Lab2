#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse como root" >&2
    exit 1
fi

if [ $# -ne 3 ]; then
    echo "Uso: $0 <usuario> <grupo> <ruta_archivo>" >&2
    exit 1
fi

usuario=$1
grupo=$2
archivo=$3

if [ ! -e "$archivo" ]; then
    echo "Error: El archivo $archivo no existe" >&2
    exit 1
fi
 
if grep -q "^$grupo:" /etc/group; then
    echo "El grupo $grupo creado exitosamente"
fi

if id "$usuario" &>/dev/null; then
    echo "El usuario $usuario ya existe"
    usermod -a -G "$grupo" "$usuario"
else
    useradd -m -G "$grupo" "$usuario"
    echo "Usuario $usuario creado exitosamente y agregado al grupo $grupo"
fi

chown "$usuario:$grupo" "$archivo"

chmod 740 "$archivo"

echo "Operacion completada: "
echo "Archivo: $archivo "
echo "Propietario: $usuario "
echo "Grupo: $grupo "
echo "Permisos: $(stat -c %A "$archivo")"