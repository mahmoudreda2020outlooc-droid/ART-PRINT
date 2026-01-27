// Navbar Scroll Effect
window.addEventListener('scroll', () => {
    const nav = document.getElementById('navbar');
    if (window.scrollY > 50) {
        nav.classList.add('scrolled');
    } else {
        nav.classList.remove('scrolled');
    }
});

// Smooth Scroll for Nav Links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// Reveal Animations on Scroll
const observerOptions = {
    threshold: 0.1
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

document.querySelectorAll('.category-card, .process-card, .testimonial-card, .faq-item').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'all 0.6s ease-out';
    observer.observe(el);
});

// FAQ Accordion
document.querySelectorAll('.faq-question').forEach(question => {
    question.addEventListener('click', () => {
        const item = question.parentElement;
        const answer = item.querySelector('.faq-answer');
        const icon = question.querySelector('i');
        const isActive = item.classList.contains('active');

        // Close all other items
        document.querySelectorAll('.faq-item').forEach(i => {
            i.classList.remove('active');
            const ans = i.querySelector('.faq-answer');
            const ico = i.querySelector('.faq-question i');
            ans.style.maxHeight = '0';
            if (ico) ico.style.transform = 'rotate(0deg)';
        });

        // Toggle current item
        if (!isActive) {
            item.classList.add('active');
            answer.style.maxHeight = answer.scrollHeight + 'px';
            if (icon) icon.style.transform = 'rotate(180deg)';
        }
    });
});
// Mobile Menu Toggle
const mobileMenu = document.getElementById('mobile-menu');
const navList = document.getElementById('nav-list');

if (mobileMenu && navList) {
    mobileMenu.addEventListener('click', () => {
        navList.classList.toggle('active');
        const icon = mobileMenu.querySelector('i');
        icon.classList.toggle('fa-bars');
        icon.classList.toggle('fa-times');
    });

    // Close menu when clicking a link
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            navList.classList.remove('active');
            const icon = mobileMenu.querySelector('i');
            icon.classList.add('fa-bars');
            icon.classList.remove('fa-times');
        });
    });
}

// Initialize Appwrite
const { Client, Databases, ID } = Appwrite;
const client = new Client();
const databases = new Databases(client);

client
    .setEndpoint(APPWRITE_CONFIG.ENDPOINT)
    .setProject(APPWRITE_CONFIG.PROJECT_ID);

// Feedback Form Submission
async function submitFeedback(event) {
    event.preventDefault();

    const name = document.getElementById('feedbackName').value || 'غير محدد';
    const contact = document.getElementById('feedbackContact').value || 'غير محدد';
    const type = document.querySelector('input[name="feedbackType"]:checked').value;
    const message = document.getElementById('feedbackMessage').value;
    const btn = document.getElementById('feedbackBtn');

    // UI Loading State
    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> جاري الإرسال...';
    btn.disabled = true;

    try {
        // Try saving to Appwrite
        await databases.createDocument(
            APPWRITE_CONFIG.DATABASE_ID,
            APPWRITE_CONFIG.FEEDBACK_COLLECTION_ID,
            ID.unique(),
            {
                name: name,
                contact: contact,
                type: type,
                message: message,
                date: new Date().toISOString()
            }
        );

        alert('تم إرسال رسالتك بنجاح! شكراً لمشاركتك.');
        document.getElementById('feedbackForm').reset();

    } catch (error) {
        console.error('Feedback Error:', error);

        // Fallback to WhatsApp if DB fails (e.g. collection missing)
        if (confirm('حدث خطأ في الإرسال المباشر. هل ترغب في الإرسال عبر واتساب بدلاً من ذلك؟')) {
            const whatsappMessage = `🔔 *${type} جديدة من العميل*\n\n` +
                `👤 *الاسم:* ${name}\n` +
                `📞 *التواصل:* ${contact}\n` +
                `📝 *نوع الرسالة:* ${type}\n\n` +
                `💬 *الرسالة:*\n${message}`;

            const whatsappURL = `https://wa.me/201021729633?text=${encodeURIComponent(whatsappMessage)}`;
            window.open(whatsappURL, '_blank');
            document.getElementById('feedbackForm').reset();
        }
    } finally {
        btn.innerHTML = originalText;
        btn.disabled = false;
    }
}
