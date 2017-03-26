//
//  ViewController.m
//  beta
//
//  Created by Николай on 09.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



-(void)loadView {
    [super loadView];
    
    self.backgroundImage = [[UIImageView alloc] init];
    UIImage * img = [UIImage imageNamed:@"background_green.bmp"];
    UIImageView * image= [[UIImageView alloc] initWithImage:img];
    self.backgroundImage = image;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
