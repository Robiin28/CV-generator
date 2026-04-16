import { Injectable } from '@angular/core';
import { Resume } from '../models/resume.model';

@Injectable({
  providedIn: 'root'
})
export class StorageService {
  private readonly STORAGE_KEY = 'resumeforge_data';

  saveResumes(resumes: Resume[]): void {
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(resumes));
  }

  getResumes(): Resume[] {
    const data = localStorage.getItem(this.STORAGE_KEY);
    return data ? JSON.parse(data) : [];
  }

  saveCurrentResume(resume: Resume): void {
    const resumes = this.getResumes();
    const index = resumes.findIndex(r => r.id === resume.id);
    
    if (index !== -1) {
      resumes[index] = resume;
    } else {
      resumes.push(resume);
    }
    
    this.saveResumes(resumes);
  }

  deleteResume(id: string): void {
    const resumes = this.getResumes().filter(r => r.id !== id);
    this.saveResumes(resumes);
  }
}
