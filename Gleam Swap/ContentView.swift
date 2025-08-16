import SwiftUI

@available(iOS 13.0,*)
struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                AngularGradient(
                    gradient: Gradient(colors: [.blue, .purple, .cyann]),
                    center: .topLeading,
                    angle: .degrees(225)
                )
                .edgesIgnoringSafeArea(.all)
                
                ParticleView()
                    .opacity(0.3)
                
                VStack(spacing: 30) {
                
                    VStack(spacing: 10) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text("Gleem Swap")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 3)
                        
                        Text("Secure Password Generator")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 50)
                    
                    // Main action buttons
                    VStack(spacing: 20) {
                        NavigationLink(destination: PasswordGeneratorView()) {
                            FancyButton(
                                title: "Secure Pass",
                                icon: "key.fill",
                                color: .blue
                            )
                        }
                        
                        NavigationLink(destination: AboutView()) {
                            FancyButton(
                                title: "About App",
                                icon: "info.circle.fill",
                                color: .purple
                            )
                        }
                        
                        NavigationLink(destination: PrivacyPolicyView()) {
                            FancyButton(
                                title: "Privacy Policy",
                                icon: "lock.shield.fill",
                                color: .indigoo
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Footer
                    Text("v1.0.0")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tintt)
    }
}

struct FancyButton: View {
    let title: String
    let icon: String
    let color: Color
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                // Button background
                RoundedRectangle(cornerRadius: 15)
                    .fill(color.opacity(0.7))
                    .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 5)
                
                // Shine effect
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 30)
                    .offset(x: isPressed ? 200 : -100, y: 0)
            }
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .onLongPressGesture(
            minimumDuration: .infinity,
            maximumDistance: .infinity,
            pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
            },
            perform: {}
        )
    }
}

struct ParticleView: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var speed: CGFloat
        var opacity: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color.white)
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                // Create particles
                for _ in 0..<30 {
                    particles.append(
                        Particle(
                            x: CGFloat.random(in: 0..<geometry.size.width),
                            y: CGFloat.random(in: 0..<geometry.size.height),
                            size: CGFloat.random(in: 2..<8),
                            speed: CGFloat.random(in: 0.5..<2),
                            opacity: Double.random(in: 0.1..<0.5)
                        )
                    )
                }
                
                // Animate particles
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                    for i in particles.indices {
                        particles[i].y += geometry.size.height * particles[i].speed
                        if particles[i].y > geometry.size.height {
                            particles[i].y = -10
                            particles[i].x = CGFloat.random(in: 0..<geometry.size.width)
                        }
                    }
                }
            }
        }
    }
}

// Preview with different color schemes
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           
            
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
