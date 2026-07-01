#!/bin/bash
# ============================================
# gitflow.sh - Gestión de ramas GitFlow
# Proyecto: gestion-tareas
# ============================================

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

# ============================================
# CONFIGURACIÓN DEL PROYECTO
# ============================================

PROJECT_NAME="gestion-tareas"
PROJECT_KEY="SCRUM"  # Clave de Jira

# Ramas principales
MAIN_BRANCH="main"      # Producción
DEV_BRANCH="develop"    # Desarrollo

# ============================================
# FUNCIONES DE MENSAJES
# ============================================

print_header() { echo -e "${CYAN}═══════════════════════════════════════════${NC}"; }
print_title() { echo -e "${CYAN}📌 $1${NC}"; }
print_message() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# ============================================
# FUNCIÓN PARA MOSTRAR MENÚ
# ============================================

show_menu() {
    clear
    print_header
    echo -e "${CYAN}   🌿 GITFLOW - $PROJECT_NAME${NC}"
    print_header
    echo ""
    echo -e "${GREEN}1${NC}) Crear rama Feature (desde develop)"
    echo -e "${GREEN}2${NC}) Crear rama Hotfix (desde main)"
    echo -e "${GREEN}3${NC}) Crear rama Release (desde develop)"
    echo -e "${GREEN}4${NC}) Finalizar Feature (merge a develop)"
    echo -e "${GREEN}5${NC}) Finalizar Hotfix (merge a main y develop)"
    echo -e "${GREEN}6${NC}) Finalizar Release (merge a main y develop)"
    echo -e "${GREEN}7${NC}) Ver estado actual de ramas"
    echo -e "${GREEN}8${NC}) Sincronizar con Jira (usando JGF)"
    echo -e "${RED}0${NC}) Salir"
    echo ""
    print_header
    echo -n "Selecciona una opción: "
}

# ============================================
# FUNCIÓN PARA VERIFICAR RAMA DEVELOP
# ============================================

check_develop() {
    if git show-ref --verify --quiet refs/heads/$DEV_BRANCH; then
        echo "$DEV_BRANCH"
    else
        echo "$MAIN_BRANCH"
    fi
}

# ============================================
# 1. CREAR FEATURE
# ============================================

create_feature() {
    print_title "🚀 Crear nueva Feature"
    echo ""
    
    # Obtener rama base
    TARGET_BRANCH=$(check_develop)
    print_info "Rama base: $TARGET_BRANCH"
    
    # Pedir datos al usuario
    echo -n "📌 Número de ticket Jira (ej. 123): "
    read TICKET_NUMBER
    
    if [[ -z "$TICKET_NUMBER" ]]; then
        print_error "No se ingresó ticket"
        return 1
    fi
    
    echo -n "📌 Descripción corta (ej. agregar-login): "
    read DESCRIPTION
    
    # Limpiar la descripción para usar en nombre de rama
    BRANCH_NAME=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    if [[ -z "$BRANCH_NAME" ]]; then
        BRANCH_NAME="tarea-$TICKET_NUMBER"
    fi
    
    # Construir nombre de rama
    FEATURE_BRANCH="feature/${PROJECT_KEY}-${TICKET_NUMBER}_${BRANCH_NAME}"
    
    print_info "Rama a crear: $FEATURE_BRANCH"
    
    # Verificar si ya existe
    if git show-ref --verify --quiet refs/heads/$FEATURE_BRANCH; then
        print_warning "La rama $FEATURE_BRANCH ya existe"
        echo -n "¿Cambiar a esa rama? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git checkout $FEATURE_BRANCH
            print_message "Cambiado a $FEATURE_BRANCH"
        fi
        return 0
    fi
    
    # Actualizar rama base y crear feature
    print_info "Actualizando $TARGET_BRANCH..."
    git checkout $TARGET_BRANCH
    git pull origin $TARGET_BRANCH
    
    print_info "Creando $FEATURE_BRANCH..."
    git checkout -b $FEATURE_BRANCH
    
    print_message "✅ Feature creada: $FEATURE_BRANCH"
    echo ""
    print_info "Siguiente paso: Trabaja en tu código y haz commits"
    print_info "Cuando termines, ejecuta la opción 4 para finalizar"
}

# ============================================
# 2. CREAR HOTFIX
# ============================================

