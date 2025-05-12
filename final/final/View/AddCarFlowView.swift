//
//  AddCarFlowView.swift
//  final
//
//  Created by Алан Абзалханулы on 12.05.2025.
//

import SwiftUI

// MARK: –– Шаги мастера -----------------------------------------------------

struct AddCarFlowView: View {
    @StateObject private var vm = VM()

    var body: some View {
        NavigationStack(path: $vm.path) {
            Step1Brand(vm: vm)
                .navigationDestination(for: VM.Route.self) { route in
                    switch route {
                    case .specs   : Step2Specs(vm: vm)
                    case .details : Step3Details(vm: vm)
                    case .done    : AddedDoneView()
                    }
                }
                .toolbarBackground(Color.white, for: .navigationBar)
                .navigationTitle("Новая машина")
                .navigationBarTitleDisplayMode(.inline)
        }
        .alert(item: $vm.alert) { Alert(title: Text($0.message)) }
    }
}

// MARK: –– View-Model -------------------------------------------------------

@MainActor
extension AddCarFlowView {
final class VM: ObservableObject {
    enum Route: Hashable { case specs, details, done }
    @Published var path: [Route] = []
    @Published var draft = AddCarDraft()
    @Published var alert: AlertItem?

    private let service: AddCarService = AddCarServiceImpl()

    func next(_ route: Route) { path.append(route) }

    func submit() {
        Task {
            do {
                try await service.create(draft)
                await MainActor.run { path = [.done] }  // ← публикация на главном
            } catch {
                await MainActor.run {
                    alert = .init(message: "Не удалось сохранить")
                }
            }
        }
    }
}}

// MARK: –– Шаг 1: Марка / Серия / Поколение --------------------------------

struct Step1Brand: View {
    @ObservedObject var vm: AddCarFlowView.VM
    @State private var showPicker = false

    var body: some View {
        VStack(spacing: 32) {
            progressDots(step: 1)

            Button { showPicker = true } label: {
                HStack {
                    Text(vm.draft.brand == nil ? "Выбрать марку / серию"
                         : BrandCache.shared.name(for: vm.draft.brand!) ?? "—")
                        .foregroundColor(vm.draft.brand == nil ? .gray : .text)

                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.accent)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()

            primaryButton("Далее") { vm.next(.specs) }
                .disabled(vm.draft.brand == nil)
        }
        .padding(24)
        .sheet(isPresented: $showPicker) {
            BrandPickerSheet { b, s, g in
                vm.draft.brand      = b
                vm.draft.series     = s
                vm.draft.generation = g
            }
        }
    }
}


// MARK: –– Шаг 2: Тех-спецификация ----------------------------------------

struct Step2Specs: View {
    @ObservedObject var vm: AddCarFlowView.VM

    // локальные строки-обёртки, чтобы placeholder был виден
    @State private var yearText     = ""
    @State private var mileageText  = ""
    @State private var priceText    = ""

    var body: some View {
        VStack(spacing: 32) {
            progressDots(step: 2)

            GroupBox {
                VStack(spacing: 18) {
                    iconField(sf: "calendar", title: "Год выпуска", text: $yearText)
                    iconField(sf: "speedometer", title: "Пробег, км", text: $mileageText)
                    iconField(sf: "creditcard", title: "Цена, ₸",   text: $priceText)
                    iconField(sf: "barcode", title: "VIN",         text: $vm.draft.vin)
                        .textInputAutocapitalization(.characters)
                        .onChange(of: vm.draft.vin) { vm.draft.vin = $0.uppercased() }
                }
            }

            Spacer()

            primaryButton("Далее") {
                mapStringsToDraft()
                vm.next(.details)
            }
            .disabled(!allValid)
        }
        .padding(24)
        .navigationTitle("Характеристики")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // заполняем строки, если пользователь вернулся «Назад»
            if vm.draft.year     != 0 { yearText    = "\(vm.draft.year)"     }
            if vm.draft.mileage  != 0 { mileageText = "\(vm.draft.mileage)"  }
            if vm.draft.price    != 0 { priceText   = "\(vm.draft.price)"    }
        }
    }

    // MARK: helpers UI
    private func iconField(sf: String,
                           title: String,
                           text: Binding<String>) -> some View {
        HStack {
            Image(systemName: sf).foregroundColor(.accent)
            TextField(title, text: text)
                .keyboardType(.numberPad)
        }
        .modifier(FieldStyle())
    }

    // MARK: helpers logic
    private var allValid: Bool {
        Int(yearText) != nil &&
        Int(mileageText) != nil &&
        Int(priceText) != nil &&
        !vm.draft.vin.isEmpty
    }

    private func mapStringsToDraft() {
        vm.draft.year    = Int(yearText)    ?? 0
        vm.draft.mileage = Int(mileageText) ?? 0
        vm.draft.price   = Int(priceText)   ?? 0
    }
}

// MARK: –– Шаг 3: Описание --------------------------------------------------

struct Step3Details: View {
    @ObservedObject var vm: AddCarFlowView.VM

    var body: some View {
        VStack(spacing: 32) {
            progressDots(step: 3)

            GroupBox {
                VStack(spacing: 20) {
                    TextField("Заголовок", text: $vm.draft.title)
                        .modifier(FieldStyle())

                    TextField("Город", text: $vm.draft.city)
                        .modifier(FieldStyle())

                    TextEditor(text: $vm.draft.description)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            Spacer()

            primaryButton("Опубликовать") { vm.submit() }
        }
        .padding(24)
        .navigationTitle("Описание")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: –– Финиш-экран ------------------------------------------------------

struct AddedDoneView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .resizable().scaledToFit().frame(width: 90)
                .foregroundColor(.accent)
                .padding(.top, 40)

            Text("Объявление создано!")
                .font(.title3.weight(.semibold))

            Spacer()
        }
    }
}

// MARK: –– Re-usable UI helpers --------------------------------------------

private func progressDots(step: Int) -> some View {
    HStack(spacing: 8) {
        ForEach(1...3, id: \.self) { n in
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(n <= step ? .accent : .gray.opacity(0.3))
        }
    }
}

private func primaryButton(_ title: String,
                           action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .font(.montserrat(.medium, size: 18))
    }
    .background(Color.accent)
    .foregroundColor(.white)
    .clipShape(RoundedRectangle(cornerRadius: 14))
}

private struct FieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
