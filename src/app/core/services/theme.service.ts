import { Injectable, signal, effect } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private readonly STORAGE_KEY = 'rf_theme_mode';
  
  // Initialize from localStorage or default to light
  isDarkMode = signal<boolean>(localStorage.getItem(this.STORAGE_KEY) === 'dark');

  constructor() {
    // Persist changes to localStorage
    effect(() => {
      localStorage.setItem(this.STORAGE_KEY, this.isDarkMode() ? 'dark' : 'light');
    });
  }

  toggleTheme() {
    this.isDarkMode.update(dark => !dark);
  }

  setTheme(isDark: boolean) {
    this.isDarkMode.set(isDark);
  }
}
