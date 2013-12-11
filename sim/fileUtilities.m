//
//  fileUtilities.m
//  NeuroQ
//
//  Created by Teresa on 9/20/13.
//  Copyright (c) 2013 Queron. All rights reserved.
//

#import "fileUtilities.h"

@implementation fileUtilities

+ (NSString *) path2file : (NSString*) fileName{//use this for loading a file
    
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString * savePath;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    savePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: fileName]];
    
    
    //does the file already exist?
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:savePath];
    
    if (!fileExists){//if the file does not exist
        return nil;
    }
    
    return savePath;
    
}//end path2file

+ (NSString *) path2ReadFile : (NSString*) fileName extension:(NSString *)ext{//use this for loading a file
    
    
    // Get the path to the file
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString * readPath;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the file
    readPath = [[NSString alloc] initWithString: [[[docsDir stringByAppendingPathComponent: fileName] stringByAppendingString:@"."] stringByAppendingString:ext]];
    
    
    
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:readPath]) {
        
        //NSLog(@"Can't find file: %@",databasePath);
        
        //add to path
        NSError* err;
        NSString* resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        //NSLog(@"resourcePath is: %@", resourcePath);
        [fileManager copyItemAtPath:resourcePath toPath:readPath error:&err];
        
    }
    


    
    //does the file already exist?
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:readPath];

    if (!fileExists){//if the file does not exist
        return nil;
    }
    
    return readPath;
    
}//end path2file


+ (NSString *) path2SaveFile : (NSString*) fileName{//use this to save file (existing or not)
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString * savePath;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    savePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: fileName]];

    return savePath;
    
    
}//end path2file


+ (BOOL) save2Path : (NSMutableDictionary*) dictionary withFilePath: (NSString*) filePath
{
        

        if (filePath == nil){
            //create file
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        //write the adaptive Q-A dictionary to the file
        return [dictionary writeToFile:filePath atomically:NO];


}//end saveFile2Path


+ (NSMutableDictionary*) loadDictionaryFile : (NSString*) filePath
{
    NSMutableDictionary *infoDict;
    
    if (filePath != nil){
        infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    } else {//dictionary file doesn't exist yet
        //NSLog(@"Creating new dictionary");
        infoDict = [[NSMutableDictionary alloc] init];
    }
    
    return infoDict;
    
}//end loadAdaptive


@end
