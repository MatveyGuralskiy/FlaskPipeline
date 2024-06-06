/* Script JavaScript file of Main Page */
document.addEventListener('DOMContentLoaded', function () {
    const registerModal = document.getElementById('registerModal');
    const loginModal = document.getElementById('loginModal');
    const closeBtns = document.getElementsByClassName('close');
    const registerBtn = document.getElementById('registerBtn');
    const loginBtn = document.getElementById('loginBtn');
    const registrationForm = document.getElementById('registrationForm');
    const loginForm = document.getElementById('loginForm');

    function showModal(modal) {
        modal.style.display = 'block';
    }

    function closeModal(modal) {
        modal.style.display = 'none';
    }

    registerBtn.onclick = function () {
        showModal(registerModal);
    };

    loginBtn.onclick = function () {
        showModal(loginModal);
    };

    for (let closeBtn of closeBtns) {
        closeBtn.onclick = function () {
            closeModal(closeBtn.parentElement.parentElement);
        };
    }

    window.onclick = function (event) {
        if (event.target == registerModal) {
            closeModal(registerModal);
        }
        if (event.target == loginModal) {
            closeModal(loginModal);
        }
    }

    registrationForm.addEventListener('submit', function (event) {
        event.preventDefault();
        const formData = new FormData(registrationForm);
        console.log('Регистрация:');
        formData.forEach((value, key) => {
            console.log(key + ': ' + value);
        });
        closeModal(registerModal);
    });

    loginForm.addEventListener('submit', function (event) {
        event.preventDefault();
        const formData = new FormData(loginForm);
        console.log('Вход:');
        formData.forEach((value, key) => {
            console.log(key + ': ' + value);
        });
        closeModal(loginModal);
    });
});