import { Injectable, signal, computed } from '@angular/core';

export interface User {
  id: string;
  email: string;
  name: string;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly userSignal = signal<User | null>(null);
  
  readonly currentUser = this.userSignal.asReadonly();
  readonly isAuthenticated = computed(() => !!this.userSignal());

  constructor() {
    const savedUser = localStorage.getItem('resumeforge_user');
    if (savedUser) {
      this.userSignal.set(JSON.parse(savedUser));
    }
  }

  login(email: string, password: string): boolean {
    // Mock login logic
    const mockUser: User = { id: '1', email, name: email.split('@')[0] };
    this.userSignal.set(mockUser);
    localStorage.setItem('resumeforge_user', JSON.stringify(mockUser));
    return true;
  }

  register(email: string, name: string): boolean {
    // Mock registration logic
    const mockUser: User = { id: '1', email, name };
    this.userSignal.set(mockUser);
    localStorage.setItem('resumeforge_user', JSON.stringify(mockUser));
    return true;
  }

  logout(): void {
    this.userSignal.set(null);
    localStorage.removeItem('resumeforge_user');
  }
}
