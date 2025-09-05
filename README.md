# GenderBias-Benchmarks-Generalize

Repository with code, additional results and SAGE evaluation suite for the ICASSP 2025 paper "Do Bias Benchmarks Generalise? Evidence from Evaluation of Voice Gender Bias in SpeechLLMs".

## 🌐 Project Website

This repository hosts a GitHub Pages website showcasing our research. The website includes:

- **Abstract and Overview**: Complete paper summary
- **Interactive Results**: Key findings with metrics and performance data
- **PDF Plot Placeholders**: Ready for publication-quality visualizations
- **Code Downloads**: Access to evaluation scripts, SAGE suite, and analysis notebooks
- **Citation Information**: Easy-to-copy BibTeX format

### Website Features

- 📊 **Results Dashboard**: Interactive metrics display with placeholder for real data
- 📈 **Plot Gallery**: Four placeholder sections for PDF research plots
- 💻 **Code Repository**: Organized download links for different code components
- 📝 **Citation Tools**: One-click citation copying
- 📱 **Responsive Design**: Works on desktop and mobile devices

## 🚀 Getting Started

### Viewing the Website

The website is automatically deployed via GitHub Pages. Once enabled, it will be available at:
`https://shreeharsha-bs.github.io/GenderBias-Benchmarks-Generalize/`

### Local Development

To run the website locally:

```bash
# Clone the repository
git clone https://github.com/shreeharsha-bs/GenderBias-Benchmarks-Generalize.git
cd GenderBias-Benchmarks-Generalize

# Start a local web server
python3 -m http.server 8000

# Open in browser
open http://localhost:8000
```

## 📁 Repository Structure

```
├── index.html              # Main website page
├── styles.css              # Website styling
├── script.js               # Interactive functionality
├── assets/
│   ├── pdfs/               # PDF plots (to be added)
│   ├── code/               # Code documentation
│   └── images/             # Website images
├── .github/
│   └── workflows/
│       └── pages.yml       # GitHub Pages deployment
└── README.md               # This file
```

## 📊 Adding Content

### PDF Plots

1. Add PDF files to `assets/pdfs/`
2. Update the HTML to replace placeholders with actual PDF embeds:
   ```html
   <embed src="assets/pdfs/your-plot.pdf" type="application/pdf" width="100%" height="400px">
   ```

### Research Data

Update the metrics in `index.html` by replacing placeholder values like `[XX%]` with actual results.

### Code Files

Add actual code archives to `assets/code/` and update the download links in `index.html`.

## 🔧 Customization

### Colors and Styling

The website uses a professional gradient color scheme. Modify `styles.css` to change:
- Primary colors (currently purple gradient)
- Typography (currently Inter font)
- Layout and spacing

### Content Sections

The website includes these main sections:
- Header with title and navigation
- Abstract
- Results & Analysis
- Code & Resources
- Citation

Add or modify sections by editing `index.html` and updating the corresponding CSS.

## 📝 Citation

```bibtex
@inproceedings{genderbias2025,
  title={Do Bias Benchmarks Generalise? Evidence from Evaluation of Voice Gender Bias in SpeechLLMs},
  author={[Authors]},
  booktitle={ICASSP 2025},
  year={2025}
}
```

## 🤝 Contributing

This is a research project repository. For questions about the research or website, please open an issue.

## 📄 License

[Add license information as appropriate]
