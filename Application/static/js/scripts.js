/* JavaScript file for Website */
document.addEventListener('DOMContentLoaded', () => {
    // Attach class fade in to every content
    const content = document.querySelector('.content');
    if (content) {
        content.classList.add('fade-in');
    }

    // Fade in between pages
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