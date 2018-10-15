//
//  DBManager.m
//  Coupang
//
//  Created by 이 승환 on 12. 3. 27..
//  Copyright (c) 2012년 InfoTM. All rights reserved.
//

#import "DBManager.h"
#import "dbquerys.h"


static  DBManager*    g_sharedInstance = nil;



@interface DBManager ()

@property (nonatomic, assign)   sqlite3     *database;

- (id)initWithDB;

@end



@implementation DBManager

@synthesize database;

+ (DBManager*)sharedInstance
{
    if (g_sharedInstance)
        return g_sharedInstance;
    
    @synchronized(self)
    {
        if (!g_sharedInstance)
        {
            g_sharedInstance = [[self alloc] initWithDB];
        }
    }
    
    return g_sharedInstance;
}

- (id)initWithDB
{
    self = [super init];
    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentdirectory = [paths objectAtIndex:0];
        NSString *dbFilePath = [documentdirectory stringByAppendingPathComponent:@"database.sqlite"];
        NSLog(@"success to create table\n%@", dbFilePath);
        
        int result = sqlite3_open([dbFilePath UTF8String], &database);
        if (result != SQLITE_OK) 
        {
            NSLog(@"failed to open image db , result code : %d\n%@", result, dbFilePath);
        }
        else 
        {
            NSArray *dbQueryList = [NSArray arrayWithObjects:
                                    CREATE_TABLE_BP_ITEM,
                                    CREATE_TABLE_BP_NOTICE,
                                    CREATE_TABLE_USER_INFO_LIST,
                                    CREATE_TABLE_WORK_INFO,
                                    CREATE_INDEX_MATERIALSEQ,
                                    CREATE_INDEX_MATNR,
                                    CREATE_INDEX_BISMT,
                                    CREATE_TABLE_BP_ITEM,
                                    nil];
            
            for (NSString *createSQL in dbQueryList)
            {
                char *pszErrMsg = NULL;
                result = sqlite3_exec (database, [createSQL UTF8String], NULL, NULL, &pszErrMsg);
                if (result != SQLITE_OK) 
                {
                    NSLog(@"failed to create table , result code:[%d] error:[%s] \n%@", result,pszErrMsg, createSQL);
                }
            }
        }
    }
    
    return self;
}


- (int)columnTypeToInt: (NSString *) columnType {
	if ([columnType isEqualToString:@"INTEGER"]) {
		return SQLITE_INTEGER;
	}
	else if ([columnType isEqualToString:@"REAL"]) {
		return SQLITE_FLOAT;
	}
	else if ([columnType isEqualToString:@"TEXT"]) {
		return SQLITE_TEXT;
	}
	else if ([columnType isEqualToString:@"BLOB"]) {
		return SQLITE_BLOB;
	}
	else if ([columnType isEqualToString:@"NULL"]) {
		return SQLITE_NULL;
	}
	return SQLITE_TEXT;
}

- (int)typeForStatement: (sqlite3_stmt *) statement column: (int) column {
	const char * columnType = sqlite3_column_decltype(statement, column);
	
	if (columnType != NULL) {
		return [self columnTypeToInt: [[NSString stringWithUTF8String: columnType] uppercaseString]];
	}
	return sqlite3_column_type(statement, column);
}

- (NSArray *)columnTypesForStatement: (sqlite3_stmt *) statement {
	int columnCount = sqlite3_column_count(statement);
	
	NSMutableArray *columnTypes = [NSMutableArray array];
	for(int idx = 0; idx < columnCount; idx++) {
		[columnTypes addObject:[NSNumber numberWithInt:[self typeForStatement:statement column:idx]]];
	}

	return columnTypes;
}

- (NSArray *)columnNamesForStatement: (sqlite3_stmt *) statement {
	int columnCount = sqlite3_column_count(statement);
	
	NSMutableArray *columnNames = [NSMutableArray array];
	for (int idx = 0; idx < columnCount; idx++) {
		[columnNames addObject:[NSString stringWithUTF8String:sqlite3_column_name(statement, idx)]];
	}
    
	return columnNames;
}

