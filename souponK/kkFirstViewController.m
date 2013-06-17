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

@interface kkFirstViewController ()
{
	int cityNum;
	BOOL loadOver;
}
@end

@implementation kkFirstViewController
@synthesize controller;

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
	
	//广告图像获取
	manager = [SDWebImageManager sharedManager];
	//通过SPGetAds解析xml返回结果
	SPGetAds *spgetAds = [[SPGetAds alloc] init];
	adsArray = spgetAds.xmlDataArray;
	
	//创建滚动视图
	pagePhotosView = [[PagePhotosView alloc]
					  initWithFrame:CGRectMake(0, 0, 320, 130)
					  withDataSource:self];
	[self.view addSubview:pagePhotosView];
	[pagePhotosView release];
	
	//获取城市
	NSString *citysString = [NSString stringWithContentsOfURL:
							 [NSURL URLWithString:GETCITYS]
												 usedEncoding:&encode
														error:nil];
	
	cityArray = [[NSArray alloc]initWithArray:
	[SPGetXMLData  parserXML:citysString type:xGetcitys]];
	//button标题默认为第一个城市
	NSLog(@"cityarray count is %d", [cityArray count]);
	NSLog(@"%@", cityArray);
	SPCityData *b = [cityArray objectAtIndex:0];
	leftItem = [[UIBarButtonItem alloc] initWithTitle:b.s_cityCaption
												style:UIBarButtonItemStyleBordered
											   target:self
											   action:@selector(leftItemClicked:)];

}

//PagePhotoSDataSource
- (int)numberOfPages
{
	return [adsArray count];
}

- (UIImage *)imageAtIndex:(int)index
{
	SPAdsData *ad = [adsArray objectAtIndex:index];
	NSString *urlString = [NSString stringWithFormat:@"%@%@",GETIMAGE, ad.s_adName];
	//NSLog(@"%@", urlString);
	
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

//导航栏左侧按钮点击事件
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

//弹出视图的delegate
//设置视图的消失
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController shouldDismissVisiblePopover:(FPPopoverController *)visiblePopoverController
{
	[visiblePopoverController dismissPopoverAnimated:YES];
	[visiblePopoverController autorelease];
}




//tableviewdelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	if (tableView.tag == 12)
	{
		return [cityArray count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
		UITableViewCell *cell = [[[UITableViewCell alloc]
								  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		SPCityData *b = [cityArray objectAtIndex:indexPath.row];
		cell.textLabel.text = b.s_cityCaption;
	
		return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}


@end
