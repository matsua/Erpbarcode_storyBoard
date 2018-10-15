//
//  KDCConstants.h
//  KDCReader
//
//  Created by KoamTac on 10/18/14.
//  Copyright (c) 2014 AISolution. All rights reserved.
//

#ifndef KDCReader_KDCConstants_h
#define KDCReader_KDCConstants_h

typedef NS_ENUM(NSInteger, EnableDisable)
{
    DISABLE = 0,
    ENABLE
};

typedef NS_ENUM(NSInteger, KDCMode)
{
    NORMAL = 0,
    APPLICATION
};

typedef NS_ENUM(NSInteger, DataDelimiter)
{
    DATA_NONE = 0,
    DATA_TAB,
    DATA_SPACE,
    DATA_COMMA,
    DATA_SEMICOLON
};

typedef NS_ENUM(NSInteger, RecordDelimiter)
{
    RECORD_NONE = 0,
    RECORD_LF,
    RECORD_CR,
    RECORD_TAB,
    RECORD_CRnLF
};

typedef NS_ENUM(NSInteger, NFCDataFormat)
{
    NFC_PACKET_FORMAT = 0,
    NFC_DATA_ONLY
};

typedef NS_ENUM(NSInteger, AESKeyLength)
{
    AES_KEY_128 = 0,
    AES_KEY_192,
    AES_KEY_256
};

typedef NS_ENUM(NSInteger, WedgeMode)
{
    WEDGE_ONLY = 0,
    WEDGE_STORE,
    STORE_ONLY,
    STORE_IF_SENT,
    STORE_IF_NOT_SENT
};

typedef NS_ENUM(NSInteger, AIMID)
{
    AIMID_NONE = 0,
    AIMID_PREFIX,
    AIMID_SUFFIX,
    IN_PREFIX = AIMID_PREFIX,
    IN_SUFFIX = AIMID_SUFFIX
};

typedef NS_ENUM(NSInteger, DataTerminator)
{
    TERMINATOR_NONE = 0,
    TERMINATOR_CR,
    TERMINATOR_LF,
    TERMINATOR_CRnLF,
    TERMINATOR_TAB,
    RIHGT_ARROW,
    LEFT_ARROW,
    DOWN_ARROW,
    UP_ARROW
};

typedef NS_ENUM(NSInteger, PowerOnTime)
{
    POWERON_DISABLED = 0,
    POWERON_1_SECOND,
    POWERON_2_SECONDS,
    POWERON_3_SECONDS,
    POWERON_4_SECONDS,
    POWERON_5_SECONDS,
    POWERON_6_SECONDS,
    POWERON_7_SECONDS,
    POWERON_8_SECONDS,
    POWERON_9_SECONDS,
    POWERON_10_SECONDS
};

typedef NS_ENUM(NSInteger, SleepTimeout)
{
    SLEEP_TIMEOUT_DISABLED = 0,
    SLEEP_TIMEOUT_1_SECOND = 1,
    SLEEP_TIMEOUT_2_SECONDS = 2,
    SLEEP_TIMEOUT_3_SECONDS = 3,
    SLEEP_TIMEOUT_4_SECONDS = 4 ,
    SLEEP_TIMEOUT_5_SECONDS = 5,
    SLEEP_TIMEOUT_10_SECONDS = 10,
    SLEEP_TIMEOUT_20_SECONDS = 20,
    SLEEP_TIMEOUT_30_SECONDS = 30,
    SLEEP_TIMEOUT_60_SECONDS = 60,
    SLEEP_TIMEOUT_120_SECONDS = 120,
    SLEEP_TIMEOUT_300_SECONDS = 300,
    SLEEP_TIMEOUT_600_SECONDS = 600
};

typedef NS_ENUM(NSInteger, DisplayFormat)
{
    TIME_BATTERY = 0,
    DISPLAY_FORMAT_TYPE_TIME,
    DISPLAY_FORMAT_TYPE_BATTERY,
    DISPLAY_FORMAT_MEMORY_STATUS,
    DISPLAY_FORMAT_GPS_DATA,
    DISPLAY_FORMAT_BARCODE_ONLY
};

typedef NS_ENUM(NSInteger, AutoPowerOffTimeout)
{
    POWEROFF_DISABLE = 0,
    POWEROFF_5_MINUTES = 5,
    POWEROFF_10_MINUTES = 10,
    POWEROFF_20_MINUTES = 20,
    POWEROFF_30_MINUTES = 30,
    POWEROFF_60_MINUTES = 60,
    POWEROFF_120_MINUTES = 120
};

struct DateTime
{
    uint8_t     Year;
    uint8_t     Month;
    uint8_t     Day;
    uint8_t     Hour;
    uint8_t     Minute;
    uint8_t     Second;
};

typedef NS_ENUM(NSInteger, MemoryConfiguration)
{
    MEMORY_0p5M_3p5M = 0,
    MEMORY_1M_3M,
    MEMORY_2M_2M,
    MEMORY_3M_1M,
    MEMORY_4M_0M
};

