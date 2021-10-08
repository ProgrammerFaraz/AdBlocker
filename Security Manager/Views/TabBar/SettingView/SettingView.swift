import SwiftUIX

struct SettingView: View {

    var body: some View {
        VStack() {
            Spacer()
                .frame(height: 50)
            HStack(){
                Spacer()
                Text("Ad Blocker")
                    .font(.title)
                Spacer()
            }
            
        }
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
