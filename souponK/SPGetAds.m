//
//  SPGetAds.m
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "SPGetAds.h"
#import "Status.h"
#import "SPAdsData.h"

@implementation SPGetAds
@synthesize xmlDataArray;


- (id)init
{
    self = [super init];
    if (self) {
		xmlDataArray = [[NSMutableArray alloc] initWithCapacity:0];
		//广告图片的信息api
		NSData *xmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ADS]];
		//创建解析
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
		[parser setShouldProcessNamespaces:NO];
		[parser setShouldReportNamespacePrefixes:NO];
		[parser setShouldResolveExternalEntities:NO];
		[parser setDelegate:self];
		
		[parser parse];
    }
    return self;
}


//解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	//结果保存到数组
	if ([elementName isEqualToString:@"ad"]) {
		
		SPAdsData *data = [[SPAdsData alloc] init];
		data.s_adID = [attributeDict objectForKey:@"id"];
		data.s_adName = [attributeDict objectForKey:@"poster"];
		data.s_adURL = [attributeDict objectForKey:@"url"];
		
		[[self xmlDataArray] addObject:data];
		[data release];
	}
}

////解析节点值
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
//{
//	
//}
////解析结束
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
//{
//	
//}
@end
