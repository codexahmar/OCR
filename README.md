# 🧮 SnapSolve
> Capture. Compute. Instantly.

**SnapSolve** is a Flutter-based mobile application that uses **Optical Character Recognition (OCR)** and **mathematical expression parsing** to extract and solve arithmetic problems directly from images.

Whether it’s handwritten notes or printed math problems — simply **take a picture**, and the app instantly computes the results for you.

---

## ✨ Features

- 📸 **Image-based arithmetic detection**  
  Upload or capture an image containing arithmetic expressions — the app reads and solves it automatically.

- 🧠 **Smart expression evaluation**  
  Supports addition, subtraction, multiplication, division, and even **nested parentheses & decimals**.

- ⚙️ **Real-time processing**  
  Lightweight, fast, and optimized OCR + math engine.

- 💾 **Result summary**  
  Displays row-wise and grand total results for multi-expression grids.

- 🧭 **Beautiful modern UI**  
  Designed with **Orbitron typography**, **soft gradients**, and **animated buttons** for a futuristic tech vibe.

---

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-------------|
| Framework | Flutter |
| State Management | Provider |
| OCR Engine | Google Gemini (Text Recognition) |
| Math Parsing | Custom Expression Evaluator |


---

## 🚀 How It Works

1. **Capture / Upload** an image with arithmetic expressions (e.g., `10 + 5`, `(3+2)*4`)
2. The app performs **OCR extraction** using Google Gemini
3. Extracted text is **parsed and validated** for arithmetic symbols
4. Each expression is **computed** using the math engine
5. **Results are displayed** neatly with row-wise totals and grand total

---

## 🧩 Example Test Cases

| Expression | Result |
|-------------|---------|
| 5 + 2 * 3 | 11 |
| (8 - 3) * 2 | 10 |
| 10 / 4 | 2.5 |
| ((5+5)*2) | 20 |

**Grand Total Example:**  
All results combined → **43.5**

---

## 📱 Screens

| Screen | Description |
|---------|--------------|
| Splash Screen | Animated logo and app title |
| Home Screen | Upload/Capture image and preview |
| Result Screen | Display extracted expressions and results |





