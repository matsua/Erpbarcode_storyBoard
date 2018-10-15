//
//  GridColumnRepairCell.m
//  erpbarcode
//

#import "GridColumnRepairCell.h"

@implementation GridColumnRepairCell
@synthesize scrollView;

@synthesize lblColumna;
@synthesize lblColumnb;
@synthesize lblColumn1;
@synthesize lblColumn2;
@synthesize lblColumn3;
@synthesize lblColumn4;
@synthesize lblColumn5;
@synthesize lblColumn6;


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
    
    self.scrollView.frame = CGRectMake(
                                       indentPoints,
                                       self.scrollView.frame.origin.y,
                                       self.scrollView.frame.size.width - indentPoints ,
                                       self.scrollView.frame.size.height
                                       );
    
}

@end
