//
//  FHLookCreator.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "FHLookCreator.h"

NSString* const kLookCreatorIDKey = @"id";
NSString* const kLookCreatorNameKey = @"name";
NSString* const kLookCreatorPicURLKey = @"pic";

@interface FHLookCreator()


@end

@implementation FHLookCreator

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (dict) {
        if (dict[kLookCreatorIDKey]) {
            _creatorID = [dict[kLookCreatorIDKey] stringValue];
        }
        if (dict[kLookCreatorNameKey]) {
            _creatorName = dict[kLookCreatorNameKey];
        }
        if (dict[kLookCreatorPicURLKey]) {
            _creatorPicURL = dict[kLookCreatorPicURLKey];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_creatorID forKey:kLookCreatorIDKey];
    [aCoder encodeObject:_creatorName forKey:kLookCreatorNameKey];
    [aCoder encodeObject:_creatorPicURL forKey:kLookCreatorPicURLKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _creatorID = [aDecoder decodeObjectForKey:kLookCreatorIDKey];
        _creatorName = [aDecoder decodeObjectForKey:kLookCreatorNameKey];
        _creatorPicURL = [aDecoder decodeObjectForKey:kLookCreatorPicURLKey];
        
    }
    
    return self;
}


@end
