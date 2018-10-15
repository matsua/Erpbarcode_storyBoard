//
//  FindUserListCell.m
//  erpbarcode
//
//  Created by matsua on 13. 10. 29..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "FindUserListCell.h"

@implementation FindUserListCell

@synthesize btnCheck;

@synthesize lblLabel1;
@synthesize lblLabel2;
@synthesize lblLabel3;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
