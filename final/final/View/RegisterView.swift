//
//  RegisterView.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm: RegisterViewModel
    @State private var showPassword = false

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    Text("Регистрация")
                        .font(.montserrat(.bold, size: 32))
                        .foregroundColor(.accent)

                    VStack(spacing: 20) {
                        TextField("Телефон", text: $vm.phone)
                            .keyboardType(.phonePad)
                            .underlineField()

                        TextField("Email", text: $vm.email)
                            .keyboardType(.emailAddress)
                            .underlineField()

                        TextField("Имя пользователя", text: $vm.username)
                            .underlineField()

                        TextField("Город", text: $vm.city)
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

                            Button { showPassword.toggle() } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.accent)
                            }
                        }
                    }

                    Button(action: vm.register) {
                        if vm.loading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Создать аккаунт")
                                .font(.montserrat(.medium, size: 18))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                    }
                    .background(vm.loading ? Color.accent.opacity(0.5) : Color.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(vm.loading)
                }
                .padding(.horizontal, 32)
                .padding(.top, 92)
            }
        }
        .alert(item: $vm.alertItem) { Alert(title: Text($0.message)) }
    }
}

#Preview {
    let router = AppRouter()
    let vm = RegisterViewModel(router: router)
    RegisterView(vm: vm)
}
