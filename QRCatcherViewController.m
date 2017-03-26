//
//  QRCatcherViewController.m
//  beta
//
//  Created by Николай on 14.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import "QRCatcherViewController.h"

NSString * const ScanResultStringDidChangeNotification = @"ScanResultStringDidChangeNotification";

@interface QRCatcherViewController ()

@property (strong, nonatomic) AVCaptureSession * captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * videoPreviewLayer;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;
@property (strong, nonatomic) NSString * scanResult;

@property (assign, nonatomic) BOOL isScanning;

@property (assign, nonatomic) CGPoint point;
@property (assign, nonatomic) NSInteger newNumber;

@end

@implementation QRCatcherViewController



- (void)viewDidLoad {
    
    [self buildViews];
    
    [super viewDidLoad];
    
    [self startScanning];
    
    [self loadSound];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(scanResultNotification) name:ScanResultStringDidChangeNotification object:nil];
}


-(void)setScanResult:(NSString *)scanResult {
    
    _scanResult = scanResult;
    [[NSNotificationCenter defaultCenter] postNotificationName:ScanResultStringDidChangeNotification object:nil];
    
}

-(void) buildViews {
    
    self.cameraView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height*0.7);
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cameraView.frame), self.view.frame.size.width,
                                                                  self.view.frame.size.height-self.cameraView.frame.size.height)];
    CGFloat red = 20.f/255;
    CGFloat green = 45.f/255;
    CGFloat blue = 40.f/255;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];

    bottomView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
    
    UITextField * countTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMidX(bottomView.bounds)-50, CGRectGetMidY(bottomView.bounds)-60,
                                                                                100, 40)];
    self.point = countTextField.frame.origin;
    countTextField.delegate = self;
    countTextField.backgroundColor = [UIColor lightGrayColor];
    countTextField.textColor = [UIColor darkTextColor];
    countTextField.borderStyle = UITextBorderStyleRoundedRect;
    countTextField.text = @"1";
    countTextField.textAlignment = NSTextAlignmentCenter;
    countTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    countTextField.enablesReturnKeyAutomatically = YES;
    countTextField.returnKeyType = UIReturnKeyDone;
    self.countTextField = countTextField;
    [bottomView addSubview:self.countTextField];
    [bottomView bringSubviewToFront:self.countTextField];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake((self.view.center.x)/2-40, CGRectGetMaxY(self.view.frame)-70, 80, 60);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tintColor = [UIColor lightTextColor];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    backButton.titleLabel.textColor = [UIColor lightTextColor];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [backButton addTarget:self action:@selector(onBackButton) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = backButton;
    
    [self.view addSubview:self.backButton];
    [self.view bringSubviewToFront:self.backButton];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

-(void) scanResultNotification {
    
    TableNote * note;
    
//    NSString * result = self.scanResult;
//    for (TableNote * object in self.coreDataArray) {
//        if ([object.title isEqualToString:result]) {
//            note = object;
//            NSLog(@"this note already exist");
//            
//            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"This object already exist" message:@"Choose neccessary operation" preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction * addAction = [UIAlertAction actionWithTitle:@"Add more items" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.newNumber = [object.count integerValue] + [self.countTextField.text integerValue];
//                [alert dismissViewControllerAnimated:YES completion:nil];
//                
//            }];
//            UIAlertAction * removeAction = [UIAlertAction actionWithTitle:@"Remove item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.newNumber = [object.count integerValue] - [self.countTextField.text integerValue];
//                [alert dismissViewControllerAnimated:YES completion:nil];
//
//            }];
//            [alert addAction:addAction];
//            [alert addAction:removeAction];
//            [self presentViewController:alert animated:YES completion:nil];
//            
//        }
//    }
    
    if (!note) {
        NSNumber * count = [NSNumber numberWithInteger:[self.countTextField.text integerValue]];
        NSDate * date = [NSDate date];
        
        TableNote * note = [NSEntityDescription insertNewObjectForEntityForName:@"TableNote" inManagedObjectContext:self.managedObjectContext];
        [note setValue:count forKey:@"count"];
        [note setValue:self.scanResult forKey:@"title"];
        [note setValue:date forKey:@"date"];
    }
    
    NSError * error = nil;
    [self.managedObjectContext save:&error];
    [self.delegate executeFetchRequest];
    [self.delegate reloadTableData];
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

# pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.5 animations:^{
        textField.frame = CGRectMake(self.point.x, self.point.y-200, 100, 40);

        [self.view bringSubviewToFront:textField];

    }];
    

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        textField.frame = CGRectMake(self.point.x, self.point.y, 100, 40);
    }];
    
    textField.frame = CGRectMake(self.point.x, self.point.y, 100, 40);
    return YES;
}
#pragma mark - Scanning

-(BOOL) startScanning {
    
    self.isScanning = !self.isScanning;
    NSError * error = nil;
    
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput * captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("Queue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.videoPreviewLayer.frame = self.cameraView.frame;
    [self.cameraView.layer addSublayer:self.videoPreviewLayer];
    
    [self.captureSession startRunning];
    return YES;
    
}

-(void) stopScanning {
    
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    [self.videoPreviewLayer removeFromSuperlayer];
    
}

-(void) loadSound {
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"accept_sound" ofType:@"wav"];
    NSURL * soundURL = [NSURL URLWithString:filePath];
    
    NSError * error = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if (error) {
        NSLog(@"Sound loading is failed");
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [self.audioPlayer prepareToPlay];
    }
    
}

-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if(metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector (stopScanning) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector (setScanResult:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            if (self.audioPlayer) {
                [self.audioPlayer play];
            }
        }
    }
}


#pragma mark - Actions

-(void) onBackButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)startStopScanning {
    
    if (!self.isScanning) {
        
        [self startScanning];
        
    } else {
        
        [self stopScanning];

    }
    
    self.isScanning = !self.isScanning;
}

@end
