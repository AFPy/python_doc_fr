#!/bin/sh

for po in */*.po
do
    echo "$po"
    tac "$po" | tac | msgcat - -o "$po"
done
