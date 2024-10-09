import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                ContentView() // Your main app content goes here
            } else {
                VStack {
                    Image(systemName: "sparkles") // Replace with your app logo or image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("Your App Name")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            // Simulate a splash screen delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Welcome to the App")
            .padding()
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
