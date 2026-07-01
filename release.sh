#!/bin/bash

# ============================================
# release.sh - gestion-tareas (HTML/CSS/JS)
# Proyecto: gestion-tareas
# ============================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_NAME="gestion-tareas"
MAIN_BRANCH="main"  # Cambia a "master" si usas master

print_message() { echo -e "${GREEN}[RELEASE]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# ============================================
# VALIDACIONES INICIALES
# ============================================

print_message "🚀 Iniciando Release para $PROJECT_NAME"

# Verificar que estamos en un repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    print_error "No estás dentro de un repositorio Git"
    exit 1
fi

# Verificar que hay cambios sin commit
if [[ -n $(git status -s) ]]; then
    print_warning "Hay cambios sin commitear:"
    git status -s
    read -p "¿Quieres commitearlos primero? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        print_message "Haciendo commit de los cambios..."
        git add .
        read -p "Mensaje del commit: " COMMIT_MSG
        git commit -m "$COMMIT_MSG"
    else
        print_error "Cancelado. Haz commit o stash de tus cambios primero."
        exit 1
    fi
fi

# ============================================
# VERSIÓN ACTUAL
# ============================================

# Intentar obtener versión desde archivo de versión
if [[ -f "version.txt" ]]; then
    CURRENT_VERSION=$(cat version.txt)
else
    CURRENT_VERSION="0.0.0"
fi
print_message "Versión actual: v$CURRENT_VERSION"

# ============================================
# PEDIR NUEVA VERSIÓN
# ============================================

print_message "📌 Ingresa la nueva versión (ejemplo: 1.2.3):"
read NEW_VERSION
if [[ -z "$NEW_VERSION" ]]; then
    print_error "No se ingresó una versión"
    exit 1
fi

# Validar formato de versión (permite v1.2.3 o 1.2.3)
if [[ "$NEW_VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    VERSION_CLEAN="${NEW_VERSION#v}"
else
    VERSION_CLEAN="$NEW_VERSION"
    NEW_VERSION="v$NEW_VERSION"
fi

if [[ ! "$VERSION_CLEAN" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Formato inválido. Usa: 1.2.3 o v1.2.3"
    exit 1
fi

# ============================================
# VERIFICAR RAMA ACTUAL
# ============================================

CURRENT_BRANCH=$(git branch --show-current)
print_info "Rama actual: $CURRENT_BRANCH"

# Si estamos en feature branch, preguntar si continuar o cambiar
if [[ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]]; then
    print_warning "No estás en la rama '$MAIN_BRANCH'"
    read -p "¿Crear release desde '$CURRENT_BRANCH'? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_message "Cambiando a $MAIN_BRANCH..."
        git checkout $MAIN_BRANCH 2>/dev/null || git checkout master
        git pull origin
        CURRENT_BRANCH=$(git branch --show-current)
        print_info "Rama actual: $CURRENT_BRANCH"
    fi
fi

# ============================================
# CREAR RAMA DE RELEASE
# ============================================

RELEASE_BRANCH="release/$NEW_VERSION"
print_message "📌 Creando rama: $RELEASE_BRANCH"

# Verificar si la rama ya existe
if git show-ref --verify --quiet refs/heads/$RELEASE_BRANCH; then
    print_warning "La rama $RELEASE_BRANCH ya existe"
    read -p "¿Eliminarla y crearla de nuevo? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        git branch -D $RELEASE_BRANCH
    else
        print_error "Cancelado"
        exit 1
    fi
fi

git checkout -b $RELEASE_BRANCH

# ============================================
# ACTUALIZAR VERSIÓN EN ARCHIVOS
# ============================================

print_message "📌 Actualizando versión a $NEW_VERSION..."

# Crear/actualizar archivo version.txt
echo "$VERSION_CLEAN" > version.txt
git add version.txt

# Actualizar versión en HTML si existe
if [[ -f "index.html" ]]; then
    sed -i "s/v[0-9]*\.[0-9]*\.[0-9]*/$NEW_VERSION/g" index.html
    sed -i "s/version=[0-9]*\.[0-9]*\.[0-9]*/version=$VERSION_CLEAN/g" index.html
    git add index.html
fi

# Actualizar otros archivos HTML
for file in *.html; do
    if [[ -f "$file" ]]; then
        sed -i "s/v[0-9]*\.[0-9]*\.[0-9]*/$NEW_VERSION/g" "$file"
        git add "$file" 2>/dev/null
    fi
done

# ============================================
# CREAR CHANGELOG (opcional)
# ============================================

print_message "📌 ¿Quieres crear un CHANGELOG.md? (s/n)"
read CREATE_CHANGELOG
if [[ $CREATE_CHANGELOG =~ ^[Ss]$ ]]; then
    if [[ ! -f "CHANGELOG.md" ]]; then
        echo "# CHANGELOG" > CHANGELOG.md
        echo "" >> CHANGELOG.md
    fi
    echo "## [$NEW_VERSION] - $(date +%Y-%m-%d)" > temp_changelog.tmp
    echo "" >> temp_changelog.tmp
    echo "### Added" >> temp_changelog.tmp
    echo "- " >> temp_changelog.tmp
    echo "" >> temp_changelog.tmp
    echo "### Changed" >> temp_changelog.tmp
    echo "- " >> temp_changelog.tmp
    echo "" >> temp_changelog.tmp
    echo "### Fixed" >> temp_changelog.tmp
    echo "- " >> temp_changelog.tmp
    echo "" >> temp_changelog.tmp
    cat CHANGELOG.md >> temp_changelog.tmp
    mv temp_changelog.tmp CHANGELOG.md
    git add CHANGELOG.md
    print_info "CHANGELOG.md creado/actualizado. Edítalo antes de commitear."
fi

# ============================================
# COMMIT Y PUSH
# ============================================

print_message "📌 Haciendo commit de los cambios..."
git commit -m "chore: bump version to $NEW_VERSION"

print_message "📌 Subiendo rama $RELEASE_BRANCH a GitHub..."
git push origin $RELEASE_BRANCH

# ============================================
# CREAR PR CON JGF
# ============================================

if command -v jgf &> /dev/null; then
    print_message "📌 ¿Crear Pull Request con JGF? (s/n)"
    read CREATE_PR
    if [[ $CREATE_PR =~ ^[Ss]$ ]]; then
        print_message "📌 Ingresa el ticket de Jira (opcional, presiona Enter para omitir):"
        read JIRA_TICKET
        if [[ -n "$JIRA_TICKET" ]]; then
            jgf pr --issue "$JIRA_TICKET"
        else
            jgf pr
        fi
    fi
else
    print_info "JGF no está instalado. Crea el PR manualmente:"
    # Obtener el usuario de GitHub del remote
    GITHUB_USER=$(git remote get-url origin 2>/dev/null | sed -E 's/.*github\.com[:/]([^/]+)\/.*/\1/')
    GITHUB_REPO=$(git remote get-url origin 2>/dev/null | sed -E 's/.*github\.com[:/][^/]+\/(.*)\.git/\1/')
    
    if [[ -n "$GITHUB_USER" ]] && [[ -n "$GITHUB_REPO" ]]; then
        print_message "   https://github.com/$GITHUB_USER/$GITHUB_REPO/compare/$MAIN_BRANCH...$RELEASE_BRANCH"
    else
        print_message "   https://github.com/tu-usuario/gestion-tareas/compare/$MAIN_BRANCH...$RELEASE_BRANCH"
    fi
fi

# ============================================
# RESUMEN FINAL
# ============================================

echo ""
print_message "✅ ¡Release $NEW_VERSION creado exitosamente!"
echo ""
print_message "📝 Resumen:"
print_info "   Rama creada: $RELEASE_BRANCH"
print_info "   Versión: $NEW_VERSION"
print_info "   Archivos actualizados: version.txt, index.html"
echo ""
print_message "📋 Pasos siguientes:"
echo "   1. Revisar el Pull Request en GitHub"
echo "   2. Hacer merge a $MAIN_BRANCH"
echo "   3. Crear el tag: git tag $NEW_VERSION && git push origin $NEW_VERSION"
echo "   4. En Jira, mover los tickets completados a 'Done'"
echo "   5. (Opcional) Desplegar la nueva versión"

# ============================================
# FIN DEL SCRIPT
# ============================================

exit 0
