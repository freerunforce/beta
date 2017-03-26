//
//  TableViewController.m
//  beta
//
//  Created by Николай on 10.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) UIButton * scanButton;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;

@property (weak, nonatomic) UIView * detailsView;
@property (strong, nonatomic) UIView * sortTypeView;
@property (strong, nonatomic) UITextField * countTextField;

@property (strong, nonatomic) TableNote * note;
@property (strong, nonatomic) NSArray * coreDataArray;

@property (strong, nonatomic) UISwipeGestureRecognizer * gestureRecognizer;

@property (strong, nonatomic) UIColor * color;

@property (assign, nonatomic) BOOL isDetailsViewActive;
@property (assign, nonatomic) BOOL isSortTypeViewActive;


@end

@implementation TableViewController

-(void)loadView {
    [super loadView];
    [self executeFetchRequest];
}

- (void)viewDidLoad {

    self.isSortTypeViewActive = NO;
    
    CGRect rect = CGRectMake(CGRectGetMaxX(self.view.bounds)-70, CGRectGetMinY(self.view.bounds)+20+(self.searchBar.frame.size.height), self.view.frame.size.width, (self.view.frame.size.height-72)-(self.searchBar.frame.size.height));

    self.sortTypeView = [[UIView alloc]initWithFrame:rect];
    
    self.sortTypeView.backgroundColor = [UIColor clearColor];
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"view.png"]];
    imageView.frame = self.sortTypeView.bounds;
    [self.sortTypeView addSubview:imageView];
    [self.sortTypeView bringSubviewToFront:imageView];
    
    UISwipeGestureRecognizer * gestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showSortTypeView:)];
    [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:gestureRecognizer];
    self.gestureRecognizer = gestureRecognizer;
        
    [self.view addSubview:self.sortTypeView];
    [self.view bringSubviewToFront:self.sortTypeView];
    
    [self.view bringSubviewToFront:self.scanButton];
    [super viewDidLoad];
    
    CGFloat red = 20.f/255;
    CGFloat green = 45.f/255;
    CGFloat blue = 40.f/255;
    
    self.color = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    self.tableView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    self.color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    self.scanButton.backgroundColor = self.color;
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    self.searchBar.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.6];
    
    [self buildViews];
    
}

-(void) buildViews {
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(0, (CGRectGetMaxY(self.view.frame)-40), self.view.frame.size.width, 40);
    scanButton.backgroundColor = self.color;
    [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    scanButton.titleLabel.textColor = [UIColor lightTextColor];
    scanButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    scanButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [scanButton addTarget:self action:@selector(onScanButton) forControlEvents:UIControlEventTouchUpInside];
    self.scanButton = scanButton;
    
    [self.view addSubview:scanButton];
    [self.view bringSubviewToFront:scanButton];
    

    self.searchBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 45);
    
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height+20,
                                      self.view.frame.size.width, self.view.frame.size.height-self.searchBar.frame.size.height-self.scanButton.frame.size.height);
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}


-(void) showDetailsViewWithObject: (TableNote *) object {
    
    self.isDetailsViewActive = !self.isDetailsViewActive;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetMidX(self.view.bounds)-100), 100, 200.f, 400.f)];
    view.backgroundColor = self.color;
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    self.detailsView = view;
    [self.view addSubview:self.detailsView];
    [self.view bringSubviewToFront:self.detailsView];
    CGFloat centerX = CGRectGetMidX(self.detailsView.bounds);
    CGFloat centerY = CGRectGetMidY(self.detailsView.bounds);
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX - (centerX)/1.5, centerY + (centerY)/2, 40, 20)];
    UIButton * saveButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX + (centerX)/3, centerY + (centerY)/2, 40, 20)];
    backButton.enabled = YES;
    saveButton.enabled = YES;
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.6] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.4] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:0.2f green:0.8f blue:0.2f alpha:0.5] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView addSubview:backButton];
    [self.detailsView addSubview:saveButton];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((centerX)-100, (centerY)-(centerY/2), 200, 30)];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = object.title;
    [self.detailsView addSubview:label];
    
    CGRect rectangle = CGRectMake((centerX)-50, centerY, 100, 30);
    UITextField * textField = [[UITextField alloc]init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.backgroundColor = [UIColor grayColor];
    textField.delegate = self;
    textField.frame = rectangle;
    textField.text = [NSString stringWithFormat:@"%@", object.count];
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.detailsView addSubview:textField];
    
    self.countTextField = textField;
    self.note = object;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - QRViewControllerDelegate 

