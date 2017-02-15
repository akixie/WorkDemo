//
//  TestCell.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    
    self.buyButton.layer.borderColor = [UIColor colorWithRed:26/255.f green:196/255.f blue:23/255.f alpha:1].CGColor;
    self.buyButton.layer.borderWidth = 0.5;
    
    self.lookpointLabel.layer.borderColor = [UIColor colorWithRed:255/255.f green:104/255.f blue:124/255.f  alpha:1].CGColor;
    self.lookpointLabel.layer.borderWidth = 0.5;
    
}

@end
