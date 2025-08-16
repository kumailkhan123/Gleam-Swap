import SwiftUI
import AVFoundation
import UIKit

@available(iOS 13.0,*)
struct PasswordGeneratorView: View {
    // Password Configuration (keep all your original state variables)
    @State private var lowercaseEnabled = true
    @State private var uppercaseEnabled = true
    @State private var numbersEnabled = true
    @State private var symbolsEnabled = true
    @State private var uniqueCharsEnabled = false
    @State private var omitYZEnabled = false
    @State private var passwordLength: Double = 20
    @State private var passwordCount: Int = 4
    @State private var generatedPasswords: [String] = [""]
    
    // App State (keep all your original state variables)
    @State private var showingInfo = false
    @State private var showingResetConfirmation = false
    @State private var showingImageSavedAlert = false
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var activeTab: Tab = .generator
    
    // Symbol list (keep your original)
    private let symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?/~"
    
    enum Tab {
        case generator, settings
    }
    
    var body: some View {
        ZStack {
            // Updated Background - softer gradient
            LinearGradient(gradient: Gradient(colors: [Color(.indigoo).opacity(0.4), Color(.secondarySystemBackground)]),
                          startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {

                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "key.fill")
                            .font(.custom("times", size: 14).bold())
                            .foregroundColor(.blue)
                        
                        Text("SecurePass")
                            .font(.custom("times", size: 36).bold())
                            .foregroundColor(Color("indigoo"))
                        
                        Spacer()
                        
                        Button(action: { showingInfo = true }) {
                            Image(systemName: "info.circle")
                                .font(.custom("times", size: 27).bold())     .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .background(Color.black.opacity(0.1))
             
                                HStack {
                        TabButton(title: "Generator", icon: "key.fill", isActive: activeTab == .generator) {
                            activeTab = .generator
                        }
                                    Spacer()
                        TabButton(title: "Settings", icon: "slider.horizontal.3", isActive: activeTab == .settings) {
                            activeTab = .settings
                        }
                    }
                    
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Main Content - same functionality, updated visuals
                ScrollView {
                    if activeTab == .generator {
                        generatorTab
                            .padding(.top, 8)
                    } else {
                        settingsTab
                            .padding(.top, 8)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        // Keep all your original alerts and sheets
        .alert(isPresented: $showingImageSavedAlert) {
            Alert(title: Text("Success"), message: Text("Passwords saved to photos"), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingInfo) {
            InfoView()
        }
        .alert(isPresented: $showingResetConfirmation) {
            Alert(
                title: Text("Reset Settings"),
                message: Text("Are you sure you want to reset all settings to default?"),
                primaryButton: .destructive(Text("Reset")) {
                    resetToDefaults()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            ActivityViewController(activityItems: shareItems)
        }
        .onAppear(perform: generatePasswords)
    }
    
    // MARK: - Subviews (updated visuals but same functionality)
    
    private var generatorTab: some View {
        VStack(spacing: 20) {
            // Password Display Cards - updated design
            if !generatedPasswords.isEmpty {
                VStack(spacing: 16) {
                    ForEach(generatedPasswords.indices, id: \.self) { index in
                        PasswordCard(
                            password: generatedPasswords[index],
                            index: index,
                            onSpeak: { speakPassword(generatedPasswords[index]) },
                            onCopy: { UIPasteboard.general.string = generatedPasswords[index] },
                            onShare: {
                                shareItems = [generatedPasswords[index]]
                                showingShareSheet = true
                            }
                        )
                        .padding(.horizontal)
                    }
                }
            }
            
            // Generate Button - updated style
            Button(action: generatePasswords) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Generate New Passwords")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal)
            
            // Bulk Actions - updated style
            if !generatedPasswords.isEmpty {
                HStack(spacing: 15) {
                    Button(action: copyAllPasswords) {
                        HStack {
                            Image(systemName: "doc.on.doc.fill")
                            Text("Copy All")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        let passwordsToShare = generatedPasswords.enumerated().map { "Password \($0 + 1): \($1)" }
                        shareItems = passwordsToShare
                        showingShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                            Text("Share All")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var settingsTab: some View {
        VStack(spacing: 20) {
            // Character Options - updated card design
            CardView(title: "CHARACTER SETTINGS", icon: "textformat.abc") {
                VStack(spacing: 15) {
                    ToggleRow(icon: "a.square.fill", title: "Lowercase Letters", isOn: $lowercaseEnabled)
                    ToggleRow(icon: "A.square.fill", title: "Uppercase Letters", isOn: $uppercaseEnabled)
                    ToggleRow(icon: "number.square.fill", title: "Numbers", isOn: $numbersEnabled)
                    ToggleRow(icon: "exclamationmark.square.fill", title: "Symbols", isOn: $symbolsEnabled)
                    
                    if symbolsEnabled {
                        Text("Symbols: \(symbols)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                    }
                }
            }
            .padding(.horizontal)
            
            // Password Options - updated card design
            CardView(title: "PASSWORD OPTIONS", icon: "gearshape.fill") {
                VStack(spacing: 15) {
                    ToggleRow(icon: "checkmark.square.fill", title: "Unique Characters", isOn: $uniqueCharsEnabled)
                    ToggleRow(icon: "x.square.fill", title: "Omit Y and Z", isOn: $omitYZEnabled)
                    
                    StepperRow(
                        icon: "textformat.size",
                        title: "Password Length: \(Int(passwordLength))",
                        value: $passwordLength,
                        range: 4...50
                    )
                    
                    StepperRow(
                        icon: "number",
                        title: "Password Count: \(passwordCount)",
                        value: Binding<Double>(
                            get: { Double(passwordCount) },
                            set: { passwordCount = Int($0) }
                        ),
                        range: 1...10
                    )
                }
            }
            .padding(.horizontal)
            
            // Reset Button - updated style
            Button(action: { showingResetConfirmation = true }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset to Defaults")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.8))
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
    
    private func speakPassword(_ password: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        // Pronunciation dictionary for symbols and numbers
        let pronunciationMap: [Character: String] = [
            "!": "exclamation mark",
            "@": "at symbol",
            "#": "hash",
            "$": "dollar sign",
            "%": "percent",
            "^": "caret",
            "&": "ampersand",
            "*": "asterisk",
            "(": "left parenthesis",
            ")": "right parenthesis",
            "-": "dash",
            "_": "underscore",
            "=": "equals",
            "+": "plus",
            "[": "left bracket",
            "]": "right bracket",
            "{": "left brace",
            "}": "right brace",
            "\\": "backslash",
            "|": "pipe",
            ";": "semicolon",
            ":": "colon",
            "'": "apostrophe",
            "\"": "quote",
            ",": "comma",
            "<": "less than",
            ">": "greater than",
            ".": "dot",
            "?": "question mark",
            "/": "slash",
            "~": "tilde",
            "`": "backtick",
            "0": "zero",
            "1": "one",
            "2": "two",
            "3": "three",
            "4": "four",
            "5": "five",
            "6": "six",
            "7": "seven",
            "8": "eight",
            "9": "nine"
        ]
        
        // Convert each character to its spoken form
        var spokenPassword = ""
        for char in password {
            if let pronunciation = pronunciationMap[char] {
                spokenPassword += " \(pronunciation) "
            } else {
                // For letters, add spaces between characters for clearer pronunciation
                spokenPassword += " \(char) "
            }
        }
        
        // Clean up multiple spaces
        spokenPassword = spokenPassword.replacingOccurrences(of: "  ", with: " ")
        
        let utterance = AVSpeechUtterance(string: spokenPassword)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.3  // Slower rate for better clarity
        utterance.pitchMultiplier = 1.0
        utterance.preUtteranceDelay = 0.1  // Small pause before speaking
        
        // Optional: Configure audio session for better speech quality
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
        }
        
        speechSynthesizer.speak(utterance)
    }
    private struct TabButton: View {
        let title: String
        let icon: String
        let isActive: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .bold))
                        Text(title)
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundColor(isActive ? .blue : .secondary)
                    
                    if isActive {
                        Capsule()
                            .fill(Color.blue)
                            .frame(height: 3)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            }
        }
    }
    
    private struct PasswordCard: View {
        let password: String
        let index: Int
        let onSpeak: () -> Void
        let onCopy: () -> Void
        let onShare: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header with password number and strength indicator
                HStack {
                    Text("PASSWORD \(index + 1)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Strength Indicator with icon
                    HStack(spacing: 4) {
                        Image(systemName: strengthIcon(for: password))
                            .font(.caption)
                        Text(passwordStrength(for: password))
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(strengthColor(for: password))
                }
                
                // Password Display Field - improved visibility
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.tertiarySystemBackground))
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    
                    HStack {
                        Text(password)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                            .padding(.leading, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .minimumScaleFactor(0.5)
                        
                        // Quick copy button
                        Button(action: onCopy) {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                                .padding(8)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .contextMenu {
                    // Copy Button
                    Button(action: onCopy) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy")
                        }
                    }
                    
                    // Share Button
                    Button(action: onShare) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                    }
                    
                    // Speak Button
                    Button(action: onSpeak) {
                        HStack {
                            Image(systemName: "speaker.wave.2")
                            Text("Speak")
                        }
                    }
                }
                
                // Action Buttons - improved layout
                HStack(spacing: 10) {
                    ActionButton(
                        icon: "speaker.wave.2",
                        label: "Speak",
                        color: .blue,
                        action: onSpeak
                    )
                    
                    ActionButton(
                        icon: "doc.on.doc",
                        label: "Copy",
                        color: .green,
                        action: onCopy
                    )
                    
                    ActionButton(
                        icon: "square.and.arrow.up",
                        label: "Share",
                        color: .purple,
                        action: onShare
                    )
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        
        // MARK: - Password Strength Helpers (keep your original)
        private func passwordStrength(for password: String) -> String {
            let entropy = calculateEntropy(password: password)
            
            switch entropy {
            case ..<28: return "WEAK"
            case 28..<60: return "MODERATE"
            case 60..<100: return "STRONG"
            default: return "VERY STRONG"
            }
        }
        
        private func strengthIcon(for password: String) -> String {
            let entropy = calculateEntropy(password: password)
            
            switch entropy {
            case ..<28: return "exclamationmark.triangle"
            case 28..<60: return "checkmark.shield"
            case 60..<100: return "lock"
            default: return "lock.shield"
            }
        }
        
        private func strengthColor(for password: String) -> Color {
            let entropy = calculateEntropy(password: password)
            
            switch entropy {
            case ..<28: return .red
            case 28..<60: return .orange
            case 60..<100: return .green
            default: return .blue
            }
        }
        
        private func calculateEntropy(password: String) -> Int {
            var poolSize = 0.0
            if password.rangeOfCharacter(from: .lowercaseLetters) != nil { poolSize += 26 }
            if password.rangeOfCharacter(from: .uppercaseLetters) != nil { poolSize += 26 }
            if password.rangeOfCharacter(from: .decimalDigits) != nil { poolSize += 10 }
            if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?/~")) != nil { poolSize += 20 }
            
            return Int(log2(pow(poolSize, Double(password.count))))
        }
    }

    private struct ActionButton: View {
        let icon: String
        let label: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                    Text(label)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(color)
                .cornerRadius(8)
            }
        }
    }
    
    private struct CardView<Content: View>: View {
        let title: String
        let icon: String
        let content: Content
        
        init(title: String, icon: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.icon = icon
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                
                content
            }
            .padding()
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    private struct ToggleRow: View {
        let icon: String
        let title: String
        @Binding var isOn: Bool
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if #available(iOS 14.0, *) {
                    Toggle("", isOn: $isOn)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    private struct StepperRow: View {
        let icon: String
        let title: String
        @Binding var value: Double
        let range: ClosedRange<Double>
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Stepper("", value: $value, in: range)
                    .labelsHidden()
            }
        }
    }
    
    // MARK: - Keep all your original methods exactly as they were
    private func generatePasswords() {
        generatedPasswords.removeAll()
        
        var characters = ""
        if lowercaseEnabled { characters += "abcdefghijklmnopqrstuvwxyz" }
        if uppercaseEnabled { characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
        if numbersEnabled { characters += "0123456789" }
        if symbolsEnabled { characters += symbols }
        
        if omitYZEnabled {
            characters = characters.replacingOccurrences(of: "y", with: "")
            characters = characters.replacingOccurrences(of: "z", with: "")
            characters = characters.replacingOccurrences(of: "Y", with: "")
            characters = characters.replacingOccurrences(of: "Z", with: "")
        }
        
        guard !characters.isEmpty else {
            generatedPasswords = ["Enable at least one character type"]
            return
        }
        
        for _ in 0..<passwordCount {
            if uniqueCharsEnabled {
                generatedPasswords.append(generateUniquePassword(from: characters, length: Int(passwordLength)))
            } else {
                generatedPasswords.append(generateRandomPassword(from: characters, length: Int(passwordLength)))
            }
        }
    }
    
    private func generateRandomPassword(from characters: String, length: Int) -> String {
        String((0..<length).map { _ in characters.randomElement()! })
    }
    
    private func generateUniquePassword(from characters: String, length: Int) -> String {
        var usedChars = Set<Character>()
        var password = ""
        
        while password.count < length {
            if let randomChar = characters.randomElement(), !usedChars.contains(randomChar) {
                password.append(randomChar)
                usedChars.insert(randomChar)
            }
            
            // Fallback if we can't get enough unique characters
            if usedChars.count == characters.count && password.count < length {
                password.append(characters.randomElement()!)
            }
        }
        
        return password
    }
    
    private func copyAllPasswords() {
        let allPasswords = generatedPasswords.enumerated().map { "Password \($0 + 1): \($1)" }.joined(separator: "\n\n")
        UIPasteboard.general.string = allPasswords
    }
    
    private func speakPassword1(_ password: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: password)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
    
    private func resetToDefaults() {
        lowercaseEnabled = true
        uppercaseEnabled = true
        numbersEnabled = true
        symbolsEnabled = true
        uniqueCharsEnabled = false
        omitYZEnabled = false
        passwordLength = 20
        passwordCount = 4
        
        generatePasswords()
    }
    
    private func saveAsImage() {
        guard !generatedPasswords.isEmpty else { return }
        
        let content = PasswordImageView(passwords: generatedPasswords)
        let image = content.snapshot()
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showingImageSavedAlert = true
    }
}

// MARK: - Keep all your helper views and extensions exactly as they were
struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "key.fill")
                            .font(.title)
                            .foregroundColor(Color("PrimaryColor"))
                        
                        Text("About SecurePass")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom, 10)
                    
                    Text("SecurePass helps you create strong, random passwords with customizable options to meet your security needs.")
                        .font(.body)
                    
                    SectionView(title: "Features", icon: "star.fill") {
                        FeatureRow(icon: "textformat.abc", title: "Multiple Character Sets", description: "Include lowercase, uppercase, numbers, and symbols")
                        FeatureRow(icon: "slider.horizontal.3", title: "Customizable Options", description: "Adjust length, count, and special requirements")
                        FeatureRow(icon: "lock.shield", title: "Security Strength", description: "Visual feedback on password strength")
                        FeatureRow(icon: "square.and.arrow.up", title: "Sharing Options", description: "Easily copy or share generated passwords")
                    }
                    
                    SectionView(title: "Security Tips", icon: "shield.fill") {
                        TipRow(icon: "1.circle", text: "Use different passwords for each account")
                        TipRow(icon: "2.circle", text: "Change passwords regularly")
                        TipRow(icon: "3.circle", text: "Consider using a password manager")
                        TipRow(icon: "4.circle", text: "Enable two-factor authentication")
                    }
                    
                    SectionView(title: "Password Strength", icon: "chart.bar.fill") {
                        StrengthLevel(level: "WEAK", color: .red, description: "< 28 bits of entropy")
                        StrengthLevel(level: "MODERATE", color: .orange, description: "28-59 bits")
                        StrengthLevel(level: "STRONG", color: .green, description: "60-99 bits")
                        StrengthLevel(level: "VERY STRONG", color: Color("PrimaryColor"), description: "100+ bits")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Information", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private struct SectionView<Content: View>: View {
        let title: String
        let icon: String
        let content: Content
        
        init(title: String, icon: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.icon = icon
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(Color("PrimaryColor"))
                    Text(title)
                        .font(.headline)
                }
                
                content
            }
            .padding()
            .background(Color("CardBackground"))
            .cornerRadius(12)
        }
    }
    
    private struct FeatureRow: View {
        let icon: String
        let title: String
        let description: String
        
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .foregroundColor(Color("PrimaryColor"))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color("TextSecondary"))
                }
                
                Spacer()
            }
        }
    }
    
    private struct TipRow: View {
        let icon: String
        let text: String
        
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .foregroundColor(Color("PrimaryColor"))
                Text(text)
                    .font(.subheadline)
                Spacer()
            }
        }
    }
    
    private struct StrengthLevel: View {
        let level: String
        let color: Color
        let description: String
        
        var body: some View {
            HStack {
                Text(level)
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .frame(width: 100, alignment: .leading)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color("TextSecondary"))
                
                Spacer()
            }
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct PasswordImageView: View {
    let passwords: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "key.fill")
                    .font(.title)
                Text("SecurePass Generated Passwords")
                    .font(.custom("times", size: 14 ).bold())
                    .fontWeight(.bold)
            }
            .foregroundColor(.black)
            
            ForEach(passwords.indices, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text("Password \(index + 1)")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(passwords[index])
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// MARK: - Preview
@available(iOS 13.0,*)
struct PasswordGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView()
    }
}
