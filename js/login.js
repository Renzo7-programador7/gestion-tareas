// Usuarios de prueba
const testUsers = [
    {
        email: 'admin@example.com',
        password: 'admin123',
        name: 'Administrador'
    },
    {
        email: 'user@example.com',
        password: 'user123',
        name: 'Usuario'
    }
];

// Elementos del DOM
const loginForm = document.getElementById('loginForm');
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');
const emailError = document.getElementById('emailError');
const passwordError = document.getElementById('passwordError');
const loginError = document.getElementById('loginError');
const loginBtn = document.querySelector('.login-btn');

// Event listeners
loginForm.addEventListener('submit', handleLogin);
emailInput.addEventListener('blur', validateEmail);
passwordInput.addEventListener('blur', validatePassword);

// Limpiar errores al escribir
emailInput.addEventListener('input', () => {
    clearFieldError(emailError, emailInput);
});

passwordInput.addEventListener('input', () => {
    clearFieldError(passwordError, passwordInput);
});

/**
 * DEMO NOTE: Este proyecto usa credenciales hardcodeadas solo para demostración.
 * En producción, nunca incluya credenciales en el código cliente o en HTML.
 * Use autenticación con servidor seguro (HTTPS, tokens JWT, etc.)
 */

/**
 * Limpia los errores de un campo de formulario
 */
function clearFieldError(errorElement, inputElement) {
    errorElement.textContent = '';
    errorElement.classList.remove('visible');
    inputElement.classList.remove('error');
}

/**
 * Valida el formato del correo electrónico
 */
function validateEmail() {
    const email = emailInput.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!email) {
        emailError.textContent = 'El correo es requerido';
        emailInput.classList.add('error');
        return false;
    }

    if (!emailRegex.test(email)) {
        emailError.textContent = 'Ingresa un correo válido';
        emailInput.classList.add('error');
        return false;
    }

    emailError.textContent = '';
    emailInput.classList.remove('error');
    return true;
}

/**
 * Valida la contraseña
 */
function validatePassword() {
    const password = passwordInput.value;

    if (!password) {
        passwordError.textContent = 'La contraseña es requerida';
        passwordInput.classList.add('error');
        return false;
    }

    if (password.length < 6) {
        passwordError.textContent = 'La contraseña debe tener al menos 6 caracteres';
        passwordInput.classList.add('error');
        return false;
    }

    passwordError.textContent = '';
    passwordInput.classList.remove('error');
    return true;
}

/**
 * Maneja el envío del formulario de login
 */
function handleLogin(e) {
    e.preventDefault();
    
    // Limpiar mensaje de error anterior
    clearLoginError();

    // Validar campos
    const emailValid = validateEmail();
    const passwordValid = validatePassword();

    if (!emailValid || !passwordValid) {
        return;
    }

    // Deshabilitar botón durante el proceso
    loginBtn.disabled = true;
    loginBtn.textContent = 'Verificando...';

    // Simular delay de verificación
    setTimeout(() => {
        const email = emailInput.value.trim();
        const password = passwordInput.value;

        // Verificar credenciales
        const user = testUsers.find(u => u.email === email && u.password === password);

        if (user) {
            // Guardar información del usuario en localStorage
            localStorage.setItem('currentUser', JSON.stringify({
                email: user.email,
                name: user.name
            }));

            // Redirigir a la página principal
            window.location.href = 'index.html';
        } else {
            // Mostrar error usando clase CSS
            showLoginError('Correo o contraseña incorrectos');

            // Re-habilitar botón
            loginBtn.disabled = false;
            loginBtn.textContent = 'Iniciar Sesión';

            // Limpiar contraseña
            passwordInput.value = '';
            passwordInput.focus();
        }
    }, 500);
}

/**
 * Muestra un error de login usando clase CSS en lugar de estilos inline
 */
function showLoginError(message) {
    loginError.textContent = message;
    loginError.classList.add('visible');
}

/**
 * Limpia el error de login
 */
function clearLoginError() {
    loginError.textContent = '';
    loginError.classList.remove('visible');
}
