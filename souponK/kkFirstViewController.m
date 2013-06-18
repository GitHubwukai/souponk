//
//  kkFirstViewController.m
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "kkFirstViewController.h"
#import "Status.h"
#import "SPGetXMLData.h"
#import "SPCityData.h"
#import "SPHotData.h"
#import "SPCell.h"

@interface kkFirstViewController ()
{
	int cityNum;
	BOOL loadOver;
}
@end

@implementation kkFirstViewController
@synthesize controller;
@synthesize hotTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title = NSLocalizedString(@"热门优惠", @"热门优惠");
		self.tabBarItem.image = [UIImage imageNamed:@"1.png"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO];
	[self.tabBarController.navigationItem setRightBarButtonItem:nil];
	[self.tabBarController.navigationItem setLeftBarButtonItem:leftItem];
	self.tabBarController.title = @"环旗优惠";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	//对接口返回数据进行转码
	NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	
	//---------------------------------------
	//广告图像获取
	//---------------------------------------
	//初始化异步加载图片
	manager = [SDWebImageManager sharedManager];
	//解析广告数据
	NSString *adsString = [NSString stringWithContentsOfURL:
						   [NSURL URLWithString:ADS]
											   usedEncoding:&encode
													  error:nil];
	adsArray = [[NSArray alloc] initWithArray:
				[SPGetXMLData parserXML:adsString type:xAds]];
	
	//---------------------------------------
	//创建滚动视图
	//---------------------------------------
	pagePhotosView = [[PagePhotosView alloc]
					  initWithFrame:CGRectMake(0, 0, 320, 110)
					  withDataSource:self];
	[self.view addSubview:pagePhotosView];
	[pagePhotosView release];
	
	//---------------------------------------
	//获取城市
	//---------------------------------------
	//返回保存城市名称的数组
	NSString *citysString = [NSString stringWithContentsOfURL:
							 [NSURL URLWithString:GETCITYS]
												 usedEncoding:&encode
														error:nil];
	
	cityArray = [[NSArray alloc]initWithArray:
	[SPGetXMLData  parserXML:citysString type:xGetcitys]];
	SPCityData *b = [cityArray objectAtIndex:0];
	leftItem = [[UIBarButtonItem alloc] initWithTitle:b.s_cityCaption
												style:UIBarButtonItemStyleBordered
											   target:self
											   action:@selector(leftItemClicked:)];
	//---------------------------------------
	//asihttp获取人气城市团购数据
	//---------------------------------------
	NSURL *hotCityUrl = [NSURL URLWithString:[NSString
												 stringWithFormat:
												 HOTLISTBYCITY,
												 b.s_cityID,
												 10]];	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:hotCityUrl];
	loadOver = NO;
	[request setDelegate:self];
	loadOver = [request didUseCachedResponse];
	request.downloadProgressDelegate = self;
	[request startAsynchronous];
	
	//---------------------------------------
	//获取结束，解析在获取之后进行
	//初始化tableview
	//---------------------------------------
	hotTableView = [[UITableView alloc]
					initWithFrame:CGRectMake(0, 110, 320, 258)];
	hotTableView.delegate = self;
	hotTableView.dataSource = self;
	hotTableView.tag = 10;
	
	[self.view addSubview:hotTableView];
	
	//---------------------------------------
	//tableviewcell图片异步加载
	//---------------------------------------
	objManager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
	NSString* cacheDirectory = [NSHomeDirectory()
								stringByAppendingString:@"/Library/Caches/imgcache/flickr/"];
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc]
								 initWithRootPath:cacheDirectory] autorelease];
	objManager.fileCache = fileCache;
	// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
	[fileCache trimCacheUsingBackgroundThread];
}

#pragma mark -
#pragma mark -PagePhotoSDataSource

- (int)numberOfPages
{
	return [adsArray count];
}

- (UIImage *)imageAtIndex:(int)index
{
	SPAdsData *ad = [adsArray objectAtIndex:index];
	NSString *urlString = [NSString stringWithFormat:@"%@%@",GETIMAGE, ad.s_adName];
	
	UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:urlString]];
	//将需要缓存的图片加载进来
	if (cachedImage) {
		return cachedImage;
	}
	else{
		[manager downloadWithURL:[NSURL URLWithString:urlString] delegate:self];
		return cachedImage;
	}
	return cachedImage;
}

