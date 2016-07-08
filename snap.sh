#!/bin/bash
###############################################################################
#
# Script para el tratamiento automatico de snapshots en un cluster Ceph
# autor: Luis Ramirez - OpenCloud.es
# version: 0.9a
# fecha: 8/7/1026
#
################################################################################
#pools=(sata 10k ssd docout10k docoutssd)  # listado de pools a realizar snaps
pools=(10k ssd)
plog=/var/log/snaps/ # path del fichero de log
rotacion=7 # periodo de retención en días
fecharotado=`date '+%y.%m.%b' --date='-'$rotacion' day'`
fecha=`datre '+%c'`
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
                echo $fechalog "INFO - Generando Snapshot del objeto: "$j >> $log
                fecha=`date '+%y.%m.%d.%H.%M.%S'`
                fechalog=`date '+%d/%b/%y %T'`
#               rbd snap create $i/$j@daily-$fecha
                echo $fechalog "INFO -" $i/$j@daily-$fecha >> $log
                echo $fechalog "INFO - Fin Snapshot del objeto: "$j >> $log
                fechalog=`date '+%d/%b/%y %T'`
                robjetos=`rbd snap ls $i'/'$j | grep 080716`
                z=0
                for k in ${robjetos[@]}; do
                        snapinfo[z]=$k
                        z=$z+1
                done
                echo $fechalog "INFO -" $i/$j@daily-$fecha >> $log
                echo $fechalog "INFO - Fin Snapshot del objeto: "$j >> $log

                echo $fechalog "INFO - Fin Snapshot del objeto: "$j >> $log
            # Fin creación snaps
            # Rotado de snaps
                echo rbd snap rm $i/$j@${snapinfo[1]}
                echo $fecchalog "INFO - Rotado de snap: "$j >> $log
            # Fin Rotado de snaps
        done
        echo $fechalog "############################################################" >> $log
        echo $fechalog "#           INFO - Fin $i  $fechalog            #" >> $log
        echo $fechalog "############################################################" >> $log
done

