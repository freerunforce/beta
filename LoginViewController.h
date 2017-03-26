//
//  LoginViewController.h
//  beta
//
//  Created by Николай on 09.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TableNote.h"


@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
