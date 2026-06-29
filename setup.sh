#!/bin/bash
# ============================================
# setup.sh - Configuración inicial del proyecto
# Proyecto: gestion-tareas
# ============================================

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# CONFIGURACIÓN DEL PROYECTO
# ============================================

PROJECT_NAME="gestion-tareas"
PROJECT_KEY="SCRUM"
MAIN_BRANCH="main"
DEV_BRANCH="develop"

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
# VALIDACIONES INICIALES
# ============================================

print_header
echo -e "${CYAN}   🔧 SETUP - $PROJECT_NAME${NC}"
print_header
echo ""

# Verificar que estamos en un repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    print_error "No estás dentro de un repositorio Git"
    print_info "Ejecuta: git clone <url-del-repositorio>"
    exit 1
fi

# Verificar que no haya cambios sin commit
if [[ -n $(git status -s) ]]; then
    print_warning "Hay cambios sin commitear:"
    git status -s
    echo ""
    print_info "Es recomendable tener el repositorio limpio antes de ejecutar setup"
    echo -n "¿Continuar de todas formas? (s/n): "
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_error "Cancelado por el usuario"
        exit 1
    fi
fi

# ============================================
# PASO 1: INSTALAR DEPENDENCIAS
# ============================================

print_title "📦 Paso 1: Verificando dependencias"
echo ""

# Verificar Git
print_info "Verificando Git..."
if ! command -v git &> /dev/null; then
    print_error "Git no está instalado"
    print_info "Instala Git desde: https://git-scm.com/downloads"
    exit 1
else
    GIT_VERSION=$(git --version)
    print_message "Git encontrado: $GIT_VERSION"
fi

# Verificar Node.js (opcional, para JGF)
print_info "Verificando Node.js..."
if ! command -v node &> /dev/null; then
    print_warning "Node.js no está instalado"
    print_info "Si quieres usar JGF para integración con Jira, instala Node.js desde:"
    print_info "  https://nodejs.org/"
    NODE_INSTALLED=false
else
    NODE_VERSION=$(node --version)
    print_message "Node.js encontrado: $NODE_VERSION"
    NODE_INSTALLED=true
fi

# Verificar npm (opcional)
if [[ "$NODE_INSTALLED" == true ]]; then
    if ! command -v npm &> /dev/null; then
        print_warning "npm no está instalado"
    else
        NPM_VERSION=$(npm --version)
        print_message "npm encontrado: $NPM_VERSION"
    fi
fi

# Verificar JGF (opcional)
print_info "Verificando JGF..."
if ! command -v jgf &> /dev/null; then
    print_warning "JGF no está instalado (opcional)"
    print_info "Para instalarlo: npm install -g jgf"
    JGF_INSTALLED=false
else
    JGF_VERSION=$(jgf --version 2>/dev/null || echo "instalado")
    print_message "JGF encontrado: $JGF_VERSION"
    JGF_INSTALLED=true
fi

echo ""

# ============================================
# PASO 2: CONFIGURAR VARIABLES DE ENTORNO
# ============================================

print_title "🔐 Paso 2: Configurar variables de entorno"
echo ""

# Verificar si existe .env
if [[ -f ".env" ]]; then
    print_info "Archivo .env ya existe"
    echo -n "¿Sobrescribir? (s/n): "
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        CREATE_ENV=true
    else
        CREATE_ENV=false
        print_info "Manteniendo .env existente"
    fi
else
    CREATE_ENV=true
fi

if [[ "$CREATE_ENV" == true ]]; then
    print_info "Creando archivo .env..."
    cat > .env << EOF
# ============================================
# Variables de entorno para $PROJECT_NAME
# ============================================

# Configuración de Jira
JIRA_URL=https://cordovarenzo737.atlassian.net
JIRA_EMAIL=tu-email@ejemplo.com
JIRA_API_TOKEN=tu-api-token

# Configuración de GitHub (opcional)
GITHUB_TOKEN=tu-github-token

