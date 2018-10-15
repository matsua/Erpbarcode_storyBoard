//
//  TreeNode.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 27..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNode : NSObject
@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) id nodeObject;
@property (nonatomic, strong) NSMutableArray *nodeChilds;
@end
