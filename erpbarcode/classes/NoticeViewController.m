//
//  NoticeViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 12. 11..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "NoticeContentCell.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "SelfCertificationViewController.h"


@interface NoticeViewController ()

@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,assign) NSInteger nSelectedRow;
@property(nonatomic,strong) NSMutableArray* subContentList;
@property(nonatomic,strong) NSMutableArray* tableList;
@property(nonatomic,strong) IBOutlet UIButton* btnAlert;
@property(nonatomic,strong) IBOutlet UIButton* btnClose;
- (IBAction)touchCloseButton:(id)sender;
- (IBAction)touchAlertButton:(id)sender;
@end

@implementation NoticeViewController
@synthesize noticeDeligate;
@synthesize noticeList;
@synthesize _tableView;
@synthesize nSelectedRow;
@synthesize subContentList;
@synthesize btnAlert;
@synthesize btnClose;
@synthesize tableList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    self.title = @"공지사항";
    
    if (noticeList.count)
    {
        subContentList = [NSMutableArray array];
        tableList = [NSMutableArray array];
        
        for (NSDictionary* noticeDic in noticeList)
        {
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            NSString* msg = [noticeDic objectForKey:@"description"];
            NSString* boardSequence = [noticeDic objectForKey:@"boardSequence"];
            NSString* title = [noticeDic objectForKey:@"title"];
            
            [dic setObject:@"2" forKey:@"level"];
            [dic setObject:msg forKey:@"description"];
            [dic setObject:title forKey:@"title"];
            [dic setObject:[NSNumber numberWithInt:SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
            [dic setObject:boardSequence forKey:@"boardSequence"];
            [subContentList addObject:dic];
        }
        
        int i = 0;
        for (NSDictionary* noticeDic in noticeList) {
            NSString* title = [noticeDic objectForKey:@"title"];
            int subIndex = [WorkUtil getNoticeIndex:title noticeList:subContentList];
            if (subIndex != -1)
            {
                NSDictionary* subDic = [subContentList objectAtIndex:subIndex];
                [tableList addObject:noticeDic];
                i++;
                [tableList insertObject:subDic atIndex:i++];
            }
        }
        
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  User Define Action
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)saveToNoticeDB
{
    
    sqlite3 *dbObject = [[DBManager sharedInstance] getDatabaseObject];
    
    char* errorMessage;
    sqlite3_exec(dbObject, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
    
    sqlite3_stmt* stmt;
    
    char *sqlQuery = INSERT_BP_NOTICE;
    /*
     NOTICE_SEQ,     \
     USE_YN,         \
     NOTICE_DATE)    \
     */
    
    int sqlReturn = sqlite3_prepare_v2(dbObject, sqlQuery, (int)strlen(sqlQuery), &stmt, NULL);
    
    
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: '%s'.", sqlite3_errmsg(dbObject));
        return NO;
    }
    
    int dbSuccessCount = 0;
    
    for (NSDictionary* dic in noticeList) {
        NSString* strSeq = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"boardSequence"] intValue]];
        const char* NOTICE_SEQ = [strSeq UTF8String];
        //NSString* strUseCheck = (btnAlert.selected)? @"Y":@"N";
        //변경하고 메인화면으로 이동
        NSString* strUseCheck = @"Y";
        const char* USE_YN = [strUseCheck UTF8String];
        const char* NOTICE_DATE = [[NSDate TodayString] UTF8String];
        
        sqlite3_bind_text(stmt, 1, NOTICE_SEQ, (int)strlen(NOTICE_SEQ), SQLITE_STATIC);
        sqlite3_bind_text(stmt, 2, USE_YN, (int)strlen(USE_YN), SQLITE_STATIC);
        sqlite3_bind_text(stmt, 3, NOTICE_DATE, (int)strlen(NOTICE_DATE),SQLITE_STATIC);
        
        if (sqlite3_step(stmt) != SQLITE_DONE)
        {
            NSLog(@"failed to sqlite3_step - error : %d\n", sqlite3_step(stmt));
        }
        else
        {
            dbSuccessCount++;
            //NSLog(@"success index [%d]",successCount);
            sqlite3_reset(stmt);
        }
   }
 
    NSLog(@"success count [%d]",dbSuccessCount);
    
    sqlite3_exec(dbObject, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    sqlite3_finalize(stmt);
    return YES;
}

#pragma mark - User Action Method
- (IBAction)touchCloseButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [noticeDeligate noticeConfirm];
}