- (id)valueFromStatement: (sqlite3_stmt *) statement column: (int) column columnTypes: (NSArray *) columnTypes {	
	int columnType = [[columnTypes objectAtIndex:column] intValue];
	
	if (columnType == SQLITE_INTEGER) {
		return [NSNumber numberWithInt:sqlite3_column_int(statement, column)];
	}
	else if (columnType == SQLITE_FLOAT) {
		return [NSNumber numberWithDouble: sqlite3_column_double(statement, column)];
	}
	else if (columnType == SQLITE_TEXT) {
		const char *text = (const char *) sqlite3_column_text(statement, column);
        
		if (text != nil) {
			return [NSString stringWithUTF8String:text];
		}
		else {
			return nil;
		}
	}
	else if (columnType == SQLITE_BLOB) {
		return [NSData dataWithBytes:sqlite3_column_blob(statement, column) length:sqlite3_column_bytes(statement, column)];
	}
	else if (columnType == SQLITE_NULL) {
		return nil;
	}
	return nil;
}

- (void)copyValuesFromStatement: (sqlite3_stmt *) statement toRow: (id) row columnTypes: (NSArray *) columnTypes columnNames: (NSArray *) columnNames {
	int columnCount = sqlite3_column_count(statement);
	
	for (int idx = 0; idx < columnCount; idx++) {
		id value = [self valueFromStatement:statement column:idx columnTypes: columnTypes];
		
        if(value != nil) {
			[row setValue: value forKey: [columnNames objectAtIndex:idx]];
        }
	}
}

- (BOOL)executeQuery:(NSString*)SQLQuery
{
	char *szErrMsg = nil;
    int result = sqlite3_exec(database, [SQLQuery UTF8String], nil,nil,&szErrMsg);
	if (result != SQLITE_OK) 
    {
		NSLog(@"%s Error %d , %s\n%@", __func__, result, szErrMsg, SQLQuery);
        if (szErrMsg)
        {
            sqlite3_free(szErrMsg);
        }
        
		return NO;
	}

	return YES;
}

- (NSMutableArray*)executeSelectQuery:(NSString*)SQLQuery
{
    NSLog(@"%s %@", __func__, SQLQuery);
	NSMutableArray *resultArray = [NSMutableArray array]; 
	sqlite3_stmt *statement; 

    int result = sqlite3_prepare_v2(database, [SQLQuery UTF8String], -1, &statement, NULL);
	if (result == SQLITE_OK) 
    {
		BOOL needsToFetchColumnTypesAndNames = YES;
		NSArray *columnTypes = nil;
		NSArray *columnNames = nil;
		while (sqlite3_step(statement)== SQLITE_ROW) 
        {
			if (needsToFetchColumnTypesAndNames) 
            {
				columnTypes = [self columnTypesForStatement: statement];
				columnNames = [self columnNamesForStatement: statement];
				needsToFetchColumnTypesAndNames = NO;
			}
			
			NSMutableDictionary *row = [NSMutableDictionary dictionary];
			[self copyValuesFromStatement: statement toRow: row columnTypes: columnTypes columnNames: columnNames];
			[resultArray addObject:row];
		}
	}
    else 
    {
        NSLog(@"%s failed to select query , result code : %d\n%@", __func__, result, SQLQuery);
    }
	sqlite3_finalize(statement);
    
	return resultArray;
}

- (int)countSelectQuery:(NSString*)SQLQuery
{
    NSLog(@"%s %@", __func__, SQLQuery);

	sqlite3_stmt *statement;
    int count = 0;

    int result = sqlite3_prepare_v2(database, [SQLQuery UTF8String], -1, &statement, NULL);
	if (result == SQLITE_OK)
    {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            count = sqlite3_column_int(statement, 0);
        }
	}
	sqlite3_finalize(statement);
	
	return count;
}

- (sqlite3*)getDatabaseObject
{
    return database;
}

