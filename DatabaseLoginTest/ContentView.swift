////
////  ContentView.swift
////  DatabaseLoginTest
////
////  Created by Arsen on 15.02.2023.
////
//
//import SwiftUI
//import Firebase
//
//struct ContentView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @State private var userIsLoggedIn = false
//
//    var body: some View {
//        if userIsLoggedIn {
//            ListView()
//        } else {
//            content
//        }
//    }
//
//    var content: some View {
//        ZStack {
//            VStack(spacing: 20) {
//                Text("Welcome")
//                    .font(.system(size: 40, weight: .bold, design: .rounded))
//                    .offset(y: -20)
//                TextField("Email", text: $email)
//                    .textFieldStyle(.plain)
//                    .placeholder(when: email.isEmpty) {
//                        Text("Email")
//                            .bold()
//                    }
//                Rectangle()
//                    .frame(width: 350, height: 1)
//
//
//                SecureField("Password", text: $password)
//                    .textFieldStyle(.plain)
//                    .placeholder(when: password.isEmpty) {
//                        Text("Password")
//                            .bold()
//                    }
//
//                Rectangle()
//                    .frame(width: 350, height: 1)
//
//                Button {
//                    register()
//                } label: {
//                    Text("sign up")
//                        .bold()
//                        .frame(width: 200, height: 40)
//                        .foregroundColor(.black)
//                }
//
//                Button {
//                    login()
//                } label: {
//                    Text("already have an account? login")
//                        .bold()
//                        .foregroundColor(.black)
//                }
//
//
//            }
//            .frame(width: 350)
//            .onAppear {
//                Auth.auth().addStateDidChangeListener { auth, user in
//                    if user != nil {
//                        userIsLoggedIn.toggle()
//                    }
//                }
//            }
//        }
//    }
//
//    func login() {
//        Auth.auth().signIn(withEmail: email, password: password) {
//            result, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        }
//    }
//
//    func register() {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading,
//        @ViewBuilder placeholder: () -> Content) -> some View {
//
//        ZStack(alignment: alignment) {
//            placeholder().opacity(shouldShow ? 1 : 0)
//            self
//        }
//    }
//}
