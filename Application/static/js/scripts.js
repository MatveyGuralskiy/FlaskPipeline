/* JavaScript file for Website */
document.addEventListener('DOMContentLoaded', () => { //waits for HTML to be downloaded
    // Attach class fade in to every content
    const content = document.querySelector('.content'); //finds the first element on the page with content class
    if (content) {
        content.classList.add('fade-in');
    }

    // Fade in between pages
    const navLinks = document.querySelectorAll('nav ul li a'); //finds all links
    navLinks.forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault();
            const targetUrl = link.getAttribute('href'); //takes link from href
            content.classList.remove('fade-in');
            content.classList.add('fade-out');
            setTimeout(() => {
                window.location.href = targetUrl; //timeout of 0.5 sec
            }, 500);
        });
    });
});
