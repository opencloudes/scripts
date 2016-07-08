#!/bin/bash
###############################################################################
#
# Script para el tratamiento automatico de snapshots en un cluster Ceph
# autor: Luis Ramirez - OpenCloud.es
# version: 0.9a
# fecha: 8/7/1026
#
################################################################################
pools=(sata 10k ssd docout10k docoutssd)  # listado de pools a realizar snaps
plog=/var/log/snaps/ # path del fichero de log
fecha=`date '+%d%m%y'`

# recorremos todos los pools
echo "############################################################" $fecha >> $log
echo "Snapshots de los pools a fecha... " $fecha >> $log
echo "############################################################" $fecha >> $log
for i in ${pools[@]}; do
        log=$plog$i.log
        objetos=`rbd -p $i ls`
        echo "Generando Snapshont del pool: "$i
        echo "Generando Snapshont del pool: "$i >> $log
        echo "-------------------------------------------------------" >> $log
        for j in ${objetos[@]}; do
                rbd snap create $i/$j@$fecha
                rbd snap ls $i/$j >> $log
        done
done
echo "############################################################" $fecha >> $log


