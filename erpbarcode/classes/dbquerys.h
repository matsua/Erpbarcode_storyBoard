//
//  dbquerys.h
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 9. 10..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#ifndef erpbarcode_dbquerys_h
#define erpbarcode_dbquerys_h

//BP_NOTICE(NOTICE_SEQ, USE_YN, NOTICE_DATE)
#define CREATE_TABLE_BP_NOTICE @"CREATE TABLE IF NOT EXISTS [BP_NOTICE] (\
[NOTICE_SEQ] nvarchar(20) primary key, \
[USE_YN] nvarchar(1) NULL, \
[NOTICE_DATE] nvarchar(8) NULL)"


#define CREATE_TABLE_USER_INFO_LIST @"CREATE TABLE IF NOT EXISTS [USER_INFO_LIST] (\
[USER_ID] nvarchar(20) NULL, \
[USER_NAME] nvarchar(100) NULL, \
[USER_PASSWD] nvarchar(20) NULL, \
[ORG_CODE] nvarchar(20) NULL, \
[ORG_NAME] nvarchar(100) NULL, \
[TEL_NO] nvarchar(30) NULL, \
[EAI_CDATE] nvarchar(17) NULL)"

/*[WORK_NAME]         nvarchar(5)    NULL,    \*/
/*
 WORK_CD : JOB_GUBUN
 TRANSACT_YN - E : 0 W : 2 S : 1
 SAVE_TIME 
 TRANSACT_MSG - 결과 메세지
 COMMENT - 고장등록 고장내역
 TASK - thread로 돌려야 할 작업리스트(NSArray*)
 ORGCODE - 접수조직 등
 */
#define CREATE_TABLE_WORK_INFO  @"CREATE TABLE IF NOT EXISTS [WORK_INFO] (\
[ID]                integer primary key autoincrement, \
[WORK_CD]           nvarchar(5)    NULL,    \
[TRANSACT_YN]       nvarchar(1)    NULL,    \
[SAVE_TIME]         datetime       DEFAULT (datetime('now', 'localtime')),        \
[TRANSACT_MSG]      nvarchar(250)  NULL,        \
[LOC_CD]            nvarchar(30)   NULL,        \
[LOC_NAME]          nvarchar(30)   NULL,        \
[DEVICE_ID]         nvarchar(30)   NULL,        \
[UFAC_CD]           nvarchar(1)    NULL,        \
[UU_YN]             nvarchar(1)    NULL,        \
[TREE_YN]           nvarchar(1)    NULL,        \
[SCAN_YN]           nvarchar(1)    NULL,        \
[ORDER_YN]          nvarchar(1)    NULL,        \
[PICKER_ROW]        nvarchar(1)    NULL,        \
[COMMENT]           nvarchar(200)  NULL,        \
[WBS]               nvarchar(20)   NULL,        \
[OFFLINE]           nvarchar(1)    NULL,        \
[TASK]              blob,        \
[ORGCODE]           blob)"

#define CREATE_TABLE_WORK_TASK  @"CREATE TABLE IF NOT EXISTS [WORK_TASK] (\
[ID]                integer primary key autoincrement, \
[WORK_NAME]     nvarchar(20)    NOT NULL,    \
[TASK]          nvarchar(20)    NOT NULL,    \
[SAVE_TIME]         datetime    DEFAULT (datetime('now', 'localtime')),        \
[VALUE]       nvarchar(20)    NOT NULL)"

