//
//  fileUtilities.h
//  NeuroQ
//
//  Created by Teresa on 9/20/13.
//  Copyright (c) 2013 Queron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fileUtilities : NSObject

+ (NSString *) path2file : (NSString *) fileName;
+ (NSString *) path2SaveFile : (NSString*) fileName;
+ (BOOL) save2Path : (NSMutableDictionary*) dictionary withFilePath: (NSString*) filePath;
+ (NSString *) path2ReadFile : (NSString*) fileName extension: (NSString*) ext;
+ (NSMutableDictionary*) loadDictionaryFile : (NSString*) withPath;

@end
