//
//  RepairColumn2Cell.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 10. 25..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "GridColumn2Cell.h"

@implementation GridColumn2Cell
@synthesize lblColumn1;
@synthesize lblColumn2;
@synthesize btnCheck;

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
