//
//  LoginViewController.m
//  beta
//
//  Created by Николай on 09.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import "LoginViewController.h"
#import "TableViewController.h"
#import "InfoViewController.h"
#import "AzureTableViewController.h"


@interface LoginViewController ()

@property (strong, nonatomic) UITextField * usernameTextField;
@property (strong, nonatomic) UITextField * passwordTextField;

@property (strong, nonatomic) UIButton * connectButton;
@property (strong, nonatomic) UIButton * aboutButton;


@end

static NSString * username = @"Admin";
static NSString * password = @"admin";

@implementation LoginViewController


- (void)viewDidLoad {
    [self buildViews];
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void) buildViews {
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    UIImageView * image = [[UIImageView alloc]initWithFrame:backgroundView.frame];
    image.image = [UIImage imageNamed:@"background_green.bmp"];
    [self.view addSubview:backgroundView];
    [backgroundView addSubview:image];

    
    UIImageView * logo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-75, 50, 150, 150)];
    logo.image = [UIImage imageNamed:@"qr-code-674-180.png"];
    [backgroundView addSubview:logo];
    [backgroundView bringSubviewToFront:logo];
    
    UIView * textFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.frame)-70, self.view.frame.size.width, 100)];
    textFieldView.backgroundColor = [UIColor clearColor];
    UIImageView * textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-150, textFieldView.bounds.origin.y, 300, 100)];
    textFieldImageView.image = [UIImage imageNamed:@"textField.bmp"];
    textFieldImageView.layer.cornerRadius = 25;
    textFieldImageView.layer.masksToBounds = YES;
    [textFieldView addSubview:textFieldImageView];
    
    UITextField * usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x, textFieldImageView.frame.origin.y,
                                                                                   textFieldImageView.bounds.size.width, 50)];
    
    usernameTextField.borderStyle = UITextBorderStyleNone;
    usernameTextField.delegate = self;
    usernameTextField.placeholder = @"Username";
    usernameTextField.backgroundColor = [UIColor clearColor];
    usernameTextField.textAlignment = NSTextAlignmentCenter;
    [usernameTextField setUserInteractionEnabled:YES];
    [usernameTextField setEnabled:YES];
    self.usernameTextField = usernameTextField;
    [textFieldView addSubview:self.usernameTextField];
    [textFieldView bringSubviewToFront:self.usernameTextField];
    
    UITextField * passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x, textFieldImageView.frame.origin.y+50,
                                                                                   textFieldImageView.frame.size.width, 50)];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextField.placeholder = @"Password";
    passwordTextField.backgroundColor = [UIColor clearColor];
    passwordTextField.textAlignment = NSTextAlignmentCenter;
    self.passwordTextField = passwordTextField;
    [textFieldView addSubview:self.passwordTextField];
    [textFieldView bringSubviewToFront:self.passwordTextField];
    
    [self.view addSubview:textFieldView];
    [self.view bringSubviewToFront:textFieldView];
    
    UIButton * connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    connectButton.frame = CGRectMake(self.view.center.x-50, CGRectGetMaxY(self.view.frame)-200, 100, 40);
    connectButton.backgroundColor = [UIColor clearColor];
    connectButton.tintColor = [UIColor lightTextColor];
    [connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [connectButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    connectButton.titleLabel.textColor = [UIColor lightTextColor];
    connectButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    connectButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:25];
    [connectButton addTarget:self action:@selector(onConnectButton) forControlEvents:UIControlEventTouchUpInside];
    self.connectButton = connectButton;
    
    [self.view addSubview:self.connectButton];
    [self.view bringSubviewToFront:self.connectButton];
                                     
    UIButton * aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutButton.frame = CGRectMake(self.view.center.x-50, CGRectGetMaxY(self.view.frame)-50, 100, 40);
    aboutButton.backgroundColor = [UIColor clearColor];
    aboutButton.tintColor = [UIColor lightTextColor];
    [aboutButton setTitle:@"About" forState:UIControlStateNormal];
    [aboutButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    aboutButton.titleLabel.textColor = [UIColor lightTextColor];
    aboutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    aboutButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [aboutButton addTarget:self action:@selector(onAboutButton) forControlEvents:UIControlEventTouchUpInside];
    self.aboutButton = aboutButton;
    
    [self.view addSubview:self.aboutButton];
    [self.view bringSubviewToFront:self.aboutButton];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.usernameTextField]) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self onConnectButton];
        [textField resignFirstResponder];
    }
    return YES;
    
}

#pragma mark - Actions
-(void) onConnectButton {
    
    TableViewController * tvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"TableVC"];
    tvc.managedObjectContext = self.managedObjectContext;
    [self showViewController:tvc sender:self];
    
    if ([self.usernameTextField.text isEqualToString:username]&&[self.passwordTextField.text isEqualToString:password]) {
        TableViewController * tvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"TableVC"];
        tvc.managedObjectContext = self.managedObjectContext;
        [self showViewController:tvc sender:self];
        } else {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Incorrent account" message:@"Wrong username or password" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:nil]; });
        }

}

-(void) onAboutButton {
    
    InfoViewController * ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];
    [ivc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:ivc animated:YES completion:nil];
    
}



@end
