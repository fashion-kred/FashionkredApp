//
//  LookParser.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "LookParser.h"
#import "FHUserLook.h"
#import "FHLookCreator.h"
#import "FHLookTag.h"
#import "FHProduct.h"

@implementation LookParser

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lookArray = [NSMutableArray new];
    return self;
}

- (NSArray *)parseLookFrom:(NSDictionary *)jsonData
{
    NSArray *arrayData = jsonData[@"d"];
    
    for (NSDictionary *dictLook in arrayData) {
        FHUserLook *userLook = [FHUserLook new];
        
        if (dictLook[kUserLookIDKey]) {
            userLook.lookID = [dictLook[kUserLookIDKey] stringValue];
        }
        
        if (dictLook[kUserLookProductsKey]) {
            for (NSDictionary *productDict in dictLook[kUserLookProductsKey]) {
                
                FHProduct *product = [[FHProduct alloc] initWithDictionary:productDict];
                [userLook.products addObject:product];
            }
        }
        
        if (dictLook[kUserLookUpVoteKey]) {
            userLook.upVote = [dictLook[kUserLookUpVoteKey] intValue];
        }
                
        if (dictLook[kUserLookRestyleCountKey]) {
            userLook.restyleCount = [dictLook[kUserLookRestyleCountKey] intValue];
        }
        
        userLook.loved = [dictLook[kUserLookLovedKey] boolValue];
        userLook.reStyled = [dictLook[kUserLookRestyledKey] boolValue];

        if (dictLook[kUserLookCreatorKey]) {
            FHLookCreator *creator =  [[FHLookCreator alloc] initWithDictionary:dictLook[kUserLookCreatorKey]];
            userLook.creator = creator;
        }
        
        if (dictLook[kUserLookTagKey]) {
            
            NSArray *tags = dictLook[kUserLookTagKey];
            for (NSDictionary *individualTag in tags) {
                
                FHLookTag *tag = [[FHLookTag alloc] initWithDictionary:individualTag];
                [userLook.lookTags addObject:tag];
            }
        }
        
        [self.lookArray addObject:userLook];
    }
    
    return self.lookArray;
}

#pragma mark - Archive Unarchieve Data

- (void)saveUserLooks
{
    NSString *fileName = [NSHomeDirectory() stringByAppendingString:@"/Documents/looks.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_lookArray];
    [data writeToFile:fileName atomically:YES];
}

- (NSMutableArray *)fetchLooks
{
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/looks.bin"]];
    if (data) {
        NSMutableArray *mutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.lookArray = [NSMutableArray arrayWithArray:mutableArray];
        return self.lookArray;
    } else {
        return nil;
    }
}


@end
