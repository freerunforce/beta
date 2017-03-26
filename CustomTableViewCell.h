//
//  CustomTableViewCell.h
//  beta
//
//  Created by Николай on 21.03.17.
//  Copyright © 2017 Николай. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * dateLabel;
@property (weak, nonatomic) IBOutlet UILabel * countLabel;
@end
