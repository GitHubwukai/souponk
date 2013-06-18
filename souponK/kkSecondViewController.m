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

@interface kkSecondViewController ()
{
	int cl, br, bu;
	BOOL loadOver;
	int pageNum;
}
@end

@implementation kkSecondViewController
@synthesize classesButton,brandButton,businessButton;

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
	
	NSUserDefaults *titles = [NSUserDefaults standardUserDefaults];
	if ([titles boolForKey:@"show"]) {
		cl = [[titles objectForKey:@"cid"]intValue];
		br = [[titles objectForKey:@"bid"]intValue];
		bu = [[titles objectForKey:@"diid"]intValue];
		
		if ([titles objectForKey:@"c"] == nil) {
			classesButton.titleLabel.text = @"全部分类";
		}else{
			classesButton.titleLabel.text = [titles objectForKey:@"c"];
		}
		if ([titles objectForKey:@"b"] == nil) {
			brandButton.titleLabel.text = @"全部品牌";
		}else{
			brandButton.titleLabel.text = [titles objectForKey:@"b"];
		}
		if ([titles objectForKey:@"d"] == nil) {
			businessButton.titleLabel.text = @"全部商圈";
		}else{
			businessButton.titleLabel.text = [titles objectForKey:@"d"];
		}
		//----------------------------
		//搜索数据请求
		//----------------------------
		NSString *s = [NSString stringWithFormat:SEARCHLIST, cl, br,bu,10];
		NSLog(@"%@",s);
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
		loadOver = NO;
		[request setDelegate:self];
		loadOver = [request didUseCachedResponse];
		[request startAsynchronous];
	}
	[titles setBool:NO forKey:@"show"];
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
}

- (void)dealloc {
	[classesButton release];
	[brandButton release];
	[businessButton release];
	[rightItem release];
	[super dealloc];
}

#pragma mark
#pragma mark -获取三大类的数据
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

	//调用解析xml返回数据保存到数组
	brandArray = [[NSArray alloc] initWithArray:
				  [SPGetXMLData parserXML:brandString type:xPartitionB]];
	
	categoryArray = [[NSArray alloc] initWithArray:
					 [SPGetXMLData parserXML:categoryString type:xPartitionC]];

	districtArray = [[NSArray alloc] initWithArray:
					 [SPGetXMLData parserXML:districtString type:xPartitionD]];

}

#pragma mark -搜索按钮
- (void)rightItemClicked
{
	
}

#pragma mark -三个按钮绑定同一个点击事件

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

#pragma mark -tableViewDelegate
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
	return i;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
			
		default:
			break;
	}
	return cell;
	
}

 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[popover dismissPopoverAnimated:YES];
}
@end
