#!/bin/bash
###############################################################################
#
# Script para el tratamiento automatico de snapshots en un cluster Ceph
# autor: Luis Ramirez - OpenCloud.es
# version: 0.91a
# fecha: 8/7/1026
#
################################################################################
pools=(sata 10k ssd docout10k docoutssd)  # listado de pools a realizar snaps
plog=/var/log/snaps/ # path del fichero de log
fechalog=`date '+%d/%b/%y %T'`
fecharotado=`date '+%d%m%y' --date='-7 day'`
# recorremos todos los pools
echo "############################################################" $fecha >> $log
echo "Snapshots de los pools a fecha... " $fecha >> $log
echo "############################################################" $fecha >> $log
for i in ${pools[@]}; do
        log=$plog$i.log
        objetos=`rbd -p $i ls`
        echo $fechalog "############################################################" >> $log
        echo $fechalog "          INFO - Generando Snapshont del pool: "$i"        " >> $log
        echo $fechalog "############################################################" >> $log
        for j in ${objetos[@]}; do
                echo $fechalog " INFO - Generando Snapshont del objeto: "$j"      " >> $log
                fecha=`date '+%y.%m.%d.%H.%M.%S'`
                echo rbd snap create $i/$j@daily-$fecha
                echo $fechalog " " $i/$j@daily-$fecha >> $log
                rbd snap ls $i/$j >> $log
                echo $fechalog " INFO - Fin Snapshont del objeto: "$j"            " >> $log
        done
        echo $fechalog "############################################################" >> $log
        echo $fechalog "#           INFO - Fin $i  $fechalog            #" >> $log
        echo $fechalog "############################################################" >> $log
done

