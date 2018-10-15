//
//  SettingViewRereadDelay.m
//  KTSync
//
//  Created by Ben Yoo on 11-06-02.
//  Copyright 2011 KoamTac Inc. All rights reserved.
//
#import "SettingViewRereadDelay.h"


@implementation SettingViewRereadDelay

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"자동 스캔 간격 설정";
    self.navigationController.navigationBarHidden = NO;
    
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
	listOfRecord = [[NSMutableArray alloc] init];	
	
	NSArray *delay;
	
	delay = [NSArray arrayWithObjects:@"연속 스캔", @"빠른 속도", @"중간 속도", @"느린 속도", @"아주 느린속도", nil];
    
	NSDictionary *delayDict = [NSDictionary dictionaryWithObject:delay forKey:@"AutoTriggerDelay"];
	
	[listOfRecord addObject:delayDict];

    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSDictionary *dictionary = [listOfRecord objectAtIndex:section];
	NSArray *array = [dictionary objectForKey:@"AutoTriggerDelay"];
	
	return [array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    // Set up the cell...
	NSDictionary *dictionary = [listOfRecord objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"AutoTriggerDelay"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
	
	cell.textLabel.text = cellValue;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
//	if ( [cellValue isEqual:@"연속 스캔"] && (RereadDelay == 0 ) )
//		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//	if ( [cellValue isEqual:@"빠른 속도"] && (RereadDelay == 1 ) )
//		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//	if ( [cellValue isEqual:@"중간 속도"] && (RereadDelay == 2))
//		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];	
//	if ( [cellValue isEqual:@"느린 속도"] && (RereadDelay == 3))
//		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];	
//	if ( [cellValue isEqual:@"아주 느린속도"] && (RereadDelay == 4))
//		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	
    return cell;
}


#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dictionary = [listOfRecord objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"AutoTriggerDelay"];
    
	UITableViewCell *cell;
	
	for (int i = 0; i < [array count]; i++) {
		
		cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}	
    
	if ( [[array objectAtIndex:indexPath.row] isEqual:@"연속 스캔"] ) {
//		RereadDelay = 0;
		self.navigationItem.rightBarButtonItem = nil;
	}    
	
	if ( [[array objectAtIndex:indexPath.row] isEqual:@"빠른 속도"] ) {
//		RereadDelay = 1;
		self.navigationItem.rightBarButtonItem = nil;
	}
    
	if ( [[array objectAtIndex:indexPath.row] isEqual:@"중간 속도"] ) {
//		RereadDelay = 2;
		self.navigationItem.rightBarButtonItem = nil;
	}
    
	if ( [[array objectAtIndex:indexPath.row] isEqual:@"느린 속도"] ) {
//		RereadDelay = 3;
		self.navigationItem.rightBarButtonItem = nil;
	}
    
	if ( [[array objectAtIndex:indexPath.row] isEqual:@"아주 느린속도"] ) {
//		RereadDelay = 4;
		self.navigationItem.rightBarButtonItem = nil;
	}
    
//	cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:RereadDelay inSection:0]];
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}
#pragma mark - User Action Method
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
@end