typedef NS_ENUM(NSInteger, GPSPowerSaveMode)
{
    GPS_NORMAL = 0,
    GPS_POWER_SAVE
};

struct BarcodeSymbolSettings
{
    uint32_t    FirstSymbols;
    uint32_t    SecondSymbols;
};

struct BarcodeOptionSettings
{
    uint32_t    FirstOptions;
    uint32_t    SecondOptions;
};

typedef NS_ENUM(NSInteger, ScanTimeout)
{
    SCANTIMEOUT_500_MS = 500,
    SCANTIMEOUT_1_SECOND = 1000,
    SCANTIMEOUT_2_SECONDS = 2000,
    SCANTIMEOUT_3_SECONDS = 3000,
    SCANTIMEOUT_4_SECONDS = 4000,
    SCANTIMEOUT_5_SECONDS = 5000,
    SCANTIMEOUT_6_SECONDS = 6000,
    SCANTIMEOUT_7_SECONDS = 7000,
    SCANTIMEOUT_8_SECONDS = 8000,
    SCANTIMEOUT_9_SECONDS = 9000,
    SCANTIMEOUT_10_SECONDS = 10000
};

typedef NS_ENUM(NSInteger, AutoTriggerRereadDelay)
{
    REREAD_CONTINUOUS = 0,
    REREAD_SHORT,
    REREAD_MEDIUM,
    REREAD_LONG,
    REREAD_EXTRA_LONG
};

typedef NS_ENUM(NSInteger, PartialAction)
{
    ERASE = 0,
    SELECT
};

typedef NS_ENUM(NSInteger, DataFormat)
{
    BARCODE_ONLY = 0,
    PACKET_DATA
};

typedef NS_ENUM(NSInteger, MessageFontSize)
{
    FONT_8x8 = 0,
    FONT_8x16,
    FONT_16x16,
    FONT_16x24,
    FONT_16x32,
    FONT_24x24,
    FONT_24x32,
    FONT_32x32
};

typedef NS_ENUM(NSInteger, MessageTextAttribute)
{
    NORMAL_TEXT = 0,
    REVERSE_TEXT
};

typedef NS_ENUM(NSInteger, LEDState)
{
    GREEN_LED_OFF = 0,
    GREEN_LED_ON,
    RED_LED_OFF,
    RED_LED_ON,
    BOTH_LED_OFF,
    BOTH_LED_ON
};

typedef NS_ENUM(NSInteger, DataType)
{
    UNKNOWN = 0,
    BARCODE,
    MSR,
    GPS,
    NFC_OLD,
    NFC_NEW,
    APPLICATION_DATA,
    KEY_EVENT
};

typedef NS_ENUM(NSInteger, NFCTag)
{
    NDEF_TYPE1 = 0,
    NDEF_TYPE2,
    RFID,
    CALYPSO,
    MIFARE_4K,
    TYPE_A,
    TYPE_B,
    FELICA,
    JEWEL,
    MIFARE_1K,
    MIFARE_UL_C,
    MIFARE_UL,
    MIFARE_DESFIRE,
    ISO15693
};

typedef NS_ENUM(NSInteger, AESBitLengths)
{
    AES_128_BITS = 0,
    AES_192_BITS,
    AES_256_BITS
};

typedef NS_ENUM(NSInteger, MSRCardType)
{
    MSR_CARD_ISO = 0,
    MSR_CARD_OTHER_1,
    MSR_CARD_AAMVA
};

typedef NS_ENUM(NSInteger, MSRDataType)
{
    MSR_DATA_PAYLOAD = 0,
    MSR_DATA_PACKET
};

typedef NS_ENUM(NSInteger, MSRDataEncryption)
{
    ENCRYPT_NONE = 0,
    ENCRYPT_AES
};

typedef NS_ENUM(NSInteger, MSRTrack)
{
    MSR_TRACK1 = 0x01,
    MSR_TRACK2 = 0x01 << 1,
    MSR_TRACK3 = 0x01 << 3
};

typedef NS_ENUM(NSInteger, MSRTrackSeparator)
{
    SEPARATOR_NONE,
    SEPARATOR_SPACE,
    SEPARATOR_COMMA,
    SEPARATOR_SEMICOLON,
    SEPARATOR_CR,
    SEPARATOR_LF,
    SEPARATOR_CRLF,
    SEPARATOR_TAB
};

typedef NS_ENUM(NSInteger, WiFiProtocol)
{
    UDP = 0,
    TCP,
    HTTP_GET,
    HTTP_POST
};

typedef NS_ENUM(NSInteger, UHFPowerLevel)
{
    UHF_LEVEL0 = 0,
    UHF_LEVEL1,
    UHF_LEVEL2,
    UHF_LEVEL3,
    UHF_LEVEL4,
    UHF_LEVEL5,
    UHF_LEVEL6,
    UHF_LEVEL7
};

#endif
