import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var rotation: Double = 0
    @State private var gradientPosition: CGFloat = -1
    @State private var opacity: Double = 1
    @State private var isAnimating = false
    
    let gradientColors: [Color] = [.teall, .orange, .yellow, .blue, .cyann, .indigoo]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all )
            
            VStack(spacing: 30) {
                // Animated Image
                Image("11")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: UnitPoint(x: gradientPosition, y: 0),
                            endPoint: UnitPoint(x: gradientPosition + 1, y: 1)
                        )
                        .mask(
                            Image("11")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        )
                    )
                
       
                Text("Gleem Swap")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: UnitPoint(x: gradientPosition, y: 0),
                            endPoint: UnitPoint(x: gradientPosition + 1, y: 1)
                        )
                        .mask(
                            Text("Gleem Swap")
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                        )
                    )
                    .scaleEffect(scale * 1.2)
            }
            .opacity(opacity)
        }
        .onAppear {
            startAnimations()
            
            // Dismiss after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeOut(duration: 0.8)) {
                    opacity = 0
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).repeatForever(autoreverses: true)) {
            scale = 1.1
        }
        
        withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            gradientPosition = 1
        }
    }
}

#Preview {
    SplashView()
}
