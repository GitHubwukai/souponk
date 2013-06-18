//
//  kkFirstViewController.h
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosView.h"
#import "SPAdsData.h"
#import "SDWebImageManager.h"
#import "SPGetAds.h"
#import "FPPopoverController.h"
#import "HJManagedImageV.h"
#import "HJObjManager.h"
#import "ASIHTTPRequest.h"
#import "PullToRefreshTableView.h"


@interface kkFirstViewController : UIViewController <PagePhotosDataSource,
SDWebImageManagerDelegate,UITableViewDataSource, UITableViewDelegate,
FPPopoverControllerDelegate, ASIHTTPRequestDelegate, ASIProgressDelegate>
{
	//图片下载管理
	SDWebImageManager *manager;
	//保存广告图片信息
	NSArray *adsArray;
	//滑动切换视图
	PagePhotosView *pagePhotosView;
	//导航栏左侧按钮
	UIBarButtonItem *leftItem;
	//城市信息
	NSArray *cityArray;
	//导航按钮弹出视图
	FPPopoverController *popover;
	//tableViewCell图片异步加载
	HJObjManager *objManager;
	//人气城市数据
	NSMutableArray *hotArray;
	
}

@property (nonatomic, strong) UITableViewController *controller;
@property (nonatomic, strong) UITableView *hotTableView;
- (IBAction)leftItemClicked:(id)sender;
@end
