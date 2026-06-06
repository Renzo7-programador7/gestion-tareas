#!/bin/bash
echo "=== Creando release ==="
read -p "Versión (ej: v1.3.0): " VERSION
read -p "Descripción: " DESC
git checkout develop
git pull origin develop
git checkout -b release/$VERSION
git tag -a $VERSION -m "$DESC"
git push origin release/$VERSION
git push origin --tags
echo "✓ Release $VERSION creada y subida"