#pragma mark -
#pragma mark -导航栏左侧按钮点击事件

- (IBAction)leftItemClicked:(id)sender
{
	controller = [[UITableViewController alloc] init];
	controller.tableView.delegate = self;
	controller.tableView.dataSource = self;
	controller.tableView.tag = 12;

	//初始化弹出视图
	popover = [[FPPopoverController alloc]initWithViewController:controller];
	[controller release];
	
	popover.tint = FPPopoverLightGrayTint;
	popover.arrowDirection = FPPopoverArrowDirectionAny;
	popover.contentSize = CGSizeMake(120, 350);
	UIView *i = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 40, 55)];
	[popover presentPopoverFromView:i];
	[i release];
}

#pragma mark -
#pragma mark -弹出视图的delegate

//设置视图的消失
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
		  shouldDismissVisiblePopover:(FPPopoverController *)visiblePopoverController
{
	[visiblePopoverController dismissPopoverAnimated:YES];
	[visiblePopoverController autorelease];
}


#pragma mark -
#pragma mark -获取人气城市信息后进行解析

- (void)requestFinished:(ASIHTTPRequest *)request
{
	loadOver = YES;
	//获取应答数据
	NSString *responseString = [request responseString];
	//数据获取成功
	if (![responseString isEqualToString:@""]) {
		hotArray = [[NSMutableArray alloc]initWithArray:
					[SPGetXMLData parserXML:responseString type:xHotlist]];
		
		[hotTableView reloadData];
	}
	//解析成功，默认返回10条数据
}
//获取失败alert提示
-(void)requestFailed:(ASIHTTPRequest
					  *)request{
	loadOver = YES;
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"获取数据失败，请稍后重试。"
						  message:nil
						  delegate:nil
						  cancelButtonTitle:@"知道了"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark -sdImageManagerDelegate
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image{
	
}


#pragma mark -
#pragma mark -tableviewdelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//选择城市后刷新tableview数据
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (tableView.tag == 12) {
		SPCityData *city = [cityArray objectAtIndex:indexPath.row];
		leftItem.title = city.s_cityCaption;
		
		[popover dismissPopoverAnimated:YES];
		
		NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
		
		NSString *s = [NSString stringWithFormat:HOTLISTBYCITY, city.s_cityID,10];
		NSString *hotString = [NSString stringWithContentsOfURL:
							   [NSURL URLWithString:s] usedEncoding:&encode  error:nil];
		
		hotArray = [[NSMutableArray alloc]initWithArray:
					[SPGetXMLData parserXML:hotString type:xHotlist]];
		
		[hotTableView reloadData];

	}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	if (tableView.tag == 12)
	{
		return [cityArray count];
	}
	return [hotArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//弹出视图的cell
	if (tableView.tag == 12) {
		UITableViewCell *cell = [[[UITableViewCell alloc]
								  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		SPCityData *b = [cityArray objectAtIndex:indexPath.row];
		cell.textLabel.text = b.s_cityCaption;
		return cell;
	}
	//人气城市团购的cell
	
	HJManagedImageV *image;
	static NSString *cellIdentifier = @"CEllIdentifier";
	SPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];	
	if (cell == nil) {
		cell = [[SPCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		image = [[[HJManagedImageV alloc]initWithFrame:CGRectMake(1, -1, 65, 70)]autorelease];
		image.tag = 666;
		[cell addSubview:image];
	}
	else
		{
		//image的重用
		image = (HJManagedImageV *)[cell viewWithTag:666];
		[image clear];
		}

	SPHotData *h = [hotArray objectAtIndex:indexPath.row];
	[cell setHotData:h];
	
	//异步加载图片
	NSString *imageUrl = [NSString stringWithFormat:@"%@%@",GETIMAGE, h.s_icon];
	imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
	image.url = [NSURL URLWithString:imageUrl];
	[objManager manage:image];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.tag == 12) {
		return 45;
	}
	return 70;
}


@end
