//
//  Session.m
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "Session.h"

@implementation Session
static Session *shareInstance = nil;

+(Session *)sharedInstance
{
    if (!shareInstance)
    {
        shareInstance = [[Session alloc] init];
        shareInstance.user = [[User alloc] init];
        
//        shareInstance.shopCars = [[ShopCars alloc] init];
        
        shareInstance.shopCarss = [NSMutableArray array];
        
        shareInstance.order = [[Order alloc] init];
        shareInstance.assress = [[Address alloc] init];
        
        shareInstance.details = [[Details alloc] init];
        shareInstance.details_imagesList = [NSMutableArray array];
        shareInstance.details_typeListA = [NSMutableArray array];
        shareInstance.details_typeListB = [NSMutableArray array];
        shareInstance.details_typeListC = [NSMutableArray array];
        shareInstance.details_typeListB_attrId = [NSMutableArray array];
        shareInstance.details_typeListC_attrId = [NSMutableArray array];
        shareInstance.details_typeListB_attrPrice = [NSMutableArray array];
        shareInstance.details_typeListC_attrPrice = [NSMutableArray array];
        shareInstance.details_typeListD = [NSMutableArray array];
        shareInstance.details_typeListD_attrId = [NSMutableArray array];
        shareInstance.details_typeListD_attrPrice = [NSMutableArray array];
 
        shareInstance.orderList = [NSMutableArray array];
        shareInstance.assressList = [NSMutableArray array];
        
        shareInstance.homeAGoodsId = [NSMutableArray array];
        shareInstance.homeAGoodsImage = [NSMutableArray array];
        shareInstance.homeAGoodsName = [NSMutableArray array];
        shareInstance.homeAGoodsSn = [NSMutableArray array];
        shareInstance.homeAGoodsPrice = [NSMutableArray array];
        
        shareInstance.homeBCell_id = [NSMutableArray array];
        shareInstance.homeBCell_name = [NSMutableArray array];
        shareInstance.homeBCell_image = [NSMutableArray array];
        shareInstance.homeBCell_price = [NSMutableArray array];
        shareInstance.homeBCell_sn = [NSMutableArray array];
        
        shareInstance.homeCCell_id = [NSMutableArray array];
        shareInstance.homeCCell_name = [NSMutableArray array];
        shareInstance.homeCCell_image = [NSMutableArray array];
        shareInstance.homeCCell_price = [NSMutableArray array];
        shareInstance.homeCCell_sn = [NSMutableArray array];
        
        shareInstance.tierAList = [NSMutableArray array];
        shareInstance.tierBList = [NSMutableArray array];
        shareInstance.tierCList = [NSMutableArray array];
        
        shareInstance.tierAList_name = [NSMutableArray array];
        shareInstance.tierAList_cat_id = [NSMutableArray array];
        shareInstance.tierAList_parent_id = [NSMutableArray array];
        
        shareInstance.tierBList_cat_id = [NSMutableArray array];
        shareInstance.tierBList_parent_id = [NSMutableArray array];
        
        shareInstance.tierCList_catId = [NSMutableArray array];
        shareInstance.tierCList_parentId = [NSMutableArray array];
        shareInstance.tierCList_Id = [NSMutableArray array];
        shareInstance.tierCList_Image = [NSMutableArray array];
        shareInstance.tierCList_Price = [NSMutableArray array];
        shareInstance.tierCList_Name = [NSMutableArray array];
        shareInstance.tierCList_Sn = [NSMutableArray array];
    }
    return shareInstance;
}
@end
