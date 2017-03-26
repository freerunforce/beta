//
//  InfoViewController.m
//  beta
//
//  Created by Николай on 12.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildViews];
    // Do any additional setup after loading the view.
}

-(void) buildViews {
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    UIImageView * image = [[UIImageView alloc]initWithFrame:backgroundView.frame];
    image.image = [UIImage imageNamed:@"background_green.bmp"];
    [self.view addSubview:backgroundView];
    [backgroundView addSubview:image];
    NSLog (@"%f", CGRectGetMaxX(self.view.bounds));
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, self.view.center.y-100, CGRectGetWidth(self.view.bounds)-60, 200)];
    infoLabel.textColor = [UIColor lightTextColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont fontWithName:@"Avenir" size:25];
    infoLabel.text = @"This application has been developed as a bachelor degree project.                                                 Author: Nikolay Avilov";
    [infoLabel setNumberOfLines:0];
    [self.view addSubview:infoLabel];
    [self.view bringSubviewToFront:infoLabel];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(self.view.center.x-50, CGRectGetMaxY(self.view.frame)-50, 100, 40);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tintColor = [UIColor lightTextColor];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    backButton.titleLabel.textColor = [UIColor lightTextColor];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [backButton addTarget:self action:@selector(onBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
    [self.view bringSubviewToFront:backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
