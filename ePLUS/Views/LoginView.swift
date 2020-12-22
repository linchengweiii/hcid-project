//
//  LoginView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/17.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData

    @State var account: String
    @State var password: String
    
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false
    
    var body: some View {
        NavigationView() {
            VStack() {
                Text("Trip Together")
                    .font(.largeTitle)
                    .shadow(radius: 10.0, x: 20, y: 10)
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .padding(.bottom, 50)
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    TextField("Account", text: self.$account)
                        .autocapitalization(.none)
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 5.0, x: 10, y: 5)
                    
                    SecureField("Password", text: self.$password)
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 5.0, x: 10, y: 5)
                    
                    NavigationLink(
                        destination: MainView(account: self.account, isLoginValid: self.$isLoginValid),
                        isActive: self.$isLoginValid,
                        label: {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                                .onTapGesture {
                                    if verifyUser(account: self.account, password: self.password) {
                                        isLoginValid = true
                                        UserDefaults.standard.set(self.account, forKey: "account")
                                        UserDefaults.standard.set(self.password, forKey: "password")
                                    }
                                    if !isLoginValid {
                                        self.shouldShowLoginAlert = true //trigger Alert
                                    }
                                }
                    })
                }.padding([.leading, .trailing], 27.5)
                
                Spacer()
            }
        }
        .onAppear(perform: checkIfLoginBefore)
        .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
        .alert(isPresented: $shouldShowLoginAlert) {
            Alert(title: Text("Account/Password incorrect"))
        }
    }
    
    func checkIfLoginBefore() {
        self.isLoginValid = false
        
        let group = DispatchGroup()
        
        group.enter()
        var fetchedPassword: String? = nil
        API().getUser(userAccount: account) { result in
            switch result {
            case .success(let user):
                fetchedPassword = user.password
            case .failure:
                break
            }
            group.leave()
        }
        group.wait()
        
        if fetchedPassword == password {
            self.isLoginValid = true
        }
    }
    
    
    func verifyUser(account: String, password: String) -> Bool {
        let group = DispatchGroup()
        
        group.enter()
        var fetchedPassword: String? = nil
        API().getUser(userAccount: account) { result in
            switch result {
            case .success(let user):
                fetchedPassword = user.password
            case .failure:
                break
            }
            group.leave()
        }
        group.wait()
        
        
        
        return password == fetchedPassword
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(account: "guest", password: "guest")
    }
}
