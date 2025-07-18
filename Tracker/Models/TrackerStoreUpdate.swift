//
//  TrackerStoreUpdate.swift
//  Tracker
//
//  Created by Medina Huseynova on 18.07.25.
//

import Foundation

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}
