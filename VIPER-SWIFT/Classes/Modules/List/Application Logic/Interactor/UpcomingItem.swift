//
//  UpcomingItem.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation

struct UpcomingItem : Equatable {
    let title : String
    let dueDate : NSDate
    let dateRelation : NearTermDateRelation
}

func == (leftSide: UpcomingItem, rightSide: UpcomingItem) -> Bool {
    return rightSide.title == leftSide.title && rightSide.dueDate == leftSide.dueDate && rightSide.dateRelation == leftSide.dateRelation
}