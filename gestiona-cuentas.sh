
declare -i opcion
fecha=`date +"%y%m%d"`
hora=`date +"%H:%m"`
opcion=0

#creamos la carpeta backups donde vamos a guardar el fichero que almacena los registros
if [ -d /backups ]; 
then 
	echo "el directorio backups ya existe" 
else 
	mkdir /backups 
	echo "Carpeta creada" 
fi

#creamos el fichero que guarda los registros
if [ -f /backups/gestiona-cuentas.log ]; 
then 
	echo "ya existe el fichero logfile" 
else 
touch /backups/gestiona-cuentas.log 
fi 

#funcion para opcion script 1
crearUsuario () 
{
		read -p "Nombre de usuario (login): " nombre
		adduser $nombre
		echo
		echo Usuario creado correctamente
		echo "$fecha $hora usuario creado correctamente">>/backups/gestiona-cuentas.log
}

#funcion para opcion script 2 
EliminarUsuario () 
{
read -p "Nombre de usuario cuya cuenta desea eliminar: " nombre
        	if grep "$nombre" /etc/passwd
		then
			userdel $nombre
			echo
			echo Usuario borrado correctamente
			echo "$fecha $hora usuario borrado correctamente">>/backups/gestiona-cuentas.log
			sleep 3
		else
			echo Usuario a eliminar no encontrado
			echo "$fecha $hora usuario eliminado no encontrado"
			sleep 3
		fi
		
}

#funcion para opcion script 3
ProgramarBackup () 
{ 
if [ ! -d /backups ]; 
then
			mkdir /backups
fi
		read -p "Usuario cuyo directorio quiere salvarse: " nombre
		read -p "Hora para realizar el backup: " h m
		read -p "¿Desea programar el backup? (s/n): " sn
		if [ $sn = "s" ]; 
			then
			crontab -l > saco
			echo "$m $h * * * $PWD/backup.sh $nombre" >> saco
			crontab saco
			rm saco
			#rm /home/alumno/saco
                        echo
                        echo Backup programada correctamente
			chmod +x $PWD/backup.sh
                        sleep 3
		elif [ $sn="n" ]; 
			then
			./backup.sh $nombre
			echo "No se hace backup,volviendo al menu"
			echo "$fecha $hora No se hace backup, volviendo al menu"
			sleep 3
		fi
}

#funcion para script opcion 4
RecuperarBackup () 
{ 
		echo "introduzca nombre de backup:"
		read backupcarga
		tar -xvf /backups/$backupcarga
		echo "backup restaurado correctamente"
		echo "$fecha $hora backup restaurado correctamente">>/backups/gestiona-cuentas.log
		
}

while [ $opcion -ne 5 ] 
do
	clear
	echo ASO 201
	echo JLP
	echo
	echo Herramienta de gestión de cuentas
	echo "---------------------------------"
	echo
	echo Menú
	echo " 1) Crear una cuenta de usuario"
	echo " 2) Eliminar cuenta de usuario"
	echo " 3) Programar backup del directorio home del usuario"
	echo " 4) Recuperar contenido de backup del usuario"
	echo " 5) Salir del programa"
	echo
	read -p "Opción seleccionada: " opcion
	case $opcion in
		1)
		echo Menú uno
		crearUsuario
		;;
		2)
        	echo Menú 2
		EliminarUsuario
		;;
		3)
		echo Menu 3
		ProgramarBackup
		;;
				4)
		echo Menu 4
		RecuperarBackup
		;;
		5)
        	echo Programa cerrado
        	exit
		;;
		*)
		echo Opción no válida
		;;
	esac 
done