- (NSArray*)getGoodsSearchByMATNR:(NSString*)matnr MAKTX:(NSString*)maktx BISMT:(NSString*)bismt PDA_FLAG:(BOOL)isOnlyPDA ERROR_MSG:(NSString*)errorMsg
{
    if (!matnr.length && !maktx.length){
        errorMsg = @"물품코드 또는 물품명을 입력하세요.";
        return nil;
    }
        
    if (matnr.length > 0 && matnr.length < 6){
        errorMsg = @"물품코드를 6자리 이상 입력하세요.";
        return nil;
    }
    
    if (maktx.length > 0 && maktx.length < 3){
        errorMsg = @"물품명을 3자리 이상 입력하세요.";
        return nil;
    }
    
    NSString* strQuery = @"SELECT DISTINCT(MATNR), MAKTX, ZEMAFT_NAME, ZMATGB, COMPTYPE, MTART, BARCD, BISMT, EQSHAPE, '' as ITEMCLASSIFICATIONNAME FROM BP_I_ITEM WHERE 1=1";

    if (matnr.length){
        NSString* strWhere = [NSString stringWithFormat:@" and MATNR like '%@%%'", matnr];
        strQuery = [strQuery stringByAppendingString:strWhere];
    }
    if (maktx.length)
        strQuery = [strQuery stringByAppendingString:[NSString stringWithFormat:@" and MAKTX like '%%%@%%'", maktx]];
    if (bismt.length)
        strQuery = [strQuery stringByAppendingString:[NSString stringWithFormat:@" and BISMT like '%%%@%%'", bismt]];

    NSArray* dbDataList = [self executeSelectQuery:strQuery];
//    NSLog(@"dbDataList [%@]",dbDataList);
    
    return dbDataList;
}

