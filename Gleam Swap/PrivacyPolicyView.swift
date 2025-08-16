import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "lock.shield")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding(.bottom, 20)
                    
                    .font(.subheadline)
                    .foregroundColor(.gray)

                    Text("Last Updated: \(formattedDate)")
                                           .font(.subheadline)
                                           .foregroundColor(.gray)

                
                    
                    Text("SecurePass is committed to protecting your privacy. This Privacy Policy explains how we handle your data when you use our password generator application.")
                        .padding(.bottom)
                    
                    PolicySection(title: "1. Data Collection", icon: "magnifyingglass") {
                        Text("SecurePass does not collect, store, or transmit any of your generated passwords or personal information. All password generation occurs locally on your device.")
                    }
                    
                    PolicySection(title: "2. No Tracking", icon: "eye.slash") {
                        Text("We do not track your usage of the app. No analytics or usage data is collected or shared with third parties.")
                    }
                    
                    PolicySection(title: "3. Security", icon: "lock.fill") {
                        Text("All password generation is performed locally on your device. We do not have access to your generated passwords or any information about them.")
                    }
                    
                    PolicySection(title: "4. Changes to This Policy", icon: "calendar") {
                        Text("We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.")
                    }
                    
               
                    
                    Spacer()
                    
                  
                }
                .padding()
            }
            .navigationBarTitle("Privacy Policy", displayMode: .inline)
         
        }
    }
}

struct PolicySection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
            }
            
            content
                .font(.body)
                .padding(.leading, 24)
                .padding(.top, 4)
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
