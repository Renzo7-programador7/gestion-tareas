#!/bin/bash
echo "=== GitFlow Automatizado ==="
echo "1) Crear feature"
echo "2) Cerrar feature"
echo "3) Crear hotfix"
read -p "Opción: " OPT

if [ "$OPT" = "1" ]; then
  read -p "Nombre de la feature: " NOMBRE
  git checkout develop
  git pull origin develop
  git checkout -b feature/$NOMBRE
  git push origin feature/$NOMBRE
  echo "✓ Feature creada: feature/$NOMBRE"

elif [ "$OPT" = "2" ]; then
  read -p "Nombre de la feature a cerrar: " NOMBRE
  git checkout develop
  git merge feature/$NOMBRE
  git push origin develop
  echo "✓ Feature fusionada a develop"

elif [ "$OPT" = "3" ]; then
  read -p "Nombre del hotfix: " NOMBRE
  git checkout main
  git checkout -b hotfix/$NOMBRE
  git push origin hotfix/$NOMBRE
  echo "✓ Hotfix creado: hotfix/$NOMBRE"
fi
