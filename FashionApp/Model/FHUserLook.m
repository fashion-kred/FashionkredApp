//
//  FHUserLook.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "FHUserLook.h"
#import "FHLookCreator.h"
#import "FHProduct.h"

NSString* const kUserLookIDKey = @"id";
NSString* const kUserLookProductsKey  = @"products";
NSString* const kUserLookUpVoteKey = @"upVote";
NSString* const kUserLookRestyleCountKey = @"restyleCount";
NSString* const kUserLookLovedKey = @"isLoved";
NSString* const kUserLookRestyledKey = @"isReStyled";
NSString* const kUserLookCreatorKey = @"creator";
NSString* const kUserLookTagKey = @"tags";

@implementation FHUserLook

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _products = [[NSMutableArray alloc] init];
    _lookTags = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_lookID forKey:kUserLookIDKey];
    [aCoder encodeInt:_upVote forKey:kUserLookUpVoteKey];
    [aCoder encodeInt:_restyleCount forKey:kUserLookRestyleCountKey];
    [aCoder encodeBool:_loved forKey:kUserLookLovedKey];
    [aCoder encodeBool:_reStyled forKey:kUserLookRestyledKey];
    [aCoder encodeObject:_lookTags forKey:kUserLookTagKey];
    [aCoder encodeObject:_products forKey:kUserLookProductsKey];
    [aCoder encodeObject:_creator forKey:kUserLookCreatorKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _lookID = [aDecoder decodeObjectForKey:kUserLookIDKey];
        _upVote = [aDecoder decodeIntForKey:kUserLookUpVoteKey];
        _restyleCount = [aDecoder decodeIntForKey:kUserLookRestyleCountKey];
        _loved = [aDecoder decodeBoolForKey:kUserLookLovedKey];
        _reStyled = [aDecoder decodeBoolForKey:kUserLookRestyledKey];
        _lookTags = [aDecoder decodeObjectForKey:kUserLookTagKey];
        _products = [aDecoder decodeObjectForKey:kUserLookProductsKey];
        _creator = [aDecoder decodeObjectForKey:kUserLookCreatorKey];
    }
    
    return self;
}

@end
