//
//  DiskSpaceListView.swift
//  Reveil
//
//  Created by Lessica on 2023/10/4.
//

import SwiftUI

struct DiskSpaceListView: View, Identifiable, ModuleListView {
    let id = UUID()
    let module: Module = DiskSpace.shared

    init() {}

    init?(entryKey: EntryKey) {
        guard module.updatableEntryKeys.contains(entryKey) else {
            return nil
        }
    }

    var body: some View {
        DetailsListView(
            basicEntries: module.basicEntries,
            usageEntry: module.usageEntry,
            usageStyle: .compat
        )
        .navigationTitle(module.moduleName)
        .navigationBarItems(trailing: PinButton(pin: AppCodableStorage(
            wrappedValue: Pin(true), .DiskSpace,
            store: PinStorage.shared.userDefaults
        )))
        .onAppear {
            GlobalTimer.shared.addObserver(self)
        }
        .onDisappear {
            GlobalTimer.shared.removeObserver(self)
        }
    }
}

extension DiskSpaceListView: GlobalTimerObserver, Hashable {
    static func == (lhs: DiskSpaceListView, rhs: DiskSpaceListView) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func globalTimerEventOccurred(_ timer: GlobalTimer) {
        module.updateEntries()
    }
}

// MARK: - Previews

struct DiskSpaceListView_Previews: PreviewProvider {
    static var previews: some View {
        DiskSpaceListView()
            .environmentObject(HighlightedEntryKey())
    }
}
