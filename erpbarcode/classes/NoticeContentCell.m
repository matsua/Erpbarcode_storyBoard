//
//  NoticeContentCell.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 12. 11..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "NoticeContentCell.h"

@implementation NoticeContentCell
@synthesize lblData;

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
