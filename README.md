# ResumeForge — AI-Powered CV Builder

A free, open-source resume builder built with **Angular 18**. Create professional, ATS-optimized resumes in minutes and export a polished PDF with one click.

## Features

- 🎨 **Professional Templates** — Includes the official Europass layout and modern alternatives
- 🤖 **AI Writing Assistant** — AI-powered suggestions to improve your bullet points
- 📄 **PDF Export** — High-fidelity, multi-page PDF export with consistent formatting
- 🌗 **Light & Dark Mode** — Persistent theme toggle across the entire application
- 🔐 **Authentication** — Login and registration with session persistence
- 📱 **Responsive Design** — Clean, professional UI that works across screen sizes

## Tech Stack

- **Framework**: Angular 18 (Standalone Components)
- **Styling**: Tailwind CSS + Vanilla CSS
- **AI**: Google Gemini API
- **PDF Export**: jsPDF + html2canvas
- **Fonts**: Inter, Montserrat, Roboto (Google Fonts)

## Getting Started

### Prerequisites
- Node.js 18+
- npm 9+

### Installation

```bash
# Clone the repository
git clone https://github.com/Robiin28/CV-generator.git
cd CV-generator

# Install dependencies
npm install

# Start the development server
npm start
```

Open [http://localhost:4200](http://localhost:4200) in your browser.

## Project Structure

```
src/
├── app/
│   ├── core/
│   │   ├── guards/          # Auth guard
│   │   └── services/        # Auth, AI, PDF, Theme services
│   ├── features/
│   │   ├── auth/            # Login & Register pages
│   │   ├── builder/         # CV Builder wizard
│   │   ├── dashboard/       # User dashboard
│   │   ├── landing/         # Landing page
│   │   └── templates/       # Template gallery & Europass template
│   ├── layout/              # Sidebar & Top navigation
│   └── shared/              # Shared components
└── styles.css               # Global styles & design tokens
```

## Scripts

| Command | Description |
|---|---|
| `npm start` | Start development server |
| `npm run build` | Build for production |
| `npm test` | Run unit tests |

## License

MIT — free to use .
