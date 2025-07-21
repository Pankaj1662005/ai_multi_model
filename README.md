# 🧠 Multi Ai Models– ML/NLP-Driven Mobile App

A cross-platform mobile application built with Flutter that integrates **four intelligent ML/NLP models**, each hosted on **Hugging Face Spaces** and accessible via **REST APIs**. The project combines cutting-edge deep learning, UI/UX design, and full-stack deployment into a unified system.

---

## 📲 Tech Stack

- **Frontend**: Flutter (cross-platform UI), Firebase Auth
- **Backend/ML Models**: Python, PyTorch, Scikit-learn, Transformers
- **APIs**: RESTful services using cURL
- **Hosting**: Hugging Face Spaces + Gradio interfaces
- **CI/CD**: Git, GitHub
- **Other**: Cloud deployment, Model integration, Agile practices

---

## 🧩 Multi-Model Architecture

This project features **4 AI models**, each addressing a unique NLP or regression task:

### 1. 🎓 Grade Predictor
- **Type**: Regression
- **Tech**: Linear Regression, Ridge, Lasso (Scikit-learn)
- **Use**: Predicts student grades based on input parameters.

### 2. 📬 Email Classifier
- **Type**: Text Classification
- **Tech**: CNN-based NLP model
- **Use**: Classifies emails into categories like personal, spam, work, etc.

### 3. ✍️ Quote Generator
- **Type**: Text Generation
- **Tech**: Markov Chains
- **Use**: Generates motivational quotes based on web-scraped data.

### 4. 📖 Story Generator
- **Type**: Transformer-based Generator
- **Tech**: Custom Transformer built with PyTorch
- **Use**: Generates creative stories from user prompts.

Each model is:
- Packaged using **Gradio** for interactive web UI
- Hosted via **Hugging Face Spaces**
- Accessed from the Flutter app using **cURL API requests**

---

## 📁 Project Structure (Main Level)

```plaintext
├── android/                 # Android native files
├── assets/                 # App assets (animations, UI elements)
├── ios/                    # iOS native files
├── lib/                    # All Dart/Flutter source code
├── test/                   # Widget test files
├── pubspec.yaml            # Flutter dependencies
├── README.md               # This file
├── .gitignore              # Git ignore rules
````

---

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Pankaj1662005/ai_multi_model.git
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

* Ensure Firebase is connected in `pubspec.yaml`.

### 4. Run the App

```bash
flutter run
```

---

## 🌐 Model Integration Flow

1. User inputs are collected via the Flutter UI.
2. A **cURL-based REST API call** is made to the Hugging Face model endpoint.
3. The response is parsed and displayed in the UI.

---

## 🎨 Screens and Features

* 🔐 **Authentication**: Firebase login & registration
* 🏠 **Home Page**: Navigate to all 4 models
* 📊 **Prediction Screens**: Individual interfaces for each model
* ⚙️ **Settings Page**: UI customizations

---

## ✅ Features

* Full-stack ML integration
* Cross-platform deployment (Android/iOS)
* Responsive and animated UI (Flutter)
* Real-time API communication
* Model hosting with Hugging Face + Gradio

---

## 🚀 Future Enhancements

* Add GPT-based model via OpenAI API
* Enable offline prediction caching
* Add user analytics and feedback system

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

---

## 📄 License

[MIT](LICENSE)

---

## 👨‍💻 Author

**Pankaj Kumar**
Data Science @ Thapar
DSA Enthusiast | ML/NLP Developer | Flutter Dev
GitHub: [pankaj2005](https://github.com/pankaj2005)

