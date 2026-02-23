/* ====================================================
   EventHub – Premium Home Page JavaScript
   ====================================================
   Features:
   - Enhanced image slider with dot navigation
   - Scroll-aware navbar (glassmorphism → solid)
   - Scroll-reveal animations (IntersectionObserver)
   - Animated stat counters
   - Smooth scroll for anchor links
   ==================================================== */

// ─── Hero Image Slider ──────────────────────────────
(function initSlider() {
    const slides = document.querySelectorAll('.hero-slider .slide');
    const dots = document.querySelectorAll('.slider-dot');
    let current = 0;
    let interval;

    function goTo(index) {
        slides[current].classList.remove('active');
        dots[current].classList.remove('active');
        current = index % slides.length;
        slides[current].classList.add('active');
        dots[current].classList.add('active');
    }

    function next() {
        goTo(current + 1);
    }

    function startAutoPlay() {
        interval = setInterval(next, 5000);
    }

    function resetAutoPlay() {
        clearInterval(interval);
        startAutoPlay();
    }

    // Dot click handlers
    dots.forEach(dot => {
        dot.addEventListener('click', () => {
            goTo(parseInt(dot.dataset.index));
            resetAutoPlay();
        });
    });

    startAutoPlay();
})();


// ─── Navbar Scroll Effect ────────────────────────────
(function initNavbar() {
    const navbar = document.getElementById('navbar');
    let ticking = false;

    window.addEventListener('scroll', () => {
        if (!ticking) {
            window.requestAnimationFrame(() => {
                if (window.scrollY > 60) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
                ticking = false;
            });
            ticking = true;
        }
    });
})();


// ─── Scroll Reveal (IntersectionObserver) ────────────
(function initReveal() {
    const reveals = document.querySelectorAll('.reveal');

    if (!reveals.length) return;

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.12,
        rootMargin: '0px 0px -40px 0px'
    });

    reveals.forEach(el => observer.observe(el));
})();


// ─── Animated Counters ──────────────────────────────
(function initCounters() {
    const counters = document.querySelectorAll('.stat-number');
    let animated = false;

    function animateCounter(el) {
        const text = el.textContent;
        const match = text.match(/(\d+)/);
        if (!match) return;

        const target = parseInt(match[1]);
        const suffix = text.replace(match[1], '');
        const duration = 2000;
        const start = performance.now();

        function step(now) {
            const elapsed = now - start;
            const progress = Math.min(elapsed / duration, 1);
            // Ease out cubic
            const ease = 1 - Math.pow(1 - progress, 3);
            const value = Math.floor(ease * target);
            el.textContent = value + suffix;

            if (progress < 1) {
                requestAnimationFrame(step);
            } else {
                el.textContent = text; // restore exact original
            }
        }

        requestAnimationFrame(step);
    }

    const observer = new IntersectionObserver((entries) => {
        if (animated) return;
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animated = true;
                counters.forEach(c => animateCounter(c));
                observer.disconnect();
            }
        });
    }, { threshold: 0.5 });

    counters.forEach(c => observer.observe(c));
})();


// ─── Smooth Scroll for Anchor Links ─────────────────
(function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const id = this.getAttribute('href');
            if (id === '#') return;
            const target = document.querySelector(id);
            if (target) {
                e.preventDefault();
                const navbarHeight = document.getElementById('navbar').offsetHeight;
                const top = target.getBoundingClientRect().top + window.scrollY - navbarHeight - 20;
                window.scrollTo({ top, behavior: 'smooth' });
            }
        });
    });
})();


// ─── Category Click Ripple Effect ───────────────────
(function initCategoryRipple() {
    document.querySelectorAll('.category').forEach(cat => {
        cat.addEventListener('click', function (e) {
            // Create ripple element
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);

            ripple.style.cssText = `
        position: absolute;
        width: ${size}px;
        height: ${size}px;
        border-radius: 50%;
        background: rgba(245, 158, 11, 0.15);
        left: ${e.clientX - rect.left - size / 2}px;
        top: ${e.clientY - rect.top - size / 2}px;
        transform: scale(0);
        animation: ripple-anim 0.6s ease-out forwards;
        pointer-events: none;
      `;

            this.style.position = 'relative';
            this.style.overflow = 'hidden';
            this.appendChild(ripple);

            setTimeout(() => ripple.remove(), 700);
        });
    });

    // Inject ripple animation
    const style = document.createElement('style');
    style.textContent = `
    @keyframes ripple-anim {
      to { transform: scale(2.5); opacity: 0; }
    }
  `;
    document.head.appendChild(style);
})();


// ─── Search Input Interaction ───────────────────────
(function initSearch() {
    const searchInput = document.getElementById('search-input');
    if (!searchInput) return;

    searchInput.addEventListener('focus', function () {
        this.parentElement.style.transform = 'scale(1.02)';
        this.parentElement.style.transition = 'transform 0.3s ease';
    });

    searchInput.addEventListener('blur', function () {
        this.parentElement.style.transform = 'scale(1)';
    });
})();


// ─── Newsletter Form ────────────────────────────────
(function initNewsletter() {
    const form = document.getElementById('newsletter-form');
    const button = document.getElementById('newsletter-submit');

    if (!form || !button) return;

    form.addEventListener('submit', function (e) {
        e.preventDefault();
        const email = document.getElementById('newsletter-email').value;
        if (email) {
            button.textContent = '✓ Subscribed!';
            button.style.background = '#10b981';
            setTimeout(() => {
                button.textContent = 'Subscribe →';
                button.style.background = '';
                document.getElementById('newsletter-email').value = '';
            }, 3000);
        }
    });
})();