-(void) reloadTableData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isDetailsViewActive) {
        
    } else {
        TableNote * note = [self.coreDataArray objectAtIndex:indexPath.row];
        
        [self showDetailsViewWithObject:note];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.coreDataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self executeFetchRequest];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        }
    
    TableNote * note = [self.coreDataArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", note.title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Count: %@", note.count];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    self.tableView.scrollEnabled = YES;
    [searchBar resignFirstResponder];
    [self executeFetchRequest];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.tableView.scrollEnabled = NO;
    searchBar.showsCancelButton = YES;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
 
}


#pragma mark - Requests
- (void) executeFetchRequest {
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"TableNote" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entityDescription];
    [request setResultType:NSManagedObjectResultType];
    NSError * error = nil;
    NSArray * resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        
    }
    self.coreDataArray = resultArray;
    
    
}

#pragma mark - Actions

-(void) onScanButton {
    
    QRCatcherViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCatcherVC"];
    vc.delegate = self;
    vc.coreDataArray = self.coreDataArray;
    
    vc.managedObjectContext = self.managedObjectContext;
    [self presentViewController:vc animated:YES completion:nil];
    
}


-(void) saveButtonAction {
    
    TableNote * note = self.note;
    
    NSInteger count = [self.countTextField.text integerValue];
    
    if (count == 0) {
        
        [self.managedObjectContext deleteObject:note];
        NSLog(@"deleted");
        
    } else  {
        
    TableNote * note = self.note;
    [note setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
    }
    
    NSError * error;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
    
    [self executeFetchRequest];
    [self.tableView reloadData];
    
    self.isDetailsViewActive = !self.isDetailsViewActive;
    
    [self.detailsView removeFromSuperview];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Done" message:@"Note has been successfully edited" preferredStyle:UIAlertControllerStyleAlert];
    if (count == 0) {
        [alertController setMessage:@"Note has been successfully deleted"];
    }
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
    
}

-(void) showSortTypeView: (UISwipeGestureRecognizer *)recognizer{
    self.isSortTypeViewActive = !self.isSortTypeViewActive;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sortTypeView.frame = CGRectMake(60, CGRectGetMinY(self.view.bounds)+20+(self.searchBar.frame.size.height), self.view.frame.size.width, (self.view.frame.size.height-72)-(self.searchBar.frame.size.height));
    }];
    
    
    NSLog(@"%d", self.isSortTypeViewActive);
    [self.view removeGestureRecognizer:self.gestureRecognizer];
    
    UISwipeGestureRecognizer * gestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideSortTypeView:)];
    [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:gestureRecognizer];
    self.gestureRecognizer = gestureRecognizer;
    
}
-(void) hideSortTypeView: (UISwipeGestureRecognizer *) recognizer {
    self.isSortTypeViewActive = !self.isSortTypeViewActive;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sortTypeView.frame = CGRectMake(CGRectGetMaxX(self.view.bounds)-70, CGRectGetMinY(self.view.bounds)+20+(self.searchBar.frame.size.height), self.view.frame.size.width, (self.view.frame.size.height-72)-(self.searchBar.frame.size.height));
        
    }];
    
    NSLog(@"%d", self.isSortTypeViewActive);
    
    [self.view removeGestureRecognizer:self.gestureRecognizer];

    UISwipeGestureRecognizer * gestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showSortTypeView:)];
    [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:gestureRecognizer];
    self.gestureRecognizer = gestureRecognizer;

}



@end