- (IBAction)touchAlertButton:(id)sender
{
    //db에 상태값 설정
    btnAlert.selected = !btnAlert.selected;
    [self saveToNoticeDB];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [noticeDeligate noticeConfirm];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* selItemDic = [tableList objectAtIndex:indexPath.row];
    int level = [[selItemDic objectForKey:@"level"] intValue];
    if (level == 1){
        NoticeCell *cell = (NoticeCell*)[tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:self options:nil];
            cell = [nib firstObject];
        }

        cell.lblData.text = [selItemDic objectForKey:@"title"];
        return cell;
    }
    else{
        NoticeContentCell *cell = (NoticeContentCell*)[tableView dequeueReusableCellWithIdentifier:@"NoticeContentCell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoticeContentCell" owner:self options:nil];
            cell = [nib firstObject];
        }
        
        NSString *labelText = [[selItemDic objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@""];
        
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&lt;p&gt;" withString:@"\n"];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&lt;/p&gt;" withString:@"\n"];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&lt;div&gt;" withString:@"\n"];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&lt;/div&gt;" withString:@""];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&#xA;" withString:@""];
        
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&#39;" withString:@""];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&#34;" withString:@""];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&#44;" withString:@""];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&lt;br /&gt;" withString:@"\n"];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&amp;quot;" withString:@""];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"&amp;nbsp;" withString:@""];
        
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
        CGRect aboutRect = [labelText boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *matches = [linkDetector matchesInString:labelText options:0 range:NSMakeRange(0, [labelText length])];
        NSString *urlString = @"";
        for (NSTextCheckingResult *match in matches) {
            if ([match resultType] == NSTextCheckingTypeLink) {
                NSURL *url = [match URL];
                urlString = [url absoluteString];
            }
        }
        
        NSLog(@"noticeList >> %@",labelText);

        if([urlString length] > 0){
            NSRange find_range = [labelText rangeOfString:urlString];
            
            NSMutableAttributedString *textString = [[NSMutableAttributedString alloc]
                                                     initWithString:labelText
                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]}];
            
            NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc]
                                                     initWithString:[labelText substringWithRange:find_range]
                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f],NSLinkAttributeName:urlString}];
            
            [textString replaceCharactersInRange:find_range withAttributedString:linkString];
            
            cell.lblData.frame = aboutRect;
            cell.lblData.userInteractionEnabled = YES;
            cell.lblData.dataDetectorTypes = UIDataDetectorTypeLink;
            cell.lblData.selectable = YES;
            cell.lblData.textContainer.lineFragmentPadding = 0;
            cell.lblData.delegate = self;
            
            [cell.lblData setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            cell.lblData.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
            [cell.lblData sizeToFit];
            [cell.lblData layoutIfNeeded];
            cell.lblData.attributedText = textString;
            
        }else{
            
            cell.lblData.text = labelText;
        }
        cell.lblData.frame = aboutRect;
        return cell;
    }
    return nil;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"urls is :- %@",URL);
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:URL];
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* selItemDic = [tableList objectAtIndex:indexPath.row];
    int level = [[selItemDic objectForKey:@"level"] intValue];
    if (level == 1){
        return 50;
    }
    else{
        NSString *labelText = [[selItemDic objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@""];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
        CGRect aboutRect = [labelText boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        
        return (int)aboutRect.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableList.count){
        NSMutableDictionary* selItemDic = [tableList objectAtIndex:indexPath.row];
        int level = [[selItemDic objectForKey:@"level"] intValue];
        NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
        
        if (cellStatus != SUB_NO_CATEGORIES){
            if (level == 1){
                if (cellStatus == SUB_CATEGORIES_NO_EXPOSE){
                    [selItemDic setObject:[NSNumber numberWithInt:SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
                    //하위레벨 삽입
                    NSString* title = [selItemDic objectForKey:@"title"];
                    int subIndex = [WorkUtil getNoticeIndex:title noticeList:subContentList];
                    if (subIndex != -1)
                    {
                        NSDictionary* subItemDic = [subContentList objectAtIndex:subIndex];
                        NSIndexPath* insertIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
                        [tableList insertObject:subItemDic atIndex:indexPath.row+1];
                        
                        [_tableView beginUpdates];
                        [_tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [_tableView endUpdates];
                    }
                }
                else{ //delete
                        [selItemDic setObject:[NSNumber numberWithInt:SUB_CATEGORIES_NO_EXPOSE] forKey:@"exposeStatus"];
                    
                        NSIndexPath* deleteIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
                        [tableList removeObjectAtIndex:indexPath.row+1];

                        [_tableView beginUpdates];
                        [_tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [_tableView endUpdates];
                    
                }
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
@end
