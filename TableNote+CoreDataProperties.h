//
//  TableNote+CoreDataProperties.h
//  beta
//
//  Created by Николай on 20.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TableNote.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableNote (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *count;

@end

NS_ASSUME_NONNULL_END
