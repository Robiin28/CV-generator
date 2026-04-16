import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class PdfService {
  /**
   * Generates and downloads a PDF from the provided HTML element.
   */
  async exportToPdf(element: HTMLElement, fileName: string = 'resume.pdf'): Promise<void> {
    try {
      const opt = {
        margin: [15, 0],
        filename: fileName,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2, useCORS: true },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
        pagebreak: { mode: ['avoid-all', 'css', 'legacy'] }
      };
      
      // Use the globally injected html2pdf script (bypasses all Angular compiler module errors)
      if (!(window as any).html2pdf) {
        alert('PDF generator library failed to load from the internet! Please check your connection or ad-blocker.');
        return;
      }
      
      await (window as any).html2pdf().set(opt).from(element).save();
    } catch (error) {
      console.error('Error generating PDF:', error);
      alert('Failed to generate PDF. Please try again.');
    }
  }
}
