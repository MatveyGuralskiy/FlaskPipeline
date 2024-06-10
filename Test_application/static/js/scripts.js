document.addEventListener('DOMContentLoaded', () => {
    // Добавляем класс fade-in ко всем элементам с классом content
    const content = document.querySelector('.content');
    if (content) {
        content.classList.add('fade-in');
    }

    // Переходы между страницами
    const navLinks = document.querySelectorAll('nav ul li a');
    navLinks.forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault();
            const targetUrl = link.getAttribute('href');
            content.classList.remove('fade-in');
            content.classList.add('fade-out');
            setTimeout(() => {
                window.location.href = targetUrl;
            }, 500);
        });
    });
});