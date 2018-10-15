//
//  GridColumn9Cell.m
//  erpbarcode
//

#import "GridColumn9Cell.h"

@implementation GridColumn9Cell
@synthesize btnCheck;
@synthesize lblColumn2;
@synthesize lblColumn3;
@synthesize lblColumn4;
@synthesize lblColumn5;
@synthesize lblColumn6;
@synthesize lblColumn7;
@synthesize lblColumn8;
@synthesize lblColumn9;
@synthesize lblColumn10;

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
