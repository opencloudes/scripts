#!/bin/bash
###############################################################################
#
# Script para el tratamiento automatico de snapshots en un cluster Ceph
# autor: Luis Ramirez - OpenCloud.es
# version: 1.01
# fecha: 8/7/1026
#
# To-Do: Validar que existen snaps a rotar
#
#
################################################################################
pools=(sata 10k ssd docout10k docoutssd)  # listado de pools a realizar snaps
plog=/var/log/snaps/ # path del fichero de log
rotacion=7 # periodo de retención en días
fecharotado=`date '+%y.%m.%b' --date='-'$rotacion' day'`
fecha=`date '+%c'`

# Función para la creación de snaps

function mk-snap {
                echo $fechalog "INFO - Generando Snapshot del objeto: "$2 >> $log
                fecha=`date '+%y.%m.%d.%H.%M.%S'`
                fechalog=`date '+%d/%b/%y %T'`
                rbd snap create $1/$2@daily-$fecha
                fechalog=`date '+%d/%b/%y %T'`
                robjetos=""
                robjetos=`rbd snap ls $1'/'$2 | grep $fecha`
                z=0
                for k in ${robjetos[@]}; do
                        snapinfo[z]=$k
                        z=$z+1
                done
                echo $fechalog "INFO -" $1/$2@daily-$fecha " SnapID: " ${snapinfo[0]}>> $log
                echo $fechalog "INFO - Fin Snapshot del objeto: "$2 >> $log
           }

# Funcion para el volcado de las snaps activas para un objeto determinado

function ls-snaps {
                dlogobj=$plog$1'/'
                flogobj=$dlogobj$2'.log'
                fecha=`date '+%y.%m.%d.%H.%M.%S'`
                tlogobj=$dlobobj'-'$feha'.tgz'
                [ -d $dlogobj ] || mkdir $dlogobj
                tar -cvzf $tlogobj $flobobj
                rm -rf $flogobj
                rbd snap ls $1'/'$2 >> $flogobj
           }

# Funcionn para el rotado de snaps

function rt-sanps {
                robjetos=`rbd snap ls $1'/'$2 | grep $fecharotado`
                z=0
                for k in ${robjetos[@]}; do
                        snapinfo[z]=$k
                        z=$z+1
                done
                fechalog=`date '+%d/%b/%y %T'`
                echo $fechalog "INFO - Rotado de snap: "$2 >> $log
                rbd snap rm $1/$2@${snapinfo[1]}
                fechalog=`date '+%d/%b/%y %T'`
                echo $fechalog "INFO - Borrado de snap id: ${snapinfo[0]} en "$2 >> $log
           }

# recorremos todos los pools
echo "############################################################"
echo "Snapshots de los pools a fecha... " $fecha
echo "############################################################"
for i in ${pools[@]}; do
        log=$plog$i.log
        objetos=`rbd -p $i ls`
        fechalog=`date '+%d/%b/%y %T'`
        echo $fechalog "############################################################" >> $log
        echo $fechalog "          INFO - Generando Snapshont del pool: "$i"        " >> $log
        echo $fechalog "############################################################" >> $log
        for j in ${objetos[@]}; do
            # Creación de snaps
                mk-snap $i $j
            # Fin creación snaps
            # Rotado de Snaps
        #       rt-snaps $i $j
            # Fin Rotado de snaps
            # Almaenamos log con las snaps actuales
                ls-snaps $i $j
            # Finn log snaps actuales
        done
        echo $fechalog "############################################################" >> $log
        echo $fechalog "#           INFO - Fin $i  $fechalog            " >> $log
        echo $fechalog "############################################################" >> $log
done