#define CREATE_TABLE_BP_ITEM   @"CREATE TABLE IF NOT EXISTS [BP_I_ITEM] (\
[MATERIALSEQ]   nvarchar(20)    NOT NULL,    \
[MATNR]         nvarchar(20)    NOT NULL,    \
[MAKTX]         nvarchar(150)   NULL,        \
[MTART]         nvarchar(5)     NULL,        \
[ZMATGB]        nvarchar(2)     NULL,        \
[BISMT]         nvarchar(18)    NULL,        \
[EQSHAPE]       nvarchar(2)     NULL,        \
[COMPTYPE]      nvarchar(2)     NULL,        \
[ZZOLDBARCDIND] nvarchar(3)     NULL,        \
[ZZOLDBARMATL]  nvarchar(20)    NULL,        \
[ZZNEWBARCDIND] nvarchar(3)     NULL,        \
[ZZNEWBARMATL]  nvarchar(20)    NULL,        \
[ZEMAFT]        nvarchar(3)     NULL,        \
[ZEMAFT_NAME]   nvarchar(120)   NULL,        \
[ZEFAMATNR]     nvarchar(18)    NULL,        \
[EXTWG]         nvarchar(18)    NULL,        \
[STATUS]        nvarchar(4)     NULL,        \
[BARCD]         nvarchar(4)     NULL,        \
[EAI_CDATE]     nvarchar(17)    NULL)"


#define ALTER_TABLE_BP_ITEM   @"CREATE TABLE [BP_I_ITEM] (\
[MATERIALSEQ]   nvarchar(20)    NOT NULL,    \
[MATNR]         nvarchar(20)    NOT NULL,    \
[MAKTX]         nvarchar(150)   NULL,        \
[MTART]         nvarchar(5)     NULL,        \
[ZMATGB]        nvarchar(2)     NULL,        \
[BISMT]         nvarchar(18)    NULL,        \
[EQSHAPE]       nvarchar(2)     NULL,        \
[COMPTYPE]      nvarchar(2)     NULL,        \
[ZZOLDBARCDIND] nvarchar(3)     NULL,        \
[ZZOLDBARMATL]  nvarchar(20)    NULL,        \
[ZZNEWBARCDIND] nvarchar(3)     NULL,        \
[ZZNEWBARMATL]  nvarchar(20)    NULL,        \
[ZEMAFT]        nvarchar(3)     NULL,        \
[ZEMAFT_NAME]   nvarchar(120)   NULL,        \
[ZEFAMATNR]     nvarchar(18)    NULL,        \
[EXTWG]         nvarchar(18)    NULL,        \
[STATUS]        nvarchar(4)     NULL,        \
[BARCD]         nvarchar(4)     NULL,        \
[EAI_CDATE]     nvarchar(17)    NULL)"

#define CREATE_INDEX_MATERIALSEQ   @"CREATE UNIQUE INDEX IF NOT EXISTS idx_materialseq ON BP_I_ITEM (MATERIALSEQ)"
#define CREATE_INDEX_MATNR_BISMT   @"CREATE INDEX IF NOT EXISTS idx_matnr_bismt ON BP_I_ITEM (MATNR,BISMT)"

#define CREATE_INDEX_MATNR         @"CREATE INDEX IF NOT EXISTS idx_matnr ON BP_I_ITEM (MATNR)"
#define CREATE_INDEX_BISMT         @"CREATE INDEX IF NOT EXISTS idx_bismt ON BP_I_ITEM (BISMT)"

//DROP
#define DROP_INDEX_MATNR_BISMT     @"DROP INDEX idx_matnr_bismt"
#define DROP_TABLE_BP_ITEM  @"DROP TABLE BP_I_ITEM"
#define DROP_TABLE_WORK_INFO  @"DROP TABLE WORK_INFO"
#define DROP_TABLE_BP_NOTICE  @"DROP TABLE BP_NOTICE"
#define DROP_TABLE_SETUPINFO    @"DROP TABLE SETUP_INFO"

//DELETE
#define DELETE_TABLE_ITEM_ALL          @"DELETE FROM BP_I_ITEM"
#define DELETE_TABLE_WORK_INFO         @"DELETE FROM WORK_INFO WHERE ID=%d"
//#define DELETE_TABLE_USER_INFO_LIST    @"DELETE FROM USER_INFO_LIST WHERE USER_ID = '10049868'"


//INSERT
#define INSERT_USER_INFO_LIST   @"INSERT INTO USER_INFO_LIST(\
USER_ID,        \
USER_NAME,      \
USER_PASSWD,    \
ORG_CODE,       \
ORG_NAME,       \
TEL_NO,         \
EAI_CDATE)      \
VALUES          \
('%@','%@','%@','%@','%@','%@','%@');"
//(?1,?2,?3,?4,?5,?6,?7);"


