//
//  AuthView.swift
//  final
//
//  Created by Алан Абзалханулы on 22.04.2025.
//
import SwiftUI

struct AuthView: View {
    @StateObject private var vm = AuthViewModel()

    var body: some View {
        ZStack {

            LinearGradient(colors: [Theme.purple, Theme.purpleLight],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {

                VStack(spacing: 8) {
                    Image(systemName: "calendar.circle.fill")
                        .resizable().scaledToFit()
                        .frame(width: 72)
                        .foregroundStyle(.white.opacity(0.9))
                    Text("Habit Tracker")
                        .font(Theme.font(32, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 60)


                VStack(spacing: 20) {
                    Picker(selection: $vm.isRegisterMode) {
                        Text("Login").tag(false)
                        Text("Sign Up").tag(true)
                    } label: { }
                      .pickerStyle(.segmented)

                    Group {
                        TextField("Username", text: $vm.username)
                        if vm.isRegisterMode {
                            TextField("Email", text: $vm.email)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                        }
                        SecureField("Password", text: $vm.password)
                    }
                    .textFieldStyle(.plain)
                    .padding(.horizontal)
                    .frame(height: 44)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(12)

                    if let err = vm.error {
                        Text(err).foregroundStyle(.red).font(.footnote)
                    }

                    Button(action: vm.submit) {
                        if vm.isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                        } else {
                            Text(vm.isRegisterMode ? "Create account" : "Login")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(LinearGradient(colors: [Theme.purple, Theme.purpleDark],
                                               startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .disabled(vm.isLoading)
                }
                .padding(24)
                .background(Theme.card)
                .cornerRadius(28)
                .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)

                Spacer()
            }
        }
        .font(Theme.font(17))
    }
}

#Preview {
    AuthView()
}
