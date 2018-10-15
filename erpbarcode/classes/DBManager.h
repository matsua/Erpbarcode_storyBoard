//
//  DBManager.h
//  Coupang
//
//  Created by 이 승환 on 12. 3. 27..
//  Copyright (c) 2012년 InfoTM. All rights reserved.
// 

#import <Foundation/Foundation.h>
//#import "/usr/include/sqlite3.h"
#import <sqlite3.h>
@interface DBManager : NSObject

+ (DBManager*)sharedInstance;

- (BOOL)executeQuery:(NSString*)SQLQuery;
- (NSMutableArray*)executeSelectQuery:(NSString*)SQLQuery;
- (int)countSelectQuery:(NSString*)SQLQuery;

- (sqlite3*)getDatabaseObject;

- (NSArray *)columnTypesForStatement: (sqlite3_stmt *) statement;
- (NSArray *)columnNamesForStatement: (sqlite3_stmt *) statement;
- (void)copyValuesFromStatement: (sqlite3_stmt *) statement toRow: (id) row columnTypes: (NSArray *) columnTypes columnNames: (NSArray *) columnNames;
- (NSArray*)getGoodsSearchByMATNR:(NSString*)matnr MAKTX:(NSString*)maktx BISMT:(NSString*)bismt PDA_FLAG:(BOOL)isOnlyPDA ERROR_MSG:(NSString*)errorMsg;
- (BOOL)saveWorkData:(NSDictionary*)workData ToWorkDBWithId:(NSString*)id;


@end
