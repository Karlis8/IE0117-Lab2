#!/bin/bash


DIRECTORIO="/home/karlis/Downloads"  
LOG_FILE="/var/log/directory_monitor.log"


[ -d "$DIRECTORIO" ] || { echo "Directorio no existe"; exit 1; }


echo "=== Inicio de monitorización: $(date) ===" >> "$LOG_FILE"


inotifywait -m -r -q --format '%w%f %e' --event create,modify,delete "$DIRECTORIO" | while read FILE EVENT
do
    case "$EVENT" in
        *CREATE*) ACCION="CREADO" ;;
        *MODIFY*) ACCION="MODIFICADO" ;;
        *DELETE*) ACCION="ELIMINADO" ;;
        *) ACCION="EVENTO_DESCONOCIDO" ;;
    esac
    
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $ACCION: $FILE" >> "$LOG_FILE"
done