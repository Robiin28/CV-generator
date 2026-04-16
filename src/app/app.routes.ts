import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./features/landing/landing-page.component')
      .then(m => m.LandingPageComponent),
    pathMatch: 'full'
  },
  {
    path: 'login',
    loadComponent: () => import('./features/auth/login.component')
      .then(m => m.LoginComponent)
  },
  {
    path: 'register',
    loadComponent: () => import('./features/auth/register.component')
      .then(m => m.RegisterComponent)
  },
  {
    path: 'builder',
    canActivate: [authGuard],
    loadComponent: () => import('./features/builder/pages/builder-page.component')
      .then(m => m.BuilderPageComponent)
  },
  {
    path: 'templates',
    loadComponent: () => import('./features/templates/template-gallery.component')
      .then(m => m.TemplateGalleryComponent)
  },
  {
    path: 'dashboard',
    canActivate: [authGuard],
    loadComponent: () => import('./features/dashboard/dashboard.component')
      .then(m => m.DashboardComponent)
  },
  {
    path: 'my-cvs',
    redirectTo: 'dashboard',
    pathMatch: 'full'
  },
  {
    path: 'analytics',
    canActivate: [authGuard],
    loadComponent: () => import('./shared/components/feature-view.component')
      .then(m => m.FeatureViewComponent),
    data: { title: 'Analytics & Insights' }
  },
  {
    path: 'settings',
    canActivate: [authGuard],
    loadComponent: () => import('./shared/components/feature-view.component')
      .then(m => m.FeatureViewComponent),
    data: { title: 'Account Settings' }
  }
];