#define INSERT_BP_NOTICE    "INSERT OR REPLACE INTO BP_NOTICE(\
NOTICE_SEQ,     \
USE_YN,         \
NOTICE_DATE)    \
VALUES          \
(?1,?2,?3);"

#define INSERT_MANTR   "INSERT OR REPLACE INTO BP_I_ITEM(\
MATERIALSEQ,    \
MATNR,          \
MAKTX,          \
ZMATGB,         \
BISMT,          \
COMPTYPE,       \
ZEMAFT,         \
ZEMAFT_NAME,    \
EAI_CDATE,      \
STATUS,         \
EXTWG,          \
MTART,          \
BARCD)          \
VALUES          \
(?1,?2,?3,?4,?5,?6,?7,?8,?9,?10,?11,?12,?13);"


#define INSERT_WORK_INFO   "INSERT OR REPLACE INTO WORK_INFO(\
WORK_CD,              \
TRANSACT_YN,          \
TRANSACT_MSG,         \
LOC_CD,               \
LOC_NAME,             \
DEVICE_ID,            \
UFAC_CD,              \
OFFLINE,              \
WBS,                  \
TASK,                 \
TREE_YN,              \
UU_YN,                \
SCAN_YN,              \
ORDER_YN,             \
PICKER_ROW,           \
ORGCODE,              \
COMMENT)              \
VALUES                \
(?1,?2,?3,?4,?5,?6,?7,?8,?9,?10,?11,?12,?13,?14,?15,?16,?17);"

//pk_값이 있는경우 update 할 경우 id 1번으로 처리.
#define INSERT_WORK_INFO_ID   "INSERT OR REPLACE INTO WORK_INFO(\
ID,                   \
WORK_CD,              \
TRANSACT_YN,          \
TRANSACT_MSG,         \
LOC_CD,               \
LOC_NAME,             \
DEVICE_ID,            \
UFAC_CD,              \
OFFLINE,              \
WBS,                  \
TASK,                 \
TREE_YN,              \
UU_YN,                \
SCAN_YN,              \
ORDER_YN,             \
PICKER_ROW,           \
ORGCODE,              \
COMMENT)              \
VALUES                \
(?1,?2,?3,?4,?5,?6,?7,?8,?9,?10,?11,?12,?13,?14,?15,?16,?17) WHERE ID=%d;"

//pk_값이 있는경우 update 할 경우 id 1번으로 처리.
#define UPDATE_WORK_INFO_ID   @"UPDATE WORK_INFO SET \
WORK_CD = ?1,              \
TRANSACT_YN = ?2,          \
TRANSACT_MSG = ?3,         \
LOC_CD = ?4,               \
LOC_NAME = ?5,             \
DEVICE_ID = ?6,            \
UFAC_CD = ?7,              \
OFFLINE = ?8,              \
WBS = ?9,                  \
TASK = ?10,                 \
TREE_YN = ?11,              \
UU_YN = ?12,                \
SCAN_YN = ?13,              \
ORDER_YN = ?14,             \
PICKER_ROW = ?15,           \
ORGCODE = ?16,              \
COMMENT = ?17,              \
SAVE_TIME = ?18             \
WHERE ID=%@;"


#define UPDATE_USER_INFO_LIST   @"UPDATE USER_INFO_LIST SET \
USER_ID = '%@',        \
USER_NAME = '%@',      \
USER_PASSWD = '%@',    \
ORG_CODE = '%@',       \
ORG_NAME = '%@',       \
TEL_NO = '%@',         \
EAI_CDATE = '%@'      \
WHERE USER_ID='%@'"

//INSERT INTO BP_NOTICE(NOTICE_SEQ, USE_YN, NOTICE_DATE)


