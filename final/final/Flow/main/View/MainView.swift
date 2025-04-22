//
//  MainView.swift
//  final
//
//  Created by Алан Абзалханулы on 22.04.2025.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var tokenStore = TokenStore.shared

    @State private var habits: [Habit] = sampleHabits
    @State private var showingNewHabit = false

    @State private var selectedTab = 0

    var body: some View {
        Group {
            if tokenStore.token == nil {
                AuthView()
            } else {
                ZStack(alignment: .bottom) {

                    TabView(selection: $selectedTab) {
                        DashboardScreen(habits: $habits)
                            .tag(0)
                        StatsScreen()
                            .tag(1)
                        Color.clear.tag(2)
                        SettingsScreen()
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    CustomTabBar(selected: $selectedTab) {
                        showingNewHabit = true
                    }
                    .sheet(isPresented: $showingNewHabit) {
                        NewHabitView(habits: $habits)
                    }
                }
            }
        }
        .animation(.easeInOut, value: tokenStore.token == nil)
    }
}


private struct DashboardScreen: View {
    @Binding var habits: [Habit]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeroHeader()
                Text("Today")
                    .font(Theme.font(20, weight: .bold))

                ForEach($habits) { $habit in
                    HabitRow(habit: $habit)
                }
            }
            .padding()
        }
    }
}

private struct StatsScreen: View {
    var body: some View {
        Text("📊 Stats").font(.largeTitle)
    }
}

private struct SettingsScreen: View {
    @ObservedObject private var tokenStore = TokenStore.shared

    var body: some View {
        VStack {
            Spacer()
            Button("Выход") {
                tokenStore.clear()
            }
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
    }
}


private struct NewHabitView: View {
    @Binding var habits: [Habit]
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("New Habit") {
                    TextField("Title", text: $title)
                }
            }
            .navigationTitle("Add Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let new = Habit(title: title,
                                        streak: 0,
                                        progress: 0,
                                        isCompleted: false)
                        habits.append(new)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct HeroHeader: View {
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 28)
                .fill(LinearGradient(colors: [Theme.purple, Theme.purpleDark],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, Alan")
                    .font(Theme.font(24, weight: .bold))
                    .foregroundColor(.white)
                Text("You have \(habitsCount) habits today")
                    .font(Theme.font(15))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
        .frame(height: 140)
    }

    private var habitsCount: Int { sampleHabits.count }
}

private struct HabitRow: View {
    @Binding var habit: Habit

    var body: some View {
        HStack {
            Button {
                habit.isCompleted.toggle()
                habit.progress = habit.isCompleted ? 100 : 0
                if habit.isCompleted {
                    habit.streak += 1
                }
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(Theme.purple, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if habit.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(Theme.purple)
                            .frame(width: 24, height: 24)
                    }
                }
            }

            VStack(alignment: .leading) {
                Text(habit.title)
                    .font(Theme.font(17, weight: .semibold))
                Text("\(habit.streak)-day streak")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("\(habit.progress)%")
                .font(.caption)
                .foregroundColor(Theme.purpleDark)
        }
        .padding()
        .background(Theme.card)
        .cornerRadius(16)
    }
}

private struct CustomTabBar: View {
    @Binding var selected: Int
    var fabAction: () -> Void

    private let icons = ["list.bullet", "chart.bar", "", "gearshape"]

    var body: some View {
        HStack {
            ForEach(0..<icons.count, id: \.self) { i in
                if i == 2 {
                    Spacer().frame(width: 64)
                } else {
                    Button {
                        selected = i
                    } label: {
                        Image(systemName: icons[i])
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(selected == i
                                             ? Theme.purpleDark
                                             : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 56)
        .background(.ultraThinMaterial)
        .overlay(
            Button(action: fabAction) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Theme.purpleDark)
                    .clipShape(Circle())
                    .shadow(radius: 4, y: 3)
            }
            .offset(y: -28)
        )
    }
}


private struct Habit: Identifiable {
    let id = UUID()
    var title: String
    var streak: Int
    var progress: Int
    var isCompleted: Bool
}

private let sampleHabits: [Habit] = [
    .init(title: "Read Book",       streak: 3, progress: 30, isCompleted: false),
    .init(title: "Learning Arabic", streak: 1, progress: 50, isCompleted: false),
    .init(title: "Morning Run",     streak: 2, progress: 70, isCompleted: false)
]

#Preview {
    MainView()
}
