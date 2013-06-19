//
//  kkSecondViewController.m
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "kkSecondViewController.h"
#import "Status.h"
#import "SPGetXMLData.h"
#import "SPPartition.h"
#import "SPCell.h"

@interface kkSecondViewController ()
{
	int cl, br, bu;
	BOOL loadOver;
	int pageNum;
}
@end

@implementation kkSecondViewController
@synthesize classesButton,brandButton,businessButton;
@synthesize searchTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title = NSLocalizedString(@"优惠搜索", @"优惠搜索");
		self.tabBarItem.image = [UIImage imageNamed:@"2.png"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO];
	[self.tabBarController.navigationItem setLeftBarButtonItem:nil];
	[self.tabBarController.navigationItem setRightBarButtonItem:rightItem];
	self.tabBarController.title = @"优惠搜索";
	
	//数据持久化
//	NSUserDefaults *titles = [NSUserDefaults standardUserDefaults];
//	if ([titles boolForKey:@"show"]) {
//		cl = [[titles objectForKey:@"cid"]intValue];
//		br = [[titles objectForKey:@"bid"]intValue];
//		bu = [[titles objectForKey:@"diid"]intValue];
//		
//		if ([titles objectForKey:@"c"] == nil) {
//			classesButton.titleLabel.text = @"全部分类";
//		}else{
//			classesButton.titleLabel.text = [titles objectForKey:@"c"];
//		}
//		if ([titles objectForKey:@"b"] == nil) {
//			brandButton.titleLabel.text = @"全部品牌";
//		}else{
//			brandButton.titleLabel.text = [titles objectForKey:@"b"];
//		}
//		if ([titles objectForKey:@"d"] == nil) {
//			businessButton.titleLabel.text = @"全部商圈";
//		}else{
//			businessButton.titleLabel.text = [titles objectForKey:@"d"];
//		}
		//----------------------------
		//搜索数据请求
		//----------------------------
		NSString *s = [NSString stringWithFormat:SEARCHLIST, cl, br,bu,10];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
		loadOver = NO;
		[request setDelegate:self];
		loadOver = [request didUseCachedResponse];
		[request startAsynchronous];
//	}
//	[titles setBool:NO forKey:@"show"];
}



- (void)viewDidLoad
{
	[super viewDidLoad];
	cl = br = bu = 0;
	pageNum = 10;
	//异步解析三个部分的数据
	NSThread *myThread = [[NSThread alloc] initWithTarget:self
												 selector:@selector(parser)
												   object:nil];
	[myThread start];
	//导航栏右侧button初始化
	rightItem = [[UIBarButtonItem alloc]
				 initWithTitle:@"搜索"
				 style:UIBarButtonItemStyleDone
				 target:self
				 action:@selector(rightItemClicked)];
	
	//tableview初始化
	searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 36, 320, 357)];
	searchTableView.dataSource = self;
	searchTableView.delegate = self;
	searchTableView.tag = 10;
	
	[self.view addSubview:searchTableView];
	
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

- (void)dealloc {
	[classesButton release];
	[brandButton release];
	[businessButton release];
	[rightItem release];
	[super dealloc];
}

#pragma mark - asihttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
	loadOver = YES;
	NSString *responseString = [request responseString];
	if (![responseString isEqualToString:@""]) {
		searchArray =  [[SPGetXMLData parserXML:responseString type:xHotlist]copy];
		[searchTableView reloadData];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

}

#pragma mark - 获取三大类的数据
- (void)parser
{
	NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding
	(kCFStringEncodingGB_18030_2000);
	//分类
	NSString *categoryString = [NSString stringWithContentsOfURL:
								[NSURL URLWithString:
								 [NSString stringWithFormat:@"%@%@",PARTITION,@"category"]]
														usedEncoding:&encode
														   error:nil];
	//品牌
	NSString *brandString = [NSString stringWithContentsOfURL:
								[NSURL URLWithString:
								 [NSString stringWithFormat:@"%@%@",PARTITION,@"brand"]]
														usedEncoding:&encode
														   error:nil];
	//	区域信息
	NSString *districtString = [NSString stringWithContentsOfURL:
								[NSURL URLWithString:
								 [NSString stringWithFormat:@"%@%@",PARTITION,@"district"]]
														usedEncoding:&encode
													   error:nil];
	//默认hot信息	
	NSString *hotString = [NSString stringWithContentsOfURL:
						   [NSURL URLWithString:HOTLIST]
											   usedEncoding:&encode error:nil];
	
	//调用解析xml返回数据保存到数组
	brandArray = [[NSArray alloc] initWithArray:
				  [SPGetXMLData parserXML:brandString type:xPartitionB]];
	
	categoryArray = [[NSArray alloc] initWithArray:
					 [SPGetXMLData parserXML:categoryString type:xPartitionC]];

	districtArray = [[NSArray alloc] initWithArray:
					 [SPGetXMLData parserXML:districtString type:xPartitionD]];
	
	if (![hotString isEqualToString:@""]) {
		searchArray = [[NSArray alloc] initWithArray:
					   [SPGetXMLData parserXML:hotString type:xHotlist]];
		loadOver = YES;
	}
	else{
		NSLog(@"error");
	}
}