- (BOOL)saveWorkData:(NSDictionary*)workData ToWorkDBWithId:(NSString*)id
{
    //    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"])
    //        return NO;
    
    NSDictionary* workDic = [workData objectForKey:@"WORKDIC"];
    NSArray* taskList = [workData objectForKey:@"TASKLIST"];
    NSDictionary* receivedOrgDic = [workData objectForKey:@"ORGDIC"];
    
    
    sqlite3 *dbObject = [[DBManager sharedInstance] getDatabaseObject];
    
    char* errorMessage;
    sqlite3_exec(dbObject, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
    
    sqlite3_stmt* stmt;
    
    const char* sqlQuery;
    
    if (![id isEqualToString:@""]){
        NSString* strQuery = [NSString stringWithFormat:UPDATE_WORK_INFO_ID, id];
        sqlQuery = [strQuery UTF8String];
    }else{
        sqlQuery = INSERT_WORK_INFO;
    }
    
    int sqlReturn = sqlite3_prepare_v2(dbObject, sqlQuery, (int)strlen(sqlQuery), &stmt, NULL);
    
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: '%s'.", sqlite3_errmsg(dbObject));
        return NO;
    }
    
    int dbSuccessCount = 0;
    
    const char* WORK_CD = [[workDic objectForKey:@"WORK_CD"] UTF8String];
    const char* TRANSACT_YN = [[workDic objectForKey:@"TRANSACT_YN"] UTF8String];
    const char* TRANSACT_MSG = [[workDic objectForKey:@"TRANSACT_MSG"] UTF8String];
    const char* LOC_CD = [[workDic objectForKey:@"LOC_CD"] UTF8String];
    const char* LOC_NAME = [[workDic objectForKey:@"LOC_NAME"] UTF8String];
    const char* DEVICE_ID = [[workDic objectForKey:@"DEVICE_ID"] UTF8String];
    const char* UFAC_CD = [[workDic objectForKey:@"UFAC_CD"] UTF8String];
    const char* OFFLINE = [[workDic objectForKey:@"OFFLINE"] UTF8String];
    const char* WBS = [[workDic objectForKey:@"WBS"] UTF8String];
    const char* TREE_YN = [[workDic objectForKey:@"TREE_YN"] UTF8String];
    const char* UU_YN = [[workDic objectForKey:@"UU_YN"] UTF8String];
    const char* SCAN_YN = [[workDic objectForKey:@"SCAN_YN"] UTF8String];
    const char* ORDER_YN = [[workDic objectForKey:@"ORDER_YN"] UTF8String];
    const char* PICKER_ROW = [[workDic objectForKey:@"PICKER_ROW"] UTF8String];
    const char* strComment = [[workDic objectForKey:@"COMMENT"] UTF8String];
    const char* SAVE_TIME = [[NSDate TodayStringWithDashNColon] UTF8String];
    
    sqlite3_bind_text(stmt, 1, WORK_CD, (int)strlen(WORK_CD), SQLITE_STATIC);
    sqlite3_bind_text(stmt, 2, TRANSACT_YN, (int)strlen(TRANSACT_YN), SQLITE_STATIC);
    if (TRANSACT_MSG)
        sqlite3_bind_text(stmt, 3, TRANSACT_MSG, (int)strlen(TRANSACT_MSG),SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 3, nil,-1,SQLITE_STATIC);
    if (LOC_CD)
        sqlite3_bind_text(stmt, 4, LOC_CD, (int)strlen(LOC_CD), SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 4, nil,-1,SQLITE_STATIC);
    if (LOC_NAME)
        sqlite3_bind_text(stmt, 5, LOC_NAME,(int)strlen(LOC_NAME), SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 5, nil,-1,SQLITE_STATIC);
    if (DEVICE_ID)
        sqlite3_bind_text(stmt, 6, DEVICE_ID, (int)strlen(DEVICE_ID), SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 6, nil,-1,SQLITE_STATIC);
    
    if (UFAC_CD)
        sqlite3_bind_text(stmt, 7, UFAC_CD, (int)strlen(UFAC_CD),    SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 7, nil,-1,SQLITE_STATIC);
    
    sqlite3_bind_text(stmt, 8, OFFLINE, (int)strlen(OFFLINE)  , SQLITE_STATIC);
    
    if (WBS)
        sqlite3_bind_text(stmt, 9, WBS, (int)strlen(WBS),SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 9, nil,-1,SQLITE_STATIC);
    
    if (taskList.count){
        NSData *taskData = [NSKeyedArchiver archivedDataWithRootObject:taskList];
        sqlite3_bind_blob(stmt, 10,[taskData bytes],   (int)taskData.length,    SQLITE_STATIC);
    }
    else {
        sqlite3_bind_blob(stmt, 10,nil,-1, SQLITE_STATIC);
    }
    
    if (TREE_YN)
        sqlite3_bind_text(stmt, 11, TREE_YN,(int)strlen(TREE_YN),SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 11,nil,-1, SQLITE_STATIC);
    if (UU_YN)
        sqlite3_bind_text(stmt, 12, UU_YN,(int)strlen(UU_YN),SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 12,nil,-1, SQLITE_STATIC);
    if (SCAN_YN)
        sqlite3_bind_text(stmt, 13, SCAN_YN,(int)strlen(SCAN_YN),SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 13,nil,-1, SQLITE_STATIC);
    if (ORDER_YN)
        sqlite3_bind_text(stmt, 14, ORDER_YN,(int)strlen(ORDER_YN),SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 14,nil,-1, SQLITE_STATIC);
    if (PICKER_ROW)
        sqlite3_bind_text(stmt, 15, PICKER_ROW,(int)strlen(PICKER_ROW),SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 15,nil,-1, SQLITE_STATIC);
    
    if (receivedOrgDic != nil && receivedOrgDic.count){
        NSData *orgData = [NSKeyedArchiver archivedDataWithRootObject:receivedOrgDic];
        sqlite3_bind_blob(stmt, 16,[orgData bytes],   (int)orgData.length,    SQLITE_STATIC);
    }
    else {
        sqlite3_bind_blob(stmt, 16,nil,-1, SQLITE_STATIC);
    }
    if (strComment)
        sqlite3_bind_text(stmt, 17, strComment,       (int)strlen(strComment),    SQLITE_STATIC);
    else
        sqlite3_bind_text(stmt, 17,nil,-1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 18, SAVE_TIME, (int)strlen(SAVE_TIME), SQLITE_STATIC);
    
    
    
    if (sqlite3_step(stmt) != SQLITE_DONE)
    {
        NSLog(@"failed to sqlite3_step - error : %d\n dic[%@]", sqlite3_step(stmt),workDic);
    }
    else
    {
        dbSuccessCount++;
        sqlite3_reset(stmt);
    }
    NSLog(@"success count [%d]",dbSuccessCount);
    
    sqlite3_exec(dbObject, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    sqlite3_finalize(stmt);
    
    return YES;
}


@end