/*
 "EAI_CDATE": "20120609123625663",
 "ZZNEWBARCDIND": null,
 "ZZOLDBARMATL": null,
 "ZEMAFT_NAME": "LG전자㈜ (엘지전자)",
 "ZZMATN": null,
 "ZZNEWBARMATL": null,
 "BARCD": "Y",
 "ZZOLDBARCDIND": null,
 "MAKTX": "LGT_ASMC",
 "ZMATGB": "40",
 "ZEFAMATNR": null,
 "STATUS": "USE",
 "ZEMAFT": "LGT",
 "EXTWG": "SG1018",
 "BISMT": "AGAM1100",
 "EAI_OP": "I",
 "totalCount": 93242,
 "rnum": 1,
 "MTART": "ERSA",
 "EQSHAPE": null,
 "MATERIALSEQ": 95536,
 "MATNR": "AGAM1100",
 "COMPTYPE": "30"
 */




//SELECT
#define SELECT_USER_INFO_LIST       @"SELECT USER_ID, USER_NAME, USER_PASSWD, TEL_NO, ORG_CODE, ORG_NAME FROM USER_INFO_LIST "

#define SELECT_GET_NOTICE_ITEM      @"SELECT NOTICE_SEQ FROM BP_NOTICE WHERE NOTICE_DATE = '%@' AND USE_YN = 'Y'"

#define SELECT_COUNT_ITEM_ALL       @"SELECT COUNT(MATNR) FROM BP_I_ITEM"
#define SELECT_ITEM_ALL             @"SELECT MATNR FROM BP_I_ITEM"
#define SELECT_ITEM_EAI_CDATE       @"SELECT * FROM BP_I_ITEM WHERE EAI_CDATE= '%@'"
#define SELECT_ITEM_BY_GOODS        @"SELECT DISTINCT(MATNR),MAKTX,ZEMAFT_NAME,ZMATGB,COMPTYPE, MTART, BARCD, BISMT FROM BP_I_ITEM"
//#define SELECT_WORK_INFO            @"SELECT * FROM WORK_INFO WHERE WORK_NAME= '%@' AND TRANSACT_YN= '%@' ORDER BY SAVE_TIME DESC"
//#define SELECT_WORK_INFO            @"SELECT * FROM WORK_INFO WHERE WORK_NAME= '%@' ORDER BY SAVE_TIME DESC"
#define SELECT_PICKER_WORK          @"SELECT WORK_CD FROM WORK_INFO GROUP BY WORK_CD"


#define SELECT_PICKER_DATE          @"SELECT strftime('%Y-%m-%d', SAVE_TIME) AS SAVE_TIME FROM WORK_INFO GROUP BY strftime('%Y-%m-%d', SAVE_TIME) ORDER BY  strftime('%Y-%m-%d', SAVE_TIME) DESC"
#define SELECT_WORK_DATA            @"SELECT * FROM WORK_INFO WHERE WORK_CD IS NOT NULL "
#define SELECT_WORK_DATA_FULL       @"SELECT * FROM WORK_INFO WHERE WORK_CD ='%@' AND strftime('%Y-%m-%d',SAVE_TIME) ='%@' AND TRANSACT_YN ='%@' ORDER BY SAVE_TIME DESC"
#define SELECT_WORK_DATA_1       @"SELECT * FROM WORK_INFO WHERE WORK_CD ='%@' ORDER BY SAVE_TIME DESC"
#define SELECT_WORK_DATA_2       @"SELECT * FROM WORK_INFO WHERE WORK_CD ='%@' AND strftime('%Y-%m-%d',SAVE_TIME) ='%@' ORDER BY SAVE_TIME DESC"

#define SELECT_WORK_INFO            @"SELECT * FROM WORK_INFO ORDER BY SAVE_TIME DESC"

#define SELECT_SOUND_FROM_SETUPINFO @"SELECT SOUND FROM SETUP_INFO"

#define SELECT_LAST_ID_FROM_WORK_INFO @"SELECT MAX(ID) FROM WORK_INFO"

//CONVERT(nvarchar(10), INPUT_TIME, 21)

//#define RECORD_QUERY_CategoryList_Top1          @"SELECT * FROM CategoryList LIMIT 1"
//#define RECORD_QUERY_DealList_BySubCategory     @"SELECT * FROM DealList WHERE cate1Code = '%@' AND cate2Code = '%@'"
//#define RECORD_DELETE_FavoriteList               @"DELETE FROM FavoriteList WHERE coupangSrl = '%@'"
#endif