#pragma mark - 搜索按钮
- (void)rightItemClicked
{
	if ([classesButton.titleLabel.text isEqualToString:@"全部分类"]) {
		cl = 0;
	}
	if ([brandButton.titleLabel.text isEqualToString:@"全部品牌"]) {
		br = 0;
	}
	if ([businessButton.titleLabel.text isEqualToString:@"全部商圈"]) {
		bu = 0;
	}
	
	NSString *tableDataString = [NSString stringWithFormat:SEARCHLIST,cl,br,bu,100];
	
	if (loadOver ) {
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:
								   [NSURL URLWithString:tableDataString]];
		loadOver = [request didUseCachedResponse];
		[request setDelegate:self];
		
		[request startAsynchronous];
	}
	
}

#pragma mark - 三个按钮绑定同一个点击事件

- (IBAction)click:(id)sender {
	if (sender == classesButton) {
		//实例化tableviewContrtoller对象
		UITableViewController *controller = [[UITableViewController alloc] init];
		controller.tableView.delegate = self;
		controller.tableView.dataSource = self;
		controller.tableView.tag = 1;
		//实例化popover视图对象
		popover = [[FPPopoverController alloc] initWithViewController:controller];
		[controller release];
		
		popover.tint = FPPopoverLightGrayTint;
		popover.arrowDirection = FPPopoverArrowDirectionAny;
		popover.contentSize = CGSizeMake(150, 350);

		[popover presentPopoverFromView:classesButton];
		[classesButton release];
	}
	if (sender == brandButton) {
		UITableViewController *controller = [[UITableViewController alloc] init];
		controller.tableView.delegate = self;
		controller.tableView.dataSource = self;
		controller.tableView.tag = 2;
		//实例化popover视图对象
		popover = [[FPPopoverController alloc] initWithViewController:controller];
		[controller release];
		
		popover.tint = FPPopoverLightGrayTint;
		popover.arrowDirection = FPPopoverArrowDirectionAny;
		popover.contentSize = CGSizeMake(150, 350);
		[popover presentPopoverFromView:brandButton];
		[brandButton release];
	}
	if (sender == businessButton) {
		UITableViewController *controller = [[UITableViewController alloc] init];
		controller.tableView.delegate = self;
		controller.tableView.dataSource = self;
		controller.tableView.tag = 3;
		//实例化popover视图对象
		popover = [[FPPopoverController alloc] initWithViewController:controller];
		[controller release];
		
		popover.tint = FPPopoverLightGrayTint;
		popover.arrowDirection = FPPopoverArrowDirectionAny;
		popover.contentSize = CGSizeMake(150, 350);
		[popover presentPopoverFromView:businessButton];
		[businessButton release];
	}
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int i = 0;
	if (tableView.tag == 1) {
		return [categoryArray count];
	}
	if (tableView.tag == 2) {
		return [brandArray count];
	}
	if (tableView.tag == 3) {

		return [districtArray count];
	}
	if (tableView.tag == 10) {
		return [searchArray count];
	}
	return i;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.tag == 10) {
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
		
		SPHotData *h = [searchArray objectAtIndex:indexPath.row];
		[cell setHotData:h];
		
		//异步加载图片
		NSString *imageUrl = [NSString stringWithFormat:@"%@%@",GETIMAGE, h.s_icon];
		imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
		image.url = [NSURL URLWithString:imageUrl];
		[objManager manage:image];
		
		return cell;
	}
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
	SPPartition *data = nil;
	switch (tableView.tag) {
		case 1:
			data = [categoryArray objectAtIndex:indexPath.row];
			cell.textLabel.text = data.s_caption;
			break;
		case 2:
			data = [brandArray objectAtIndex:indexPath.row];
			cell.textLabel.text = data.s_caption;
			break;
		case 3:
			data = [districtArray objectAtIndex:indexPath.row];
			cell.textLabel.text = data.s_caption;
			break;
//		case 10:
//			data = [districtArray objectAtIndex:indexPath.row];
//			cell.textLabel.text = data.s_caption;
		default:
			break;
	}
	return cell;
	
}

 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[popover dismissPopoverAnimated:YES];
	SPPartition *data = nil;
	if (tableView.tag == 1) {
		data = [categoryArray objectAtIndex:indexPath.row];
		self.classesButton.titleLabel.text = data.s_caption;
		cl = [data.s_id intValue] + 1;
	}
	if (tableView.tag == 2) {
		data = [brandArray objectAtIndex:indexPath.row];
		self.brandButton.titleLabel.text = data.s_caption;
		br = [data.s_id intValue] + 1;
	}
	if (tableView.tag == 3) {
		data = [districtArray objectAtIndex:indexPath.row];
		self.businessButton.titleLabel.text = data.s_caption;
		bu = [data.s_id intValue] + 1;
	}
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.tag == 10) {
		return 70;
	}
	return 45;
}

@end
