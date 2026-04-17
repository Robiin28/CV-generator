import { Component, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ThemeService } from '../../core/services/theme.service';

@Component({
  selector: 'app-landing-page',
  standalone: true,
  imports: [RouterLink],
  template: `
    <div class="landing-container">
      <!-- Visual Background Texture -->
      <div class="dot-grid"></div>

      <!-- HERO SECTION -->
      <section class="hero-section fade-in">
        <h1 class="hero-title font-display">
          Land Your Next Role 3x Faster with <br>
          <span class="gradient-teal">ResumeForge AI</span>
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
        <div class="metrics-inner">
          <div class="metric-item">
            <div class="metric-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"></path></svg></div>
            <div class="metric-text">
              <span class="metric-value">ATS Optimized</span>
              <span class="metric-label">Industry Standard Templates</span>
            </div>
          </div>
          <div class="metric-divider"></div>
          <div class="metric-item">
            <div class="metric-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg></div>
            <div class="metric-text">
              <span class="metric-value">PDF Engine</span>
              <span class="metric-label">High-Fidelity Exports</span>
            </div>
          </div>
          <div class="metric-divider"></div>
          <div class="metric-item">
            <div class="metric-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5z"></path><path d="M12 22V12"></path><path d="M2 17l10 5 10-5"></path></svg></div>
            <div class="metric-text">
              <span class="metric-value">AI writing</span>
              <span class="metric-label">Professional Case Study</span>
            </div>
          </div>
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
        <div class="narrative-content">
          <h2 class="section-tag centered">The Process</h2>
          <h3 class="narrative-title centered">Create your resume in <span class="gradient-teal">3 simple steps</span></h3>
        </div>
        <div class="workflow-grid">
          <div class="workflow-step-card">
            <div class="step-badge">01</div>
            <h4>Choose Template</h4>
            <p>Pick from a curated set of clean, professional templates designed for maximum ATS performance.</p>
          </div>
          <div class="workflow-step-card">
            <div class="step-badge">02</div>
            <h4>Fill Details</h4>
            <p>Use our guided builder to add your data. Our AI helps you craft high-impact bullet points instantly.</p>
          </div>
          <div class="workflow-step-card">
            <div class="step-badge">03</div>
            <h4>Export & Apply</h4>
            <p>Download your polished, multi-page PDF with a single click. No design skills or tools required.</p>
          </div>
        </div>
      </section>

      <section class="pricing-section" id="pricing">
        <div class="pricing-header section-fade-in">
          <h2 class="section-tag">Flexible Pricing</h2>
          <h3 class="narrative-title">Simple, transparent, <span class="gradient-teal">built for you</span>.</h3>
        </div>
        
        <div class="pricing-grid">
          <!-- CARD 1 -->
          <div class="pricing-card card">
            <div class="p-tier">Standard</div>
            <div class="p-price">$0 <span>/ life</span></div>
            <p class="p-desc">Perfect for a quick, professional resume to get you started.</p>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Official Europass Layout</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Clean modern format</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> ATS-compatible structure</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Standard PDF Export</li>
            </ul>
            <button class="btn-card-secondary" routerLink="/builder">Get Started</button>
          </div>

          <!-- CARD 2 (POPULAR) -->
          <div class="pricing-card card popular">
            <div class="popular-tag">Most Popular</div>
            <div class="p-tier">Pro AI</div>
            <div class="p-price">Free <span>Beta</span></div>
            <p class="p-desc">Unlock full AI potential with predictive writing and live previews.</p>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Step-by-step form wizard</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Premium AI suggestions</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Multi-page PDF Export</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> One-click PDF export</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Priority AI Processing</li>
            </ul>
            <button class="btn-saas-primary" style="width: 100%" routerLink="/builder">Get Started</button>
          </div>

          <!-- CARD 3 -->
          <div class="pricing-card card">
            <div class="p-tier">Elite</div>
            <div class="p-price">Soon <span>/ pro</span></div>
            <p class="p-desc">Custom branding and multiple resume versions for power users.</p>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Unlimited Resumes</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Custom Templates</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Career Dashboard</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Priority Support</li>
            </ul>
            <button class="btn-card-secondary" routerLink="/register">Join Waitlist</button>
          </div>
        </div>
      </section>

      <!-- FAQ SECTION -->
      <section class="faq-section" id="faq">
        <div class="narrative-content">
          <h2 class="section-tag">Common Questions</h2>
          <h3 class="narrative-title">What you need to know</h3>
          
          <div class="faq-grid">
            <div class="faq-card glass">
              <div class="faq-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg></div>
              <div class="faq-content">
                <h4>Is the CV builder really free?</h4>
                <p>Yes. You can build and preview your resume completely free. Sign up to save your progress and export to PDF.</p>
              </div>
            </div>
            <div class="faq-card glass">
              <div class="faq-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></div>
              <div class="faq-content">
                <h4>Are the templates ATS-friendly?</h4>
                <p>Yes. Our templates use clean, structured formatting that is readable by Applicant Tracking Systems used by major employers.</p>
              </div>
            </div>
            <div class="faq-card glass">
              <div class="faq-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg></div>
              <div class="faq-content">
                <h4>Can I export my resume as a PDF?</h4>
                <p>Absolutely. Once you're done, export a high-quality PDF directly from the builder with a single click.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <footer class="footer">
        <div class="footer-grid">
          <div class="footer-brand">
            <div class="brand">
              <div class="logo-box font-display">RF</div>
              <span class="logo-text font-display">ResumeForge</span>
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
          <p>&copy; 2026 ResumeForge. Professional Resume Intelligence.</p>
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

    .hero-section {
      width: 100%;
      max-width: 1100px;
      padding: 3rem 2rem; /* Reduced padding since we have a topnav now */
      text-align: center;
      position: relative;
      z-index: 10;
    }
    
    .hero-title {
      font-size: 3.5rem;
      line-height: 1.1;
      margin-bottom: 2rem;
      letter-spacing: -0.03em;
      color: var(--text-heading);
      font-weight: 800;
    }
    .hero-gradient {
      background: linear-gradient(135deg, var(--color-primary), #3b82f6);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    
    .hero-subtitle {
      font-size: 1.15rem;
      color: var(--text-body);
      max-width: 680px;
      margin: 0 auto 4rem;
      line-height: 1.6;
    }
    
    @media (max-width: 1024px) {
      .hero-section { padding: 6rem 1rem 4rem; }
      .hero-title { font-size: 2.5rem; }
      .hero-actions { flex-direction: column; gap: 1rem; align-items: center; }
      .hero-actions button { width: 100%; max-width: 300px; }
      .hero-preview { display: none; }
    }
    
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
    .preview-cv { width: 220px; padding: 16px; background: white; display: flex; flex-direction: column; gap: 6px; border-left: 4px solid #00f5d4; overflow: hidden; box-shadow: -10px 0 20px rgba(0,0,0,0.05); }
    .cv-name-block { height: 14px; width: 70%; border-radius: 3px; background: #0f172a; }
    .cv-subtitle-block { height: 8px; width: 50%; border-radius: 3px; background: #94a3b8; }
    .cv-divider { height: 1px; background: #e2e8f0; margin: 6px 0; }
    .cv-section-head { height: 7px; width: 35%; border-radius: 3px; background: #2563eb; opacity: 0.7; }
    .cv-line { height: 6px; border-radius: 3px; background: #e2e8f0; }
    .cv-line.long { width: 90%; }
    .cv-line.mid { width: 70%; }
    .cv-line.short { width: 50%; }
    .cv-contact-row { display: flex; gap: 8px; margin: 2px 0; }
    .cv-dot { width: 40px; height: 5px; border-radius: 3px; background: #f1f5f9; }

    /* SECTIONAL SPACING & ENHANCEMENTS */
    .metrics-bar {
      padding: 5rem 2rem;
      width: 100%;
      background: var(--bg-main);
      border-top: 1px solid var(--border-light);
      border-bottom: 1px solid var(--border-light);
      position: relative;
      z-index: 10;
    }
    .metrics-inner {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4rem;
      max-width: 1100px;
      margin: 0 auto;
    }
    .metric-item {
      display: flex;
      align-items: center;
      gap: 1rem;
    }
    .metric-divider { width: 1px; height: 40px; background: var(--border-light); }
    .metric-icon { color: var(--color-primary); opacity: 0.7; }
    .metric-value { display: block; font-size: 1.15rem; font-weight: 700; color: var(--text-heading); letter-spacing: -0.01em; }
    .metric-label { font-size: 0.85rem; color: var(--text-muted); }

    .narrative-section { padding: 8rem 2rem 2rem; text-align: center; position: relative; z-index: 10; }
    .narrative-content { max-width: 800px; margin: 0 auto; }
    .section-tag { font-size: 0.8rem; color: var(--color-primary); text-transform: uppercase; font-weight: 700; letter-spacing: 0.1em; margin-bottom: 1rem; display: block; }
    .section-tag.centered { text-align: center; }
    .narrative-title { font-size: 2.5rem; line-height: 1.1; color: var(--text-heading); margin-bottom: 1.5rem; letter-spacing: -0.02em; }
    .narrative-title.centered { text-align: center; }

    .workflow-section { padding: 4rem 2rem 8rem; width: 100%; position: relative; z-index: 10; }
    .workflow-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2.5rem; max-width: 1100px; margin: 4rem auto 0; }
    .workflow-step-card { 
      padding: 2.5rem; 
      border-radius: 12px; 
      background: var(--bg-main); 
      border: 1px solid var(--border-light); 
      position: relative; 
      transition: all 0.3s ease;
    }
    .workflow-step-card:hover { border-color: var(--color-primary); transform: translateY(-5px); box-shadow: var(--shadow-sm); }
    .step-badge { 
      width: 32px; height: 32px; border-radius: 6px; 
      background: var(--color-primary); color: #fff; 
      display: flex; align-items: center; justify-content: center; 
      font-size: 0.85rem; font-weight: 700; margin-bottom: 1.5rem;
    }
    .workflow-step-card h4 { font-size: 1.25rem; font-weight: 700; margin-bottom: 0.75rem; color: var(--text-heading); }
    .workflow-step-card p { color: var(--text-body); line-height: 1.6; font-size: 0.9rem; }

    /* PRICING ENHANCEMENTS */
    .pricing-section { 
      padding: 10rem 2rem; 
      width: 100%; 
      position: relative; 
      z-index: 10; 
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    .pricing-header { text-align: center; margin-bottom: 5rem; max-width: 800px; }
    
    .pricing-grid { 
      display: grid; 
      grid-template-columns: repeat(3, 1fr); 
      gap: 2.5rem; 
      max-width: 1200px; 
      width: 100%;
      margin: 0 auto; 
    }

    .pricing-card { 
      padding: 3.5rem 2.5rem 3rem; 
      text-align: center; 
      border: 1px solid var(--border-light); 
      display: flex; 
      flex-direction: column; 
      align-items: center; 
      position: relative; 
      transition: all 0.3s ease;
      background: var(--bg-main);
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
    }

    .pricing-card:hover {
      transform: translateY(-8px);
      border-color: var(--color-primary);
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05);
    }

    .pricing-card.popular { 
      border: 2px solid var(--color-primary);
      transform: scale(1.05);
      z-index: 5;
    }
    
    .pricing-card.popular:hover {
      transform: scale(1.07) translateY(-10px);
    }

    /* Professional Muted Tag */
    .popular-tag { 
      position: absolute; 
      top: 0;
      left: 50%;
      transform: translateX(-50%);
      background: var(--color-primary); 
      color: #fff; 
      padding: 6px 20px; 
      font-size: 0.75rem; 
      font-weight: 700; 
      text-transform: uppercase; 
      border-radius: 0 0 8px 8px;
      z-index: 10;
    }

    .p-tier { 
      font-size: 0.8rem; 
      font-weight: 800; 
      text-transform: uppercase; 
      color: var(--color-primary); 
      letter-spacing: 0.15em;
      margin-bottom: 1.5rem; 
      z-index: 2;
    }
    
    .p-price { 
      font-size: 3.5rem; 
      font-weight: 800; 
      color: var(--text-heading); 
      margin-bottom: 0.5rem; 
      letter-spacing: -0.04em; 
      z-index: 2;
    }
    
    .p-price span { font-size: 1.1rem; color: var(--text-muted); font-weight: 500; letter-spacing: 0; }
    
    .p-desc { 
      font-size: 0.9rem; 
      color: var(--text-body); 
      margin-bottom: 2.5rem; 
      line-height: 1.5; 
      max-width: 200px;
      z-index: 2;
    }

    .p-features { list-style: none; padding: 0; margin: 0 0 3rem 0; width: 100%; text-align: left; z-index: 2; }
    .p-features li { 
      padding: 0.85rem 0; 
      font-size: 0.9rem; 
      border-bottom: 1px solid rgba(0,0,0,0.03); 
      color: var(--text-body); 
      display: flex;
      align-items: center;
      gap: 12px;
    }
    
    .dark .p-features li { border-bottom-color: rgba(255,255,255,0.03); }
    .p-features li:last-child { border-bottom: none; }
    
    .check { 
      width: 16px; height: 16px; 
      fill: var(--color-primary); 
      flex-shrink: 0; 
    }
    
    .btn-card-secondary {
      width: 100%;
      padding: 0.85rem;
      border-radius: 8px;
      border: 1px solid var(--border-light);
      background: transparent;
      color: var(--text-heading);
      font-weight: 600;
      font-size: 0.9rem;
      cursor: pointer;
      transition: all 0.2s ease;
      z-index: 2;
    }
    
    .btn-card-secondary:hover {
      background: var(--bg-main);
      border-color: var(--color-primary);
      transform: translateY(-2px);
      box-shadow: var(--shadow-sm);
    }

    @media (max-width: 1024px) {
      .pricing-grid { grid-template-columns: 1fr; max-width: 450px; }
      .pricing-card.popular { transform: scale(1); }
      .pricing-card.popular:hover { transform: translateY(-10px); }
    }

    /* FAQ ENHANCEMENTS */
    .faq-section { padding: 8rem 2rem; background: var(--bg-surface); width: 100%; position: relative; z-index: 10; }
    .faq-grid { margin-top: 4rem; display: grid; grid-template-columns: repeat(2, 1fr); gap: 2rem; max-width: 1100px; margin-left: auto; margin-right: auto; }
    .faq-card { 
      padding: 2rem; 
      display: flex; 
      gap: 1.25rem; 
      background: var(--bg-main); 
      border-radius: 12px; 
      border: 1px solid var(--border-light);
      transition: all 0.2s ease;
    }
    .faq-card:hover { border-color: var(--color-primary); box-shadow: var(--shadow-sm); }
    .faq-icon { color: var(--color-primary); opacity: 0.7; flex-shrink: 0; padding-top: 2px; }
    .faq-card h4 { font-size: 1.1rem; font-weight: 700; color: var(--text-heading); margin-bottom: 0.75rem; }
    .faq-card p { color: var(--text-body); line-height: 1.6; font-size: 0.9rem; }

    @media (max-width: 1024px) {
      .metrics-inner, .workflow-grid, .faq-grid { grid-template-columns: 1fr; }
      .metrics-inner { flex-direction: column; gap: 2rem; }
      .metric-divider { display: none; }
    }

    .footer { padding: 6rem 2rem 4rem; width: 100%; border-top: 1px solid var(--border-light); position: relative; z-index: 10; background: var(--bg-main); }
    .footer-grid { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1.5fr 2.5fr; gap: 4rem; margin-bottom: 4rem; }
    .footer-brand p { margin-top: 1.5rem; color: var(--text-muted); font-size: 0.95rem; line-height: 1.6; max-width: 300px; }
    .footer-links { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; }
    .link-group h5 { font-size: 0.9rem; color: var(--text-heading); margin-bottom: 1.5rem; text-transform: uppercase; letter-spacing: 0.05em; }
    .link-group a { display: block; text-decoration: none; color: var(--text-muted); font-size: 0.9rem; margin-bottom: 0.75rem; transition: color 0.15s ease; }
    .link-group a:hover { color: var(--color-primary); }
    
    @media (max-width: 768px) {
      .footer-grid { grid-template-columns: 1fr; gap: 3rem; text-align: center; }
      .footer-brand p { margin: 1.5rem auto 0; }
      .footer-links { grid-template-columns: 1fr; }
      .narrative-title { font-size: 1.8rem; }
      .pricing-grid { gap: 4rem; }
      .pricing-card.popular { transform: scale(1); }
      .pricing-card.popular:hover { transform: translateY(-5px); }
    }
  `]
})
export class LandingPageComponent {
  protected readonly theme = inject(ThemeService);
  protected readonly isMenuOpen = signal(false);

  toggleMenu() { this.isMenuOpen.set(!this.isMenuOpen()); }
}
