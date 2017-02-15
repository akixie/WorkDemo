//
//  TestCell.h
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *lookpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *lpointLabel;

@end
