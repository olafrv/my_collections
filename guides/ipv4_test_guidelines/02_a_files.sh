#!/bin/sh
echo Generando archivos de 1M, 10M y 100M
dd if=/dev/zero of=f1.dummy bs=1M count=1
dd if=/dev/zero of=f10.dummy bs=1M count=10
dd if=/dev/zero of=f100.dummy bs=1M count=100
dd if=/dev/zero of=f1000.dummy bs=1M count=1000
ls -lh ~/f1*.dummy
cp ~/f1*.dummy /var/www/html/
