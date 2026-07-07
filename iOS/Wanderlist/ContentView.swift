import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: WanderlistStore
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.destinations) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.name).font(Theme.headlineFont)
                        Text("\(entry.notes)")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { store.remove(at: $0) }
            }
            .navigationTitle("Wanderlist")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("main.settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAdd(isPro: purchases.isPro) {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("main.addButton")
                }
            }
            .sheet(isPresented: $showingAdd) { AddDestinationView() }
            .sheet(isPresented: $showingPaywall) { PaywallView() }
            .sheet(isPresented: $showingSettings) { SettingsView() }
        }
    }
}

struct AddDestinationView: View {
    @EnvironmentObject var store: WanderlistStore
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Destination", text: $name)
                        .accessibilityIdentifier("addDestination.nameField")
                    TextField("Notes", text: $notes)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { hideKeyboard() }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = Destination(name: name.isEmpty ? "Destination" : name, notes: notes.isEmpty ? "Notes" : notes)
                        _ = store.add(entry, isPro: purchases.isPro)
                        dismiss()
                    }
                    .accessibilityIdentifier("addDestination.saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
