//
//  FHLooksViewController.m
//  FashionApp
//
//  Created by Dhwanil Karwa on 6/10/14.
//  Copyright (c) 2014 Dhwanil Karwa. All rights reserved.
//

#import "FHLooksViewController.h"
#import "AppDelegate.h"
#import <SVPullToRefresh.h>
#import "UIImageView+AFNetworking.h"
#import "LookCell.h"
#import "AFNetworkReachabilityManager.h"

#import "GetLooksClient.h"

#import "LookParser.h"
#import "FHUserLook.h"

NSString* const kAlertTitle = @"Network Unavailable";
NSString* const kAlertMessageCache = @"Loading Data from Cache";
NSString* const kAlertMessage  = @"Please connect to Internet";
NSString* const kCancelButtonTitle = @"Cancel";
NSString* const kOKButtonTitle = @"Ok";
NSString* const kDoneButtonTitle = @"Done";
NSString* const kLookCellIdentifier = @"LookCell";
NSString* const kLookCellNIBName = @"LookCell";
NSString* const kUserId = @"0";
NSString* const kShareText = @"Check this out!";

@interface FHLooksViewController () <NSXMLParserDelegate>

@property (nonatomic) int offset;
@property (nonatomic) int limit;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) NSArray *userLooksArray;
@property (nonatomic, strong) GetLooksClient *sharedClient;
@property (nonatomic, strong) LookParser *userLooksParser;
@property (nonatomic, copy) NSString *lookID;

@property (strong, nonatomic) UIActivityViewController *activityViewController;

@end

@implementation FHLooksViewController

//Initialize Variables
- (void)initVariables
{    
    self.userID = [NSString stringWithFormat:kUserId];
    self.offset = 1;
    self.limit = 10;
    if (!_userLooksArray) {
        _userLooksArray = [NSMutableArray new];
    }
    
    if (!_userLooksParser) {
        _userLooksParser = [LookParser new];
    }

    // Load the NIB file & register the NIB, which contains the cell
    UINib *nib = [UINib nibWithNibName:kLookCellNIBName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kLookCellIdentifier];
    
    @weakify(self)
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self callWebService];
    }];
    
    self.sharedClient = [GetLooksClient sharedClient];
    
    AFNetworkReachabilityManager *sharedManager = [AFNetworkReachabilityManager sharedManager];
    [sharedManager startMonitoring];
    
    //Add block to check for network
    @weakify(sharedManager)
    [sharedManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(sharedManager)
        [self callWebServiceWithManager:sharedManager];
    }];
    
    //Add observer to check when applciation goes to background
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(saveLooks)
                                                  name:UIApplicationDidEnterBackgroundNotification
                                                object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initVariables];
}

#pragma mark - Check Network and call webservice or load from cache

- (void)callWebServiceWithManager:(AFNetworkReachabilityManager *)sharedManager
{
    if ([sharedManager isReachable]) {
        [self callWebService];
    }
    else {
        self.userLooksArray = [self.userLooksParser fetchLooks];
        UIAlertView *alert;
        if([self.userLooksArray count] > 0) {
            alert = [[UIAlertView alloc] initWithTitle:kAlertTitle
                                                        message:kAlertMessageCache
                                                       delegate:self
                                              cancelButtonTitle:kOKButtonTitle
                                              otherButtonTitles:nil];
            [alert show];
            self.offset = [self.userLooksArray count] + 1;
            [self.tableView reloadData];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:kAlertTitle
                                               message:kAlertMessage
                                              delegate:self
                                     cancelButtonTitle:kOKButtonTitle
                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userLooksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookCell *lookCell = [tableView dequeueReusableCellWithIdentifier:kLookCellIdentifier forIndexPath:indexPath];
    
    FHUserLook *userlook = self.userLooksArray[indexPath.row];
    lookCell.look = userlook;
    
    [lookCell loadSubviewsForLook:userlook];
    lookCell.selectionStyle = UITableViewCellSelectionStyleNone;
    lookCell.actionBlock = ^(NSString *lookID){
 
        NSString *url = [kLookURL stringByAppendingString:lookID];
        NSURL *myLookURL = [NSURL URLWithString:url];
        
        NSArray *shareItems = @[kShareText,myLookURL];
        
        self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];

        [self presentViewController:self.activityViewController animated:YES completion:nil];

    };
    
    return lookCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FHUserLook *userLook = self.userLooksArray[indexPath.row];
    int productCount = [userLook.products count];
    float height = [self getHeightFromProductCount:productCount];
    return height;
}

- (float)getHeightFromProductCount:(int)count
{
    if (count <= 5) {
        return 555.0;
    } else {
        return 792.0;
    }
}

#pragma mark - Call Webservice

- (void)callWebService
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    @weakify(self)
    [self.sharedClient getLooksForUser:[self.userID integerValue]
                                offset:self.offset
                                 limit:self.limit
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                   @strongify(self)
                                   self.userLooksArray = [self.userLooksParser parseLookFrom:responseObject];
                                   [self.tableView.infiniteScrollingView stopAnimating];
                                   
                                   [self.tableView reloadData];
                                    self.offset += self.limit;
                                   
                                   
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {

                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                   [self.tableView.infiniteScrollingView stopAnimating];
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle message:kAlertMessage delegate:self cancelButtonTitle:kCancelButtonTitle otherButtonTitles:nil];
                                   [alert show];
                               }];
}

#pragma mark - Save & Load Data From Persistence Storage

- (void)saveLooks
{
    [self.userLooksParser saveUserLooks];
}

- (void)fetchLooks
{
    [self.userLooksParser fetchLooks];
}

@end
