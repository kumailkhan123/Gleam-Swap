import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // App Icon and Name
                    VStack(spacing: 15) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Text("Gleam Swap")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Password Generator")
                            .font(.custom("times", size: 24).bold())
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    // Version Info
                    VStack(alignment: .leading, spacing: 10) {
                        InfoRow(icon: "number", title: "Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        
                        InfoRow(icon: "gear", title: "Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                        
                        InfoRow(icon: "iphone", title: "Compatibility", value: "iOS 13+")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About SecurePass")
                            .font(.headline)
                        
                        Text("SecurePass is a secure password generator that helps you create strong, unique passwords for all your accounts. All password generation happens locally on your device for maximum privacy.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Developer Info
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Developer")
                            .font(.headline)
                        
                        InfoRow(icon: "person.fill", title: "Name", value: "Gleam Swap")
                        
                      
                        
                      
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Footer
                    Text("© \(Calendar.current.component(.year, from: Date())) Gleam Swap. All rights reserved.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .padding()
            }
            .navigationBarTitle("About", displayMode: .inline)
         
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.blue)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .preferredColorScheme(.dark)
    }
}
