# 🔒 Gleam Swap - SecurePass

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift" alt="Swift Version">
  <img src="https://img.shields.io/badge/iOS-13%2B-blue?style=for-the-badge&logo=apple" alt="iOS Version">
  <img src="https://img.shields.io/badge/Privacy-First-green?style=for-the-badge&logo=lock" alt="Privacy First">
  <img src="https://img.shields.io/badge/Offline-Secure-lightgrey?style=for-the-badge&logo=shield" alt="Offline Secure">
</p>

<p align="center">
  <strong>SecurePass</strong> — your elegant and powerful iOS companion for generating strong, unique passwords with complete privacy. 
  All magic happens locally on your device — no internet required, no data stored, no prying eyes. ✨
</p>

<p align="center">
  
  <img src="https://github.com/kumailkhan123/Gleam-Swap/blob/main/15pro%20max/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-07%20at%2008.48.40.png"  width="200" alt ="Welcome Screen">
  <img src="https://github.com/kumailkhan123/Gleam-Swap/blob/main/15pro%20max/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-07%20at%2008.59.36.png"  width="200" alt="Password View">
  <img src="https://github.com/kumailkhan123/Gleam-Swap/blob/main/15pro%20max/Simulator%20Screenshot%20-%2015%20-%202025-08-07%20at%2010.52.16.png"  width="200"  alt="About Screen">
</p>

---

## ✨ Features

### 🔐 Security & Privacy
- **🔒 Local Generation** — All passwords created directly on your device; no data sent to servers
- **🌐 No Internet Required** — Works completely offline for ultimate privacy
- **📵 Zero Data Collection** — We don’t track, store, or transmit any of your information
- **🛡️ Strong Encryption** — Uses iOS built-in security frameworks for reliable randomness

### 🎨 User Experience
- **⚡ Instant Generation** — Create secure passwords in milliseconds
- **📋 One-Tap Copy** — Quickly copy passwords to clipboard with a single tap
- **🗣️ Speak Passwords** — Use VoiceOver to hear passwords spoken aloud (accessibility friendly)
- **📤 Easy Sharing** — Securely share passwords via AirDrop, Messages, Mail, and more

### ⚙️ Customization
- **🔤 Character Variety** — Includes uppercase, lowercase, numbers, and symbols
- **📏 Adjustable Length** — Customize password length based on your needs
- **🎭 Readable Formats** — Options to make passwords easier to read and type
- **🌙 Dark Mode Support** — Beautiful interface that respects your iOS theme

---

## 🚀 Getting Started

### Prerequisites

- **iPhone or iPad** running iOS 13 or later
- **Xcode 13+** (for developers)
- **A desire for stronger security!** 🔑


1. ** Build from Source**
   ```bash
   git clone https://github.com/kumailkhan123/Gleam-Swap.git
   cd Gleam-Swap
   open GleamSwap.xcodeproj
   ```
   Then build and run (⌘ + R) in Xcode.

---

## 📖 How to Use

### Creating Your First Password
1. **Open SecurePass** — Tap the Gleam Swap icon on your home screen
2. **Generate Password** — Press the "Generate" button
3. **Copy & Use** — Tap "Copy" and paste into your website or app!
4. **Customize** — Adjust settings for different password requirements

### Advanced Features
- **Multiple Passwords** — Generate several passwords at once for different accounts
- **Share Securely** — Use the share sheet to send passwords via encrypted methods
- **Accessibility** — Enable VoiceOver to hear passwords spoken aloud

---

## 🛠️ For Developers

### Technical Architecture
```swift
// Example: Secure password generation
func generatePassword(length: Int = 16, using symbols: Bool = true) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    let special = "!@#$%^&*()-_=+[]{}|;:,.<>?/"
    
    var characterSet = letters + numbers
    if symbols { characterSet += special }
    
    return String((0..<length).compactMap { _ in characterSet.randomElement() })
}
```

### Project Structure
```
GleamSwap/
├── Sources/
│   ├── Modules/
│   │   ├── PasswordGenerator/
│   │   ├── Settings/
│   │   └── About/
│   ├── Services/
│   │   ├── SecurityService.swift
│   │   ├── ClipboardService.swift
│   │   └── VoiceService.swift
│   ├── Utilities/
│   │   ├── Extensions/
│   │   └── Formatters/
│   └── Resources/
│       ├── Assets.xcassets
│       └── Localizable.strings
```

---

## 👨‍💻 Developer

<div align="center">

### Kumail Abbas

[![GitHub](https://img.shields.io/badge/GitHub-@kumailkhan123-181717?style=for-the-badge&logo=github)](https://github.com/kumailkhan123)
[![Email](https://img.shields.io/badge/Email-kumailabbas3778%40gmail.com-D14836?style=for-the-badge&logo=gmail)](mailto:kumailabbas3778@gmail.com)

**iOS Engineer & Privacy Advocate**  
*Building tools that respect users and protect their data*

</div>

---



## 🤝 Contributing

I love contributions from security enthusiasts and developers!

### How to Help
1. **Report Bugs** — Found an issue? Let us know!
2. **Suggest Features** — Have an idea for improvement?
3. **Improve Code** — Submit pull requests for code enhancements
4. **Spread the Word** — Tell others about SecurePass

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 🔒 Privacy Policy

SecurePass is committed to your privacy:
- 📵 No internet connection required
- 🚫 No data collection of any kind
- 📱 All processing occurs locally on your device
- 🔒 No passwords are stored or transmitted
- 🌐 No analytics or tracking frameworks

Your passwords never leave your device — ever.

---

## ⭐ Why Choose SecurePass?

| Feature | SecurePass | Others |
| :--- | :---: | :---: |
| Offline Operation | ✅ | ❌ |
| Zero Data Collection | ✅ | ❓ |
| Open Source | ✅ | ❌ |
| VoiceOver Support | ✅ | ❓ |
| Customizable | ✅ | ✅ |
| Free Forever | ✅ | ❌ |

---

<div align="center">

### 🔐 Your Security Deserves Better

*Stop trusting your passwords to strangers online. Generate them securely, locally, with style.*


</div>

---

<p align="center">
  Made with ❤️ and Swift for a more secure world
</p>

<p align="center">
  <sub>Because your passwords should be secrets between you and your accounts — not you, your accounts, and some random company.</sub>
</p>

---

## 🎉 Fun Facts

- 🔢 SecurePass can generate over 10^28 unique password combinations
- 🌍 Works anywhere in the world — no internet required
- 🚀 Generates passwords faster than you can blink
- ♿ Fully accessible for visually impaired users
- 🎨 Beautiful interface that doesn't compromise on security

---

*Gleam Swap: Where security meets elegance in every password.* ✨
