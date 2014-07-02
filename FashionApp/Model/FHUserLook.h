//
//  FHUserLook.h
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FHLookCreator;

extern NSString* const kUserLookIDKey;
extern NSString* const kUserLookProductsKey;
extern NSString* const kUserLookUpVoteKey;
extern NSString* const kUserLookDownVoteKey;
extern NSString* const kUserLookRestyleCountKey;
extern NSString* const kUserLookLovedKey;
extern NSString* const kUserLookRestyledKey;
extern NSString* const kUserLookCreatorKey;
extern NSString* const kUserLookTagKey;

@interface FHUserLook : NSObject <NSCoding>

@property (nonatomic, copy) NSString *lookID;
@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic) int upVote;

@property (nonatomic, strong) FHLookCreator *creator;
@property (nonatomic, strong) NSMutableArray *lookTags;

@property (nonatomic) int viewCount;

@property (nonatomic, getter = isLoved) BOOL loved;
@property (nonatomic, getter = isReStyled) BOOL reStyled;

@property (nonatomic) int restyleCount;

@end