# Configuración del proyecto
PROJECT_KEY=$PROJECT_KEY
PROJECT_NAME=$PROJECT_NAME
EOF
    
    print_message "Archivo .env creado"
    print_info "⚠️  IMPORTANTE: Edita el archivo .env con tus credenciales"
    print_info "  - JIRA_EMAIL: tu correo de Jira"
    print_info "  - JIRA_API_TOKEN: genera un token en Jira > Administración > Seguridad"
    print_info "  - GITHUB_TOKEN: (opcional) token de acceso personal de GitHub"
fi

# ============================================
# PASO 3: INSTALAR DEPENDENCIAS (si las hay)
# ============================================

print_title "📦 Paso 3: Instalando dependencias"
echo ""

# Verificar si es proyecto Node.js
if [[ -f "package.json" ]]; then
    print_info "Proyecto Node.js detectado"
    echo -n "¿Instalar dependencias con npm? (s/n): "
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        if ! command -v npm &> /dev/null; then
            print_error "npm no está instalado"
            print_info "Instala Node.js desde: https://nodejs.org/"
        else
            print_info "Ejecutando npm install..."
            npm install
            if [[ $? -eq 0 ]]; then
                print_message "Dependencias instaladas correctamente"
            else
                print_error "Error al instalar dependencias"
            fi
        fi
    else
        print_info "Omitiendo instalación de dependencias"
    fi
else
    print_info "No se detectó package.json - proyecto HTML/CSS/JS puro"
    print_info "No hay dependencias que instalar"
fi

# ============================================
# PASO 4: INSTALAR JGF (opcional)
# ============================================

print_title "🔧 Paso 4: Instalar JGF (opcional)"
echo ""

if [[ "$JGF_INSTALLED" == false ]]; then
    echo -n "¿Instalar JGF para integración con Jira? (s/n): "
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        if [[ "$NODE_INSTALLED" == false ]]; then
            print_error "Node.js no está instalado. No se puede instalar JGF."
            print_info "Instala Node.js desde: https://nodejs.org/"
        else
            print_info "Instalando JGF (puede tardar un momento)..."
            npm install -g jgf
            if [[ $? -eq 0 ]]; then
                print_message "JGF instalado correctamente"
                print_info "Ejecuta 'jgf init' para configurarlo en este proyecto"
                
                echo -n "¿Inicializar JGF en este proyecto? (s/n): "
                read -n 1 -r
                echo
                if [[ $REPLY =~ ^[Ss]$ ]]; then
                    jgf init
                    print_message "JGF inicializado"
                fi
            else
                print_error "Error al instalar JGF"
            fi
        fi
    else
        print_info "Omitiendo instalación de JGF"
    fi
else
    print_message "JGF ya está instalado"
    echo -n "¿Inicializar JGF en este proyecto? (s/n): "
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        jgf init
        print_message "JGF inicializado"
    fi
fi

echo ""

# ============================================
# PASO 5: CONFIGURAR GIT HOOKS (opcional)
# ============================================

print_title "🔗 Paso 5: Configurar Git Hooks (opcional)"
echo ""

echo -n "¿Configurar hooks para validar mensajes de commit? (s/n): "
read -n 1 -r
echo

if [[ $REPLY =~ ^[Ss]$ ]]; then
    # Crear directorio de hooks si no existe
    mkdir -p .git/hooks
    
    # Crear hook commit-msg
    cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash
# Hook para validar que los commits tengan la clave de Jira
# Ejemplo válido: "SCRUM-123: mensaje del commit"
# Ejemplo inválido: "mensaje sin clave"

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Buscar patrón: CLAVE-NUMERO: mensaje
if ! echo "$COMMIT_MSG" | grep -qE "^(SCRUM-[0-9]+): .+"; then
    echo "❌ Error: El mensaje del commit debe incluir la clave de Jira"
    echo "   Formato correcto: SCRUM-123: mensaje descriptivo"
    echo "   Mensaje actual: $COMMIT_MSG"
    exit 1