create_hotfix() {
    print_title "🔧 Crear Hotfix (arreglo urgente)"
    echo ""
    
    echo -n "📌 Nombre del hotfix (ej. fix-login-error): "
    read HOTFIX_NAME
    
    if [[ -z "$HOTFIX_NAME" ]]; then
        print_error "No se ingresó nombre"
        return 1
    fi
    
    HOTFIX_BRANCH="hotfix/$HOTFIX_NAME"
    
    print_info "Rama a crear: $HOTFIX_BRANCH"
    
    # Verificar si ya existe
    if git show-ref --verify --quiet refs/heads/$HOTFIX_BRANCH; then
        print_warning "La rama $HOTFIX_BRANCH ya existe"
        echo -n "¿Cambiar a esa rama? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git checkout $HOTFIX_BRANCH
            print_message "Cambiado a $HOTFIX_BRANCH"
        fi
        return 0
    fi
    
    # Actualizar main y crear hotfix
    print_info "Actualizando $MAIN_BRANCH..."
    git checkout $MAIN_BRANCH
    git pull origin $MAIN_BRANCH
    
    print_info "Creando $HOTFIX_BRANCH..."
    git checkout -b $HOTFIX_BRANCH
    
    print_message "✅ Hotfix creado: $HOTFIX_BRANCH"
    echo ""
    print_info "Siguiente paso: Aplica el arreglo urgente"
    print_info "Cuando termines, ejecuta la opción 5 para finalizar"
}

# ============================================
# 3. CREAR RELEASE
# ============================================

create_release() {
    print_title "📦 Crear Release"
    echo ""
    
    echo -n "📌 Versión del release (ej. 1.2.3): "
    read VERSION
    
    if [[ -z "$VERSION" ]]; then
        print_error "No se ingresó versión"
        return 1
    fi
    
    if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Formato inválido. Usa: 1.2.3"
        return 1
    fi
    
    RELEASE_BRANCH="release/v$VERSION"
    
    print_info "Rama a crear: $RELEASE_BRANCH"
    
    # Verificar si ya existe
    if git show-ref --verify --quiet refs/heads/$RELEASE_BRANCH; then
        print_warning "La rama $RELEASE_BRANCH ya existe"
        echo -n "¿Cambiar a esa rama? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git checkout $RELEASE_BRANCH
            print_message "Cambiado a $RELEASE_BRANCH"
        fi
        return 0
    fi
    
    # Actualizar develop y crear release
    TARGET_BRANCH=$(check_develop)
    print_info "Actualizando $TARGET_BRANCH..."
    git checkout $TARGET_BRANCH
    git pull origin $TARGET_BRANCH
    
    print_info "Creando $RELEASE_BRANCH..."
    git checkout -b $RELEASE_BRANCH
    
    print_message "✅ Release creado: $RELEASE_BRANCH"
    echo ""
    print_info "Siguiente paso: Realiza ajustes finales y pruebas"
    print_info "Cuando termines, ejecuta la opción 6 para finalizar"
}

# ============================================
# 4. FINALIZAR FEATURE
# ============================================

finish_feature() {
    print_title "🔀 Finalizar Feature"
    echo ""
    
    CURRENT_BRANCH=$(git branch --show-current)
    
    # Verificar que estamos en una feature
    if [[ ! "$CURRENT_BRANCH" =~ ^feature/ ]]; then
        print_error "No estás en una rama feature (actual: $CURRENT_BRANCH)"
        echo -n "¿Quieres ver todas las ramas feature? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git branch | grep "feature/"
        fi
        return 1
    fi
    
    print_info "Finalizando feature: $CURRENT_BRANCH"
    
    # Verificar que no hay cambios sin commit
    if [[ -n $(git status -s) ]]; then
        print_warning "Hay cambios sin commitear:"
        git status -s
        echo -n "¿Hacer commit de los cambios? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git add .
            echo -n "Mensaje del commit: "
            read COMMIT_MSG
            git commit -m "$COMMIT_MSG"
        else
            print_error "Cancelado. Haz commit o stash de tus cambios primero."
            return 1
        fi
    fi
    
    # Obtener rama destino
    TARGET_BRANCH=$(check_develop)
    print_info "Merge a: $TARGET_BRANCH"
    
    # Actualizar develop
    print_info "Actualizando $TARGET_BRANCH..."
    git checkout $TARGET_BRANCH
    git pull origin $TARGET_BRANCH
    
    # Hacer merge
    print_info "Haciendo merge de $CURRENT_BRANCH a $TARGET_BRANCH..."
    git merge --no-ff $CURRENT_BRANCH -m "Merge feature: $CURRENT_BRANCH"
    
    if [[ $? -eq 0 ]]; then
        print_message "✅ Merge completado"
        
        # Subir cambios
        print_info "Subiendo a GitHub..."
        git push origin $TARGET_BRANCH
        
        # Opción de eliminar rama
        echo -n "¿Eliminar la rama $CURRENT_BRANCH? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git branch -d $CURRENT_BRANCH
            git push origin --delete $CURRENT_BRANCH
            print_message "Rama $CURRENT_BRANCH eliminada"
        fi
        
        print_message "✅ Feature finalizada exitosamente"
    else
        print_error "Conflictos al hacer merge. Resuélvelos manualmente."
    fi
}

