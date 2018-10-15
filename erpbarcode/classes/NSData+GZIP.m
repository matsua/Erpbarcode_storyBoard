//
//  NSData+GZIP.m
//
//  Version 1.0
//
//  Created by Nick Lockwood on 03/06/2012.
//  Copyright (C) 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/Gzip
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import "NSData+GZIP.h"
#import <zlib.h>


#define CHUNK_SIZE 16384


@implementation NSData (GZIP)

- (NSData *)gzippedDataWithCompressionLevel:(float)level
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)roundf(level * 9);
        //if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:CHUNK_SIZE];
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += CHUNK_SIZE;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
}

- (NSData *)gzippedData
{
    return [self gzippedDataWithCompressionLevel:-1.0f]; //default 0.7
    
}

- (NSData *)gunzippedData
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *data = [NSMutableData dataWithLength: [self length] * 1.5];
        //if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            while (status == Z_OK)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += [self length] * 0.5;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    data.length = stream.total_out;
                    return data;
                }
            }
        }
    }
    return nil;
}

- (NSData *)zlibInflate
{
    if ([self length] == 0) return self;
    
    unsigned full_length = [self length];
    unsigned half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = [self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit (&strm) != Z_OK) return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)zlibDeflate
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = [self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chuncks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = [compressed length] - strm.total_out;
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData: compressed];
}

- (NSData *)gzipInflate
{
    if ([self length] == 0) return self;
    
    unsigned full_length = [self length];
    unsigned half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = [self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)gzipDeflate
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = [self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = [compressed length] - strm.total_out;
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}
@end
