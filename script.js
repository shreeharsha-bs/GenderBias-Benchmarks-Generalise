// Copy citation to clipboard
function copyToClipboard() {
    const citationText = `@inproceedings{genderbias2025,
  title={Do Bias Benchmarks Generalise? Evidence from Evaluation of Voice Gender Bias in SpeechLLMs},
  author={[Authors]},
  booktitle={ICASSP 2025},
  year={2025}
}`;

    navigator.clipboard.writeText(citationText).then(function() {
        // Show success message
        const copyBtn = document.querySelector('.copy-btn');
        const originalText = copyBtn.innerHTML;
        copyBtn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        copyBtn.style.background = '#48bb78';
        
        setTimeout(() => {
            copyBtn.innerHTML = originalText;
            copyBtn.style.background = '#667eea';
        }, 2000);
    }).catch(function(err) {
        console.error('Failed to copy citation: ', err);
        // Fallback for older browsers
        const textArea = document.createElement('textarea');
        textArea.value = citationText;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        
        const copyBtn = document.querySelector('.copy-btn');
        const originalText = copyBtn.innerHTML;
        copyBtn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        copyBtn.style.background = '#48bb78';
        
        setTimeout(() => {
            copyBtn.innerHTML = originalText;
            copyBtn.style.background = '#667eea';
        }, 2000);
    });
}

// Handle download buttons
document.addEventListener('DOMContentLoaded', function() {
    const downloadButtons = document.querySelectorAll('.download-btn');
    
    downloadButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const fileName = this.getAttribute('data-file');
            
            // Show download notification
            showNotification(`Download will start soon: ${fileName}`, 'info');
            
            // In a real implementation, this would trigger the actual download
            // For now, we'll just show a placeholder message
            setTimeout(() => {
                showNotification(`${fileName} - File will be available when uploaded to the repository`, 'warning');
            }, 1000);
        });
    });
    
    // Smooth scrolling for anchor links
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    anchorLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Add scroll-based animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observe elements for animation
    const animateElements = document.querySelectorAll('.result-card, .plot-container, .code-item');
    animateElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});

// Show notification function
function showNotification(message, type = 'info') {
    // Remove any existing notifications
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${type === 'info' ? 'info-circle' : type === 'warning' ? 'exclamation-triangle' : 'check-circle'}"></i>
            <span>${message}</span>
            <button class="notification-close" onclick="this.parentElement.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    // Add notification styles
    const styles = `
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            max-width: 400px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-left: 4px solid ${type === 'info' ? '#667eea' : type === 'warning' ? '#ed8936' : '#48bb78'};
            animation: slideIn 0.3s ease;
        }
        
        .notification-content {
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .notification i:first-child {
            color: ${type === 'info' ? '#667eea' : type === 'warning' ? '#ed8936' : '#48bb78'};
        }
        
        .notification-close {
            background: none;
            border: none;
            cursor: pointer;
            padding: 4px;
            margin-left: auto;
            color: #666;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
    `;
    
    if (!document.querySelector('#notification-styles')) {
        const styleSheet = document.createElement('style');
        styleSheet.id = 'notification-styles';
        styleSheet.textContent = styles;
        document.head.appendChild(styleSheet);
    }
    
    document.body.appendChild(notification);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Add loading state for PDF placeholders
function addPDFPlaceholderInteraction() {
    const pdfPlaceholders = document.querySelectorAll('.pdf-placeholder');
    
    pdfPlaceholders.forEach(placeholder => {
        placeholder.style.cursor = 'pointer';
        placeholder.addEventListener('click', function() {
            showNotification('PDF plots will be available when uploaded to the repository', 'info');
        });
        
        placeholder.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.02)';
            this.style.transition = 'transform 0.3s ease';
        });
        
        placeholder.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });
}

// Initialize PDF placeholder interactions when DOM is loaded
document.addEventListener('DOMContentLoaded', addPDFPlaceholderInteraction);

// Add dynamic metrics counter animation
function animateCounters() {
    const counters = document.querySelectorAll('.metric-value');
    
    counters.forEach(counter => {
        const targetText = counter.textContent;
        if (targetText.includes('[') && targetText.includes(']')) {
            // Skip animation for placeholder values
            return;
        }
        
        const target = parseFloat(targetText) || 0;
        const increment = target / 50;
        let current = 0;
        
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                current = target;
                clearInterval(timer);
            }
            
            if (targetText.includes('%')) {
                counter.textContent = Math.floor(current) + '%';
            } else if (targetText.includes('.')) {
                counter.textContent = current.toFixed(2);
            } else {
                counter.textContent = Math.floor(current);
            }
        }, 20);
    });
}

// Run counter animation when metrics come into view
const metricsObserver = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            animateCounters();
            metricsObserver.unobserve(entry.target);
        }
    });
}, { threshold: 0.5 });

document.addEventListener('DOMContentLoaded', function() {
    const metricsSection = document.querySelector('.results-grid');
    if (metricsSection) {
        metricsObserver.observe(metricsSection);
    }
});