# ============================================
# 5. FINALIZAR HOTFIX
# ============================================

finish_hotfix() {
    print_title "🔀 Finalizar Hotfix"
    echo ""
    
    CURRENT_BRANCH=$(git branch --show-current)
    
    if [[ ! "$CURRENT_BRANCH" =~ ^hotfix/ ]]; then
        print_error "No estás en una rama hotfix (actual: $CURRENT_BRANCH)"
        echo -n "¿Quieres ver todas las ramas hotfix? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git branch | grep "hotfix/"
        fi
        return 1
    fi
    
    print_info "Finalizando hotfix: $CURRENT_BRANCH"
    
    # Verificar cambios
    if [[ -n $(git status -s) ]]; then
        print_warning "Hay cambios sin commitear"
        echo -n "¿Hacer commit de los cambios? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git add .
            echo -n "Mensaje del commit: "
            read COMMIT_MSG
            git commit -m "$COMMIT_MSG"
        else
            print_error "Cancelado"
            return 1
        fi
    fi
    
    # Merge a main
    print_info "Haciendo merge a $MAIN_BRANCH..."
    git checkout $MAIN_BRANCH
    git pull origin $MAIN_BRANCH
    git merge --no-ff $CURRENT_BRANCH -m "Merge hotfix: $CURRENT_BRANCH"
    
    if [[ $? -eq 0 ]]; then
        git push origin $MAIN_BRANCH
        
        # Merge a develop
        DEV_BRANCH_CHECK=$(check_develop)
        print_info "Haciendo merge a $DEV_BRANCH_CHECK..."
        git checkout $DEV_BRANCH_CHECK
        git pull origin $DEV_BRANCH_CHECK
        git merge --no-ff $CURRENT_BRANCH -m "Merge hotfix: $CURRENT_BRANCH (a develop)"
        git push origin $DEV_BRANCH_CHECK
        
        # Eliminar rama
        echo -n "¿Eliminar la rama $CURRENT_BRANCH? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git branch -d $CURRENT_BRANCH
            git push origin --delete $CURRENT_BRANCH
            print_message "Rama eliminada"
        fi
        
        print_message "✅ Hotfix finalizado exitosamente"
    else
        print_error "Conflictos al hacer merge. Resuélvelos manualmente."
    fi
}

# ============================================
# 6. FINALIZAR RELEASE
# ============================================

