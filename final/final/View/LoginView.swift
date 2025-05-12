//
//  LoginView.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    @State private var showPassword = false

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()

            VStack(spacing: 32) {
                // Лого-текст
                Text("Wheelix")
                    .font(.montserrat(.bold, size: 32))
                    .foregroundColor(.accent)

                VStack(spacing: 20) {
                    TextField("Телефон", text: $vm.phone)
                        .keyboardType(.phonePad)
                        .underlineField()

                    HStack {
                        Group {
                            if showPassword {
                                TextField("Пароль", text: $vm.password)
                            } else {
                                SecureField("Пароль", text: $vm.password)
                            }
                        }
                        .underlineField()

                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.accent)
                        }
                    }
                }

                Button(action: vm.login) {
                    if vm.loading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Войти")
                            .font(.montserrat(.medium, size: 18))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                }
                .background(vm.loading ? Color.accent.opacity(0.5) : Color.accent)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(vm.loading)

                HStack(spacing: 6) {
                    Text("Нет аккаунта?")
                        .font(.montserrat(.light, size: 14))
                        .foregroundColor(.gray)
                    Button("Регистрация") { vm.goToRegister() }
                        .font(.montserrat(.medium, size: 14))
                        .foregroundColor(.accent)
                }
            }
            .padding(.horizontal, 32)
        }
        .alert(item: $vm.alertItem) { Alert(title: Text($0.message)) }
    }
}

#Preview {
    let router = AppRouter()
    let vm = LoginViewModel(router: router)
    LoginView(vm: vm)
}
