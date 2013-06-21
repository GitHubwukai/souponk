//
//  kkThirdViewController.h
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPGetXMLData.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"
#import "SPCell.h"
#import "ASIHTTPRequest.h"
#import <CoreLocation/CoreLocation.h>

@interface kkThirdViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,
CLLocationManagerDelegate,UIAlertViewDelegate,
ASIHTTPRequestDelegate>

{
	NSArray *aroundArray;
	HJObjManager *objManager;
	double lon;
	double lat;
	NSString *locUrlString;
	//地理位置
	CLLocationManager *locManager;
}

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UIAlertView *alertView;
@end
