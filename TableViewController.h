//
//  TableViewController.h
//  beta
//
//  Created by Николай on 10.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TableNote.h"
#import "QRCatcherViewController.h"
#import "CustomTableViewCell.h"


@protocol QRViewControllerDelegate;
@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, QRViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
