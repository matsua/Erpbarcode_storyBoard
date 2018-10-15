//
//  OrgSearchCell.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "OrgSearchCell.h"

@implementation OrgSearchCell
@synthesize imgtreeNode;
@synthesize lblContent;
@synthesize treeNode;
@synthesize isIndentMode;
@synthesize btntreeNode;

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.contentView.frame = CGRectMake(indentPoints,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - indentPoints,
                                        self.contentView.frame.size.height);
    
//    self.imgtreeNode.frame = CGRectMake(
//                                      self.imageView.frame.origin.x - indentPoints,
//                                      self.imageView.frame.origin.y,
//                                      self.imageView.frame.size.width,
//                                      self.imageView.frame.size.height
//                                      );
}

@end
