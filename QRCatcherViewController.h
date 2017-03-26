//
//  QRCatcherViewController.h
//  beta
//
//  Created by Николай on 14.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TableNote.h"
#import "TableViewController.h"

extern NSString * const scanResultStringDidChangeNotification;

@protocol QRViewControllerDelegate
@optional
-(void) executeFetchRequest;
-(void) reloadTableData;
@end

@interface QRCatcherViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, QRViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView * cameraView;

@property (strong, nonatomic) UITextField * countTextField;
@property (strong, nonatomic) UIView * bottomView;
@property (strong, nonatomic) UIButton * backButton;

@property (strong, nonatomic) NSArray * coreDataArray;

@property (weak, nonatomic) id <QRViewControllerDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end
