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



@interface kkFirstViewController : UIViewController <PagePhotosDataSource, SDWebImageManagerDelegate, UITableViewDataSource, UITableViewDelegate, FPPopoverControllerDelegate>
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
	
}

@property (nonatomic, strong) UITableViewController *controller;

- (IBAction)leftItemClicked:(id)sender;
@end