fi

exit 0
EOF
    
    chmod +x .git/hooks/commit-msg
    print_message "Hook commit-msg configurado"
    print_info "Ahora los commits deben tener formato: SCRUM-123: mensaje"
else
    print_info "Omitiendo configuración de hooks"
fi

echo ""

# ============================================
# PASO 6: CLONAR RAMAS REMOTAS
# ============================================

print_title "🌿 Paso 6: Verificar ramas"
echo ""

print_info "Ramas disponibles en remoto:"
git branch -r

echo ""

# Verificar si existe develop
if git ls-remote --heads origin $DEV_BRANCH | grep -q $DEV_BRANCH; then
    print_info "Rama '$DEV_BRANCH' existe en remoto"
    
    # Preguntar si quiere crear develop local
    if ! git show-ref --verify --quiet refs/heads/$DEV_BRANCH; then
        echo -n "¿Crear rama local '$DEV_BRANCH' desde remoto? (s/n): "
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git checkout -b $DEV_BRANCH origin/$DEV_BRANCH
            print_message "Rama local '$DEV_BRANCH' creada"
        fi
    else
        print_message "Rama local '$DEV_BRANCH' ya existe"
    fi
else
    print_warning "Rama '$DEV_BRANCH' no existe en remoto"
    print_info "Solo existe '$MAIN_BRANCH'"
fi

echo ""

# ============================================
# PASO 7: CONFIGURAR ALIAS DE GIT (opcional)
# ============================================

print_title "⚡ Paso 7: Configurar alias de Git (opcional)"
echo ""

echo -n "¿Agregar alias útiles para Git? (s/n): "
read -n 1 -r
echo

if [[ $REPLY =~ ^[Ss]$ ]]; then
    git config --local alias.co checkout
    git config --local alias.br branch
    git config --local alias.ci commit
    git config --local alias.st status
    git config --local alias.hist "log --oneline --graph --decorate --all"
    git config --local alias.unstage "reset HEAD --"
    git config --local alias.last "log -1 HEAD"
    
    print_message "Alias de Git configurados:"
    echo "  - git co    = git checkout"
    echo "  - git br    = git branch"
    echo "  - git ci    = git commit"
    echo "  - git st    = git status"
    echo "  - git hist  = git log --oneline --graph --decorate --all"
    echo "  - git unstage = git reset HEAD --"
    echo "  - git last  = git log -1 HEAD"
fi

echo ""

# ============================================
# RESUMEN FINAL
# ============================================

print_title "✅ ¡Setup completado!"
echo ""

print_message "Resumen de configuración:"
echo ""
print_info "📁 Proyecto: $PROJECT_NAME"
print_info "🔑 Clave Jira: $PROJECT_KEY"
print_info "🌿 Rama principal: $MAIN_BRANCH"
if git show-ref --verify --quiet refs/heads/$DEV_BRANCH; then
    print_info "🌿 Rama desarrollo: $DEV_BRANCH"
fi
if [[ -f ".env" ]]; then
    print_info "🔐 Archivo .env: creado (edítalo con tus credenciales)"
fi
if [[ -f ".git/hooks/commit-msg" ]]; then
    print_info "🔗 Git hooks: configurados"
fi
if command -v jgf &> /dev/null; then
    print_info "🔄 JGF: instalado"
fi

echo ""
print_message "📋 Comandos útiles:"
echo ""
echo "  ./gitflow.sh     - Gestionar ramas GitFlow"
echo "  ./release.sh     - Crear una nueva versión"
echo "  jgf tickets      - Ver tickets de Jira asignados"
echo "  jgf start XXX    - Iniciar trabajo en un ticket"
echo "  git hist         - Ver historial de commits"
echo ""
print_info "⚠️  Recuerda editar el archivo .env con tus credenciales"
print_info "   Si no lo hiciste ahora, puedes hacerlo después: nano .env"

echo ""
print_message "¡Listo para trabajar! 🚀"

exit 0
