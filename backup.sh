#!/bin/bash

nombre=$1
fecha=$(date +%y%m%d)
if [ -d /home/$nombre ]
then
tar -jcf /backups/$nombre-$fecha.tar.bz2 /home/$nombre
tam=$(du -k /backups/$nombre-$fecha.tar.bz2 | cut -f1)
echo "backup descomprimido correctamente"
echo "$fecha $hora backup descomprimido correctamente">>/backups/gestiona-cuentas.log
echo "El fichero ocupa $tam Kbytes"
echo "$fecha $hora El fichero ocupa $tam Kbytes" >> /backups/gestiona-cuentas.log 
fi
