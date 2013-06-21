//
//  kkThirdViewController.m
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "kkThirdViewController.h"
#import "Status.h"
#import <QuartzCore/QuartzCore.h>

@interface kkThirdViewController ()
{
	BOOL loadOver;
}
@end

@implementation kkThirdViewController
@synthesize tableView;
@synthesize alertView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title = NSLocalizedString(@"周边优惠", @"周边优惠");
		self.tabBarItem.image = [UIImage imageNamed:@"3.png"];
		
    }
	//生成默认的数据请求string
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:
							   [NSURL URLWithString:[NSString stringWithFormat:
													 NEARBY, 121.29, 31.11, 15]]];
	loadOver = NO;
	loadOver = [request didUseCachedResponse];
	//默认经度纬度
	lon = 121.29;
	lat = 31.11;
	
	[request setDelegate:self];
	[request startAsynchronous];
	
	//获取一下默认的url
	NSString *string = [NSString stringWithFormat:NEARBY, 121.29, 31.11, 15];
	NSLog(@"%@", string);
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[self.navigationController setNavigationBarHidden:NO];
	[self.tabBarController.navigationItem setLeftBarButtonItem:nil];
	[self.tabBarController.navigationItem setRightBarButtonItem:nil];
	self.tabBarController.navigationController.title = @"周边优惠";
	self.tabBarController.title = @"周边优惠";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	//初始化地理位置服务
	locManager = [[CLLocationManager alloc] init];
	[locManager setDelegate:self];
	[locManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[locManager startUpdatingLocation];
	
	//初始化uialertView对象
	self.alertView.frame = CGRectMake(25, 80, 270, 182);
	self.alertView.layer.borderWidth = 5.0f;
	self.alertView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
	self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
	
	//初始化图片异步加载对象
	objManager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/flickr/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	objManager.fileCache = fileCache;
	
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7;
	[fileCache trimCacheUsingBackgroundThread];
	
	//初始化tableview对象
	tableView = [[UITableView alloc] initWithFrame:
				 CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	[tableView release];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[locManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -asihttp的delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
	loadOver = YES;
	NSString *responseString = [request responseString];
	if (![responseString isEqualToString:@""]) {
		aroundArray = [[SPGetXMLData parserXML:responseString type:xSearcharound]copy];
		[tableView reloadData];
	}else{
		NSLog(@"error");
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	
}

#pragma mark -地理位置服务的delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	CLLocationCoordinate2D loc = [newLocation coordinate];
	//获取新的经纬度
	lat = loc.latitude;
	lon = loc.longitude;
	locUrlString = [NSString stringWithFormat:NEARBY,lon, lat,10];
	if (loadOver) {
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:
								   [NSURL URLWithString:locUrlString]];
		loadOver = [request didUseCachedResponse];
		[request setDelegate:self];
		
		[request startAsynchronous];
	}
	
	[manager stopUpdatingLocation];
	NSLog(@"所在位置的经度和纬度为%f, %f", lat, lon);
}

#pragma mark -tableView的delegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [aroundArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HJManagedImageV *hjmImage;
	SPCell *cell = (SPCell *)[tableView dequeueReusableCellWithIdentifier:@"SPCell"];
	if (!cell) {
		cell = [[[SPCell alloc] initWithStyle:UITableViewCellStyleDefault
							  reuseIdentifier:@"SPCell"]autorelease];
		hjmImage = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(2, 1, 65, 70)] autorelease];
		hjmImage.tag = 111;
		
		[cell addSubview:hjmImage];
	}else{
		hjmImage = (HJManagedImageV *)[cell viewWithTag:111];
		//实现cell设置数据的方法
		//待实现
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 75;
}

@end
