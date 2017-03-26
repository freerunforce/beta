//
//  TableViewCell.h
//  beta
//
//  Created by Николай on 10.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * title;
@property (weak, nonatomic) IBOutlet UILabel * subtitle;
@property (weak, nonatomic) IBOutlet UILabel * dateLabel;

@end
