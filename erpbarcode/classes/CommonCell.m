//
//  CommonCell.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 14..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell
@synthesize textTreeData;
@synthesize nScanType;
@synthesize lblTreeData;
@synthesize lblBackground;
@synthesize scrollView;
@synthesize imageView;
@synthesize btnTree;
@synthesize hasSubNode;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*)event
{
    [super touchesEnded: touches withEvent:event];
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //CGFloat pointX = (self.editing)? 35.0f:0.0f;
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.scrollView.frame = CGRectMake(
                                       indentPoints,
                                       self.scrollView.frame.origin.y,
                                       self.scrollView.frame.size.width - indentPoints ,
                                       self.scrollView.frame.size.height
                                       );

}

@end
