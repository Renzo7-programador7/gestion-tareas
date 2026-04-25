/**
 * Carga la información del usuario al cargar la página
 */
document.addEventListener('DOMContentLoaded', () => {
    loadUserInfo();
    checkAuthentication();
});

/**
 * Verifica si el usuario está autenticado
 */
function checkAuthentication() {
    const currentUser = localStorage.getItem('currentUser');
    
    if (!currentUser) {
        // Redirigir al login si no hay usuario autenticado
        window.location.href = 'login.html';
    }
}

/**
 * Carga y muestra la información del usuario
 */
function loadUserInfo() {
    const currentUser = localStorage.getItem('currentUser');
    
    if (currentUser) {
        try {
            const user = JSON.parse(currentUser);
            document.getElementById('userName').textContent = `¡Hola, ${user.name}!`;
        } catch (error) {
            console.error('Error al cargar información del usuario:', error);
        }
    }
}

/**
 * Cierra la sesión del usuario
 */
function handleLogout() {
    // Confirmar acción
    if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
        // Limpiar datos del usuario
        localStorage.removeItem('currentUser');
        
        // Redirigir al login
        window.location.href = 'login.html';
    }
}
