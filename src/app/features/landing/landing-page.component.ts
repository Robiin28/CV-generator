import { Component, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ThemeService } from '../../core/services/theme.service';

@Component({
  selector: 'app-landing-page',
  standalone: true,
  imports: [RouterLink],
  template: `
    <div class="landing-container">
      <!-- Dedicated Landing Header -->
      <nav class="landing-header">
        <div class="header-inner">
          <div class="brand" routerLink="/">
            <div class="logo-box">F</div>
            <span class="logo-text">ResumeForge</span>
          </div>
          
          <div class="nav-links">
            <a href="#features">Features</a>
            <a routerLink="/templates">Templates</a>
            <a href="#pricing">Pricing</a>
            <a href="#faq">FAQ</a>
          </div>

          <div class="auth-group">
            <button class="theme-toggle-btn" (click)="theme.toggleTheme()">
              @if (theme.isDarkMode()) {
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="18.36" x2="5.64" y2="16.93"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>
              } @else {
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
              }
            </button>
            <button class="btn-ghost" routerLink="/login">Log In</button>
            <button class="btn-saas-primary" routerLink="/register">Get Started</button>
          </div>
        </div>
      </nav>

      <!-- Visual Background Elements -->
      <div class="dot-grid"></div>
      <div class="bg-glow blue"></div>
      <div class="bg-glow teal"></div>

      <!-- HERO SECTION -->
      <section class="hero-section fade-in">
        <h1 class="hero-title font-display">
          Land Your Next Role 3x Faster with <br>
          <span class="gradient-teal">Predictive AI</span>
        </h1>
        <p class="hero-subtitle">
          Build a professional, ATS-optimized resume in minutes. Choose from elegant templates,
          fill in your details, and export a polished PDF — no design skills needed.
        </p>
        
        <div class="hero-actions">
          <button class="btn-primary" routerLink="/builder">Build Your Resume — It's Free</button>
          <button class="btn-secondary" routerLink="/templates">Explore Templates</button>
        </div>

        <div class="hero-preview">
          <div class="preview-browser-bar">
            <span class="dot red"></span>
            <span class="dot yellow"></span>
            <span class="dot green"></span>
            <div class="url-bar">resumeforge.ai/builder</div>
          </div>
          <div class="preview-body">
            <!-- LEFT: App Sidebar Mock -->
            <div class="preview-sidebar">
              <div class="ps-logo"></div>
              <div class="ps-nav-item active"></div>
              <div class="ps-nav-item"></div>
              <div class="ps-nav-item"></div>
              <div class="ps-nav-item"></div>
            </div>
            <!-- CENTER: Form Panel -->
            <div class="preview-form">
              <div class="pf-section-label"></div>
              <div class="pf-input"></div>
              <div class="pf-input short"></div>
              <div class="pf-section-label" style="margin-top: 1rem"></div>
              <div class="pf-input"></div>
              <div class="pf-input mid"></div>
              <div class="pf-input"></div>
              <div class="pf-section-label" style="margin-top: 1rem"></div>
              <div class="pf-input"></div>
              <div class="pf-input short"></div>
              <div class="pf-input mid"></div>
              <div class="pf-input"></div>
            </div>
            <!-- RIGHT: Resume Preview -->
            <div class="preview-cv">
              <div class="cv-name-block"></div>
              <div class="cv-subtitle-block"></div>
              <div class="cv-contact-row">
                <div class="cv-dot"></div>
                <div class="cv-dot"></div>
                <div class="cv-dot"></div>
              </div>
              <div class="cv-divider"></div>
              <div class="cv-section-head"></div>
              <div class="cv-line long"></div>
              <div class="cv-line mid"></div>
              <div class="cv-line short"></div>
              <div class="cv-line mid"></div>
              <div class="cv-section-head" style="margin-top:0.75rem"></div>
              <div class="cv-line long"></div>
              <div class="cv-line mid"></div>
              <div class="cv-line short"></div>
              <div class="cv-section-head" style="margin-top:0.75rem"></div>
              <div class="cv-line long"></div>
              <div class="cv-line mid"></div>
            </div>
          </div>
        </div>
      </section>

      <!-- FEATURES HIGHLIGHTS BAR -->
      <section class="metrics-bar">
        <div class="metric">
          <span class="metric-value">ATS</span>
          <span class="metric-label">Optimized Templates</span>
        </div>
        <div class="metric">
          <span class="metric-value">PDF</span>
          <span class="metric-label">One-Click Export</span>
        </div>
        <div class="metric">
          <span class="metric-value">AI</span>
          <span class="metric-label">Powered Writing</span>
        </div>
      </section>

      <!-- HOW IT WORKS -->
      <section class="narrative-section" id="features">
        <div class="narrative-content">
          <h2 class="section-tag">What We Offer</h2>
          <h3 class="narrative-title">A smarter way to build your resume.</h3>
          <p class="narrative-text">
            ResumeForge combines clean, professional templates with AI-assisted writing tools.
            Focus on your experience — we handle the formatting, structure, and export.
          </p>
        </div>
      </section>

      <!-- HOW IT WORKS -->
      <section class="workflow-section">
        <h2 class="centered-title">How It Works</h2>
        <div class="workflow-grid">
          <div class="workflow-step">
            <div class="step-number">01</div>
            <h4>Choose a Template</h4>
            <p>Pick from a curated set of clean, professional templates designed for readability and ATS compatibility.</p>
          </div>
          <div class="workflow-step">
            <div class="step-number">02</div>
            <h4>Fill In Your Details</h4>
            <p>Use our guided builder to add your experience, skills, and education. Our AI helps you write stronger bullet points.</p>
          </div>
          <div class="workflow-step">
            <div class="step-number">03</div>
            <h4>Export & Apply</h4>
            <p>Download a polished PDF in one click. Your resume will be properly formatted and ready to submit.</p>
          </div>
        </div>
      </section>

      <!-- FEATURES SECTION -->
      <section class="pricing-section" id="pricing">
        <h2 class="centered-title">Built for Job Seekers</h2>
        <div class="pricing-grid">
          <div class="pricing-card card glass">
            <div class="p-tier">Templates</div>
            <div class="p-price">Europass <span>& more</span></div>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Official Europass Layout</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Clean modern format</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> ATS-compatible structure</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Multi-section support</li>
            </ul>
            <button class="btn-secondary" routerLink="/templates">Browse Templates</button>
          </div>
          <div class="pricing-card card glass popular">
            <div class="popular-tag">Core Feature</div>
            <div class="p-tier">AI Builder</div>
            <div class="p-price">Free <span>to use</span></div>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Step-by-step form wizard</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> AI writing suggestions</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Live preview as you type</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> One-click PDF export</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> No account required to preview</li>
            </ul>
            <button class="btn-saas-primary" routerLink="/builder">Start Building</button>
          </div>
          <div class="pricing-card card glass">
            <div class="p-tier">Export</div>
            <div class="p-price">PDF <span>ready</span></div>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> High-fidelity PDF output</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Consistent multi-page layout</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Print-ready formatting</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> No watermarks</li>
            </ul>
            <button class="btn-secondary" routerLink="/builder">Try It Now</button>
          </div>
        </div>
      </section>

      <!-- FAQ SECTION -->
      <section class="faq-section" id="faq">
        <div class="narrative-content">
          <h2 class="section-tag">Common Questions</h2>
          <h3 class="narrative-title">What you need to know</h3>
          
          <div class="faq-grid">
            <div class="faq-item">
              <h4>Is the CV builder really free?</h4>
              <p>Yes. You can build and preview your resume completely free. Sign up to save your progress and export to PDF.</p>
            </div>
            <div class="faq-item">
              <h4>Are the templates ATS-friendly?</h4>
              <p>Yes. Our templates use clean, structured formatting that is readable by Applicant Tracking Systems used by major employers.</p>
            </div>
            <div class="faq-item">
              <h4>Can I export my resume as a PDF?</h4>
              <p>Absolutely. Once you're done, export a high-quality PDF directly from the builder with a single click.</p>
            </div>
          </div>
        </div>
      </section>

      <footer class="footer">
        <div class="footer-grid">
          <div class="footer-brand">
            <div class="brand">
              <div class="logo-box">RF</div>
              <span class="logo-text">ResumeForge</span>
            </div>
            <p>A free, open-source CV builder. Build your resume in minutes and export a polished PDF.</p>
          </div>
          <div class="footer-links">
            <div class="link-group">
              <h5>Product</h5>
              <a routerLink="/templates">Templates</a>
              <a routerLink="/builder">AI Builder</a>
              <a href="#faq">FAQ</a>
            </div>
            <div class="link-group">
              <h5>Account</h5>
              <a routerLink="/login">Log In</a>
              <a routerLink="/register">Sign Up</a>
            </div>
          </div>
        </div>
        <div class="footer-bottom">
          <p>&copy; 2026 ResumeForge. Open source project.</p>
        </div>
      </footer>
    </div>
  `,
  styles: [`
    .landing-container {
      position: relative;
      min-height: 100vh;
      overflow-x: hidden;
      display: flex;
      flex-direction: column;
      align-items: center;
      background: var(--bg-main);
      color: var(--text-body);
      transition: background 0.3s ease;
    }

    /* PREMIUM HEADER */
    .landing-header {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 72px;
      z-index: 1000;
      background: var(--bg-main);
      opacity: 0.95;
      backdrop-filter: blur(12px);
      border-bottom: 1px solid var(--border-light);
      display: flex;
      justify-content: center;
    }
    .header-inner {
      width: 100%;
      max-width: 1280px;
      padding: 0 2rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .brand { display: flex; align-items: center; gap: 12px; cursor: pointer; }
    .logo-box { 
      background: #000000; 
      color: #fff; 
      width: 32px; 
      height: 32px; 
      border-radius: 8px; 
      display: flex; 
      align-items: center; 
      justify-content: center; 
      font-weight: 800; 
      font-size: 0.9rem;
    }
    .logo-text { font-size: 1.1rem; font-weight: 800; color: var(--text-heading); letter-spacing: -0.01em; }
    
    .nav-links { display: flex; gap: 0.75rem; align-items: center; }
    .nav-links a { 
      text-decoration: none; 
      color: var(--text-body); 
      font-weight: 600; 
      font-size: 0.85rem; 
      padding: 0.5rem 1rem;
      border-radius: 99px;
      transition: all 0.2s ease;
    }
    .nav-links a:hover { 
      color: var(--color-primary); 
      background: rgba(37, 99, 235, 0.05);
    }
    
    .auth-group { display: flex; gap: 1rem; align-items: center; }
    
    .theme-toggle-btn {
      background: var(--bg-surface);
      border: 1px solid var(--border-light);
      color: var(--text-heading);
      width: 36px; height: 36px;
      border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      cursor: pointer;
      transition: all 0.2s ease;
    }
    .theme-toggle-btn:hover { background: var(--bg-main); border-color: var(--color-primary); }

    .btn-ghost { 
      background: transparent; 
      border: none; 
      color: var(--text-body); 
      font-weight: 600; 
      font-size: 0.85rem; 
      cursor: pointer; 
      padding: 0.6rem 1.25rem; 
      border-radius: 99px;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .btn-ghost:hover { 
      color: var(--text-heading); 
      background: rgba(0, 0, 0, 0.04);
    }

    .btn-saas-primary {
      background: #0F172A;
      color: #fff;
      border: none;
      padding: 0.6rem 1.5rem;
      border-radius: 99px;
      font-weight: 700;
      font-size: 0.85rem;
      cursor: pointer;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    .btn-saas-primary:hover {
      background: #000;
      transform: translateY(-1px);
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
    }

    /* VISUAL BACKGROUND TEXTURE */
    .dot-grid {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-image: radial-gradient(var(--border-light) 1.5px, transparent 1.5px);
      background-size: 40px 40px;
      opacity: 0.4;
      z-index: 0;
      pointer-events: none;
    }
    
    .bg-glow {
      position: absolute;
      width: 800px;
      height: 800px;
      border-radius: 50%;
      filter: blur(140px);
      opacity: 0.08;
      z-index: 0;
      animation: pulse 12s infinite alternate;
    }
    .bg-glow.blue { background: #1e3a8a; top: -10%; left: -10%; }
    .bg-glow.teal { background: #00f5d4; bottom: 10%; right: -5%; animation-delay: -6s; }
    
    @keyframes pulse {
      from { transform: scale(1); opacity: 0.05; }
      to { transform: scale(1.1); opacity: 0.1; }
    }
    
    .hero-section {
      width: 100%;
      max-width: 1100px;
      padding: 7rem 2rem 3rem; /* Reduced from 12rem — title now visible without scrolling */
      text-align: center;
      position: relative;
      z-index: 10;
    }
    
    .hero-title {
      font-size: 3.2rem; /* Reduced from 5rem */
      line-height: 1.1;
      margin-bottom: 1.5rem;
      letter-spacing: -0.03em;
      color: var(--text-heading);
    }
    
    .hero-subtitle {
      font-size: 1.1rem; /* Reduced from 1.35rem */
      color: var(--text-body);
      max-width: 680px;
      margin: 0 auto 3rem;
      line-height: 1.6;
    }
    
    .hero-actions { display: flex; gap: 1.5rem; justify-content: center; margin-bottom: 3rem; }
    
    .btn-secondary {
      background: var(--bg-main);
      color: var(--text-heading);
      padding: 0.75rem 2.5rem;
      border-radius: 8px;
      border: 1px solid var(--border-light);
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s ease;
      box-shadow: var(--shadow-sm);
    }
    .btn-secondary:hover { background: var(--bg-surface); transform: translateY(-1px); box-shadow: var(--shadow-md); }
    
    /* HERO PREVIEW MOCKUP */
    .hero-preview {
      width: 100%;
      height: 400px;
      border-radius: 16px;
      border: 1px solid var(--border-light);
      overflow: hidden;
      background: var(--bg-surface);
      box-shadow: var(--shadow-premium);
      position: relative;
    }
    .preview-browser-bar {
      height: 38px;
      background: var(--bg-main);
      border-bottom: 1px solid var(--border-light);
      display: flex;
      align-items: center;
      padding: 0 12px;
      gap: 8px;
    }
    .dot { width: 10px; height: 10px; border-radius: 50%; }
    .dot.red { background: #ff5f57; }
    .dot.yellow { background: #febc2e; }
    .dot.green { background: #28c840; }
    .url-bar { flex: 1; background: var(--bg-surface); border-radius: 6px; height: 22px; margin: 0 12px; font-size: 0.72rem; display: flex; align-items: center; padding: 0 10px; color: var(--text-muted); }
    .preview-body { display: flex; height: calc(100% - 38px); }

    /* Sidebar */
    .preview-sidebar { width: 64px; background: #0F172A; display: flex; flex-direction: column; align-items: center; padding: 16px 0; gap: 12px; }
    .ps-logo { width: 28px; height: 28px; border-radius: 6px; background: #3b82f6; margin-bottom: 8px; }
    .ps-nav-item { width: 28px; height: 6px; border-radius: 3px; background: #1e293b; }
    .ps-nav-item.active { background: #3b82f6; }

    /* Form Panel */
    .preview-form { flex: 1; padding: 16px; display: flex; flex-direction: column; gap: 8px; background: var(--bg-main); border-right: 1px solid var(--border-light); }
    .pf-section-label { height: 8px; width: 60%; border-radius: 4px; background: var(--color-primary); opacity: 0.15; }
    .pf-input { height: 28px; width: 100%; border-radius: 6px; background: var(--bg-surface); border: 1px solid var(--border-light); }
    .pf-input.short { width: 55%; }
    .pf-input.mid { width: 75%; }

    /* CV Preview */
    .preview-cv { width: 220px; padding: 16px; background: white; display: flex; flex-direction: column; gap: 6px; border-left: 3px solid #2563eb; overflow: hidden; }
    .cv-name-block { height: 14px; width: 70%; border-radius: 3px; background: #0f172a; }
    .cv-subtitle-block { height: 8px; width: 50%; border-radius: 3px; background: #94a3b8; }
    .cv-divider { height: 1px; background: #e2e8f0; margin: 6px 0; }
    .cv-section-head { height: 7px; width: 35%; border-radius: 3px; background: #2563eb; opacity: 0.7; }
    .cv-line { height: 6px; border-radius: 3px; background: #e2e8f0; }
    .cv-line.long { width: 90%; }
    .cv-line.mid { width: 70%; }
    .cv-line.short { width: 50%; }
    .cv-contact-row { display: flex; gap: 8px; margin: 2px 0; }
    .cv-dot { width: 40px; height: 5px; border-radius: 3px; background: #e2e8f0; }

    /* SECTIONAL SPACING */
    .metrics-bar {
      display: flex;
      justify-content: center;
      gap: 8rem;
      padding: 6rem 2rem;
      width: 100%;
      background: var(--bg-surface);
      border-top: 1px solid var(--border-light);
      border-bottom: 1px solid var(--border-light);
      position: relative;
      z-index: 10;
    }
    .metric { text-align: center; }
    .metric-value { display: block; font-size: 3rem; font-weight: 800; color: var(--color-primary); letter-spacing: -0.03em; }
    .metric-label { font-size: 0.85rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.08em; }

    .narrative-section { padding: 10rem 2rem; text-align: center; position: relative; z-index: 10; }
    .narrative-content { max-width: 800px; margin: 0 auto; }
    .section-tag { font-size: 0.9rem; color: var(--color-primary); text-transform: uppercase; font-weight: 800; letter-spacing: 0.1em; margin-bottom: 1.5rem; }
    .narrative-title { font-size: 2.5rem; line-height: 1.15; color: var(--text-heading); margin-bottom: 1.5rem; letter-spacing: -0.02em; }
    .narrative-text { font-size: 1.25rem; line-height: 1.7; color: var(--text-body); }

    .workflow-section { padding: 8rem 2rem; background: var(--bg-surface); width: 100%; text-align: center; position: relative; z-index: 10; }
    .centered-title { font-size: 2.2rem; margin-bottom: 4rem; color: var(--text-heading); }
    .workflow-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 3rem; max-width: 1200px; margin: 0 auto; }
    .workflow-step { text-align: left; padding: 2rem; background: var(--bg-main); border-radius: 16px; border: 1px solid var(--border-light); box-shadow: var(--shadow-sm); }
    .step-number { font-size: 0.85rem; font-weight: 800; color: var(--color-primary); margin-bottom: 1.5rem; }
    .workflow-step h4 { font-size: 1.5rem; margin-bottom: 1rem; color: var(--text-heading); }
    .workflow-step p { color: var(--text-body); line-height: 1.6; }

    /* PRICING */
    .pricing-section { padding: 8rem 2rem; width: 100%; position: relative; z-index: 10; }
    .pricing-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; max-width: 1200px; margin: 0 auto; }
    .pricing-card { 
      padding: 3rem 2rem; 
      text-align: center; 
      border: 1px solid var(--border-light); 
      display: flex; 
      flex-direction: column; 
      align-items: center; 
      position: relative; 
      transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
      background: var(--bg-surface);
    }
    .pricing-card:hover {
      transform: translateY(-12px);
      box-shadow: 0 20px 40px rgba(0,0,0,0.12);
      border-color: var(--color-primary);
    }
    .pricing-card.popular { 
      border-color: var(--color-primary); 
      transform: scale(1.05); 
      z-index: 2; 
      box-shadow: var(--shadow-premium); 
      background: var(--bg-main);
    }
    .pricing-card.popular:hover {
      transform: scale(1.08) translateY(-12px);
    }
    .popular-tag { position: absolute; top: -12px; background: var(--color-primary); color: #fff; padding: 6px 16px; border-radius: 99px; font-size: 0.75rem; font-weight: 800; text-transform: uppercase; box-shadow: 0 4px 12px rgba(15, 23, 42, 0.3); }
    .p-tier { font-size: 0.9rem; font-weight: 800; text-transform: uppercase; color: var(--text-muted); margin-bottom: 1.5rem; }
    .p-price { font-size: 3rem; font-weight: 800; color: var(--text-heading); margin-bottom: 2rem; letter-spacing: -0.04em; }
    .p-price span { font-size: 1rem; color: var(--text-muted); font-weight: 400; letter-spacing: 0; }
    .p-features { list-style: none; padding: 0; margin: 0 0 2.5rem 0; width: 100%; text-align: left; }
    .p-features li { 
      padding: 0.75rem 0; 
      font-size: 0.95rem; 
      border-bottom: 1px solid var(--border-light); 
      color: var(--text-body); 
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .p-features li:last-child { border-bottom: none; }
    .check { width: 18px; height: 18px; fill: var(--success); flex-shrink: 0; }

    /* FAQ */
    .faq-section { padding: 8rem 2rem; background: var(--bg-surface); width: 100%; position: relative; z-index: 10; }
    .faq-grid { margin-top: 4rem; text-align: left; display: grid; grid-template-columns: 1fr; gap: 2.5rem; }
    .faq-item h4 { font-size: 1.25rem; color: var(--text-heading); margin-bottom: 0.75rem; }
    .faq-item p { color: var(--text-body); line-height: 1.6; }

    .footer { padding: 6rem 2rem 4rem; width: 100%; border-top: 1px solid var(--border-light); position: relative; z-index: 10; background: var(--bg-main); }
    .footer-grid { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1.5fr 2.5fr; gap: 4rem; margin-bottom: 4rem; }
    .footer-brand p { margin-top: 1.5rem; color: var(--text-muted); font-size: 0.95rem; line-height: 1.6; max-width: 300px; }
    .footer-links { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; }
    .link-group h5 { font-size: 0.9rem; color: var(--text-heading); margin-bottom: 1.5rem; text-transform: uppercase; letter-spacing: 0.05em; }
    .link-group a { display: block; text-decoration: none; color: var(--text-muted); font-size: 0.9rem; margin-bottom: 0.75rem; transition: color 0.15s ease; }
    .link-group a:hover { color: var(--color-primary); }
    
    .footer-bottom { max-width: 1200px; margin: 0 auto; padding-top: 2rem; border-top: 1px solid var(--border-light); text-align: center; color: var(--text-muted); font-size: 0.85rem; }
  `]
})
export class LandingPageComponent {
  protected readonly theme = inject(ThemeService);
}