finish_release() {
    print_title "🔀 Finalizar Release"
    echo ""
    
    CURRENT_BRANCH=$(git branch --show-current)
    
    if [[ ! "$CURRENT_BRANCH" =~ ^release/ ]]; then
        print_error "No estás en una rama release (actual: $CURRENT_BRANCH)"
        echo -n "¿Quieres ver todas las ramas release? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git branch | grep "release/"
        fi
        return 1
    fi
    
    # Extraer versión
    VERSION=$(echo "$CURRENT_BRANCH" | sed 's/release\/v//')
    print_info "Release versión: $VERSION"
    
    # Verificar cambios
    if [[ -n $(git status -s) ]]; then
        print_warning "Hay cambios sin commitear"
        echo -n "¿Hacer commit de los cambios? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git add .
            echo -n "Mensaje del commit: "
            read COMMIT_MSG
            git commit -m "$COMMIT_MSG"
        else
            print_error "Cancelado"
            return 1
        fi
    fi
    
    # Merge a main
    print_info "Haciendo merge a $MAIN_BRANCH..."
    git checkout $MAIN_BRANCH
    git pull origin $MAIN_BRANCH
    git merge --no-ff $CURRENT_BRANCH -m "Release v$VERSION"
    
    if [[ $? -eq 0 ]]; then
        # Crear tag
        print_info "Creando tag v$VERSION..."
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
        git push origin $MAIN_BRANCH
        
        # Merge a develop
        DEV_BRANCH_CHECK=$(check_develop)
        print_info "Haciendo merge a $DEV_BRANCH_CHECK..."
        git checkout $DEV_BRANCH_CHECK
        git pull origin $DEV_BRANCH_CHECK
        git merge --no-ff $CURRENT_BRANCH -m "Merge release: $CURRENT_BRANCH (a develop)"
        git push origin $DEV_BRANCH_CHECK
        
        # Eliminar rama
        echo -n "¿Eliminar la rama $CURRENT_BRANCH? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git branch -d $CURRENT_BRANCH
            git push origin --delete $CURRENT_BRANCH
            print_message "Rama eliminada"
        fi
        
        print_message "✅ Release v$VERSION finalizado exitosamente!"
    else
        print_error "Conflictos al hacer merge. Resuélvelos manualmente."
    fi
}

# ============================================
# 7. VER ESTADO DE RAMAS
# ============================================

show_branches() {
    print_title "🌿 Estado de ramas"
    echo ""
    
    echo -e "${YELLOW}Ramas principales:${NC}"
    git branch -l "main" "master" "develop" 2>/dev/null
    echo ""
    
    echo -e "${GREEN}Ramas feature:${NC}"
    git branch | grep "feature/" || echo "  (sin ramas feature)"
    echo ""
    
    echo -e "${BLUE}Ramas release:${NC}"
    git branch | grep "release/" || echo "  (sin ramas release)"
    echo ""
    
    echo -e "${RED}Ramas hotfix:${NC}"
    git branch | grep "hotfix/" || echo "  (sin ramas hotfix)"
    echo ""
    
    echo -e "${CYAN}Rama actual:${NC} $(git branch --show-current)"
    echo ""
    
    print_info "Resumen de commits pendientes:"
    git log --oneline -5 --decorate
}

# ============================================
# 8. SINCRONIZAR CON JIRA
# ============================================

sync_jira() {
    print_title "🔄 Sincronizar con Jira"
    echo ""
    
    if ! command -v jgf &> /dev/null; then
        print_warning "JGF no está instalado"
        echo -n "¿Instalar JGF? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            npm install -g jgf
        else
            print_info "Usando comandos manuales:"
            echo "  - Para ver tickets: jgf tickets (necesita JGF)"
            echo "  - Para start: jgf start $PROJECT_KEY-123"
            echo "  - Para PR: jgf pr"
            return 0
        fi
    fi
    
    print_info "Comandos disponibles de JGF:"
    echo "  1) Ver mis tickets"
    echo "  2) Iniciar trabajo en un ticket"
    echo "  3) Ver estado del ticket actual"
    echo "  4) Crear PR desde el ticket actual"
    echo -n "Selecciona: "
    read JGF_OPTION
    
    case $JGF_OPTION in
        1)
            jgf tickets
            ;;
        2)
            echo -n "Ticket (ej. $PROJECT_KEY-123): "
            read TICKET
            jgf start $TICKET
            ;;
        3)
            jgf status
            ;;
        4)
            jgf pr
            ;;
        *)
            print_error "Opción inválida"
            ;;
    esac
}

# ============================================
# MENÚ PRINCIPAL
# ============================================

while true; do
    show_menu
    read -n 1 -r OPTION
    echo ""
    
    case $OPTION in
        1) create_feature ;;
        2) create_hotfix ;;
        3) create_release ;;
        4) finish_feature ;;
        5) finish_hotfix ;;
        6) finish_release ;;
        7) show_branches ;;
        8) sync_jira ;;
        0) 
            print_message "👋 Hasta luego!"
            exit 0
            ;;
        *) 
            print_error "Opción inválida"
            sleep 1
            ;;
    esac
    
    echo ""
    echo -n "Presiona Enter para continuar..."
    read -r
done

exit 0
