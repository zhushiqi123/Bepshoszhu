//
//  Session.h
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "HomeAGoods.h"
#import "Address.h"
#import "Order.h"
//#import "ShopCars.h"
#import "Details.h"

@interface Session : NSObject

//用户数据
@property(nonatomic,retain) User *user;

//购物车数据
//@property(nonatomic,retain) ShopCars *shopCars;

//购物车数据
@property(nonatomic,retain) NSMutableArray *shopCarss;

//详情页面name
@property(nonatomic,retain) NSString *details_name;

//详情页面网页
@property(nonatomic,retain) NSString *goods_content;

//详情页面数据
@property(nonatomic,retain) Details *details;

//详情页面照片
@property(nonatomic,retain) NSMutableArray *details_imagesList;

//详情价格ACell_price
@property(nonatomic,retain) NSString *homeACell_price;

//详情属性A
@property(nonatomic,retain) NSMutableArray *details_typeListA;
//详情属性B
@property(nonatomic,retain) NSMutableArray *details_typeListB;
//详情属性C
@property(nonatomic,retain) NSMutableArray *details_typeListC;
//详情属性D
@property(nonatomic,retain) NSMutableArray *details_typeListD;

//详情属性B_attrId
@property(nonatomic,retain) NSMutableArray *details_typeListB_attrId;
//详情属性C_attrId
@property(nonatomic,retain) NSMutableArray *details_typeListC_attrId;
//详情属性C_attrId
@property(nonatomic,retain) NSMutableArray *details_typeListD_attrId;

//详情属性B_attrPrice
@property(nonatomic,retain) NSMutableArray *details_typeListB_attrPrice;
//详情属性C_attrPrice
@property(nonatomic,retain) NSMutableArray *details_typeListC_attrPrice;
//详情属性C_attrPrice
@property(nonatomic,retain) NSMutableArray *details_typeListD_attrPrice;

//详情属性B编号
@property(nonatomic,assign) int details_typeListB_num;
//详情属性C编号
@property(nonatomic,assign) int details_typeListC_num;

//生成的订单id
@property(nonatomic,assign) NSString *order_add_id;
//生成的订单价格
@property(nonatomic,assign) NSString *order_add_price;

//@property(nonatomic,assign) int details_goods_id;
//@property(nonatomic,assign) NSString *details_goods_name;
//@property(nonatomic,assign) NSString *details_goods_sn;
//@property(nonatomic,assign) NSString *details_price;
//@property(nonatomic,assign) NSMutableArray *details_images;

//修改收货地址 id address
@property(nonatomic,retain) NSString *address_id;
@property(nonatomic,retain) NSString *addressA;

//订单生成提示框弹出类型
//@property(nonatomic,retain) NSString *checkPopList;

//订单数据
@property(nonatomic,retain) Order *order;

//订单列表
@property(nonatomic,retain) NSMutableArray *orderList;

//收货地址
@property(nonatomic,retain) Address *assress;

//收货地址列表
@property(nonatomic,retain) NSMutableArray *assressList;



//滚动展示商品ACell_id
@property(nonatomic,retain) NSMutableArray *homeAGoodsId;
//滚动展示商品ACell_image
@property(nonatomic,retain) NSMutableArray *homeAGoodsImage;
//滚动展示商品ACell_name
@property(nonatomic,retain) NSMutableArray *homeAGoodsName;
//滚动展示商品homeAGoodsSn
@property(nonatomic,retain) NSMutableArray *homeAGoodsPrice;
//滚动展示商品homeAGoodsSn
@property(nonatomic,retain) NSMutableArray *homeAGoodsSn;

//滚动展示商品BCell_id
@property(nonatomic,retain) NSMutableArray *homeBCell_id;
//滚动展示商品BCell_name
@property(nonatomic,retain) NSMutableArray *homeBCell_name;
//滚动展示商品BCell_image
@property(nonatomic,retain) NSMutableArray *homeBCell_image;
//滚动展示商品BCell_price
@property(nonatomic,retain) NSMutableArray *homeBCell_price;
//滚动展示商品BCell_sn
@property(nonatomic,retain) NSMutableArray *homeBCell_sn;

//滚动展示商品CCell_id
@property(nonatomic,retain) NSMutableArray *homeCCell_id;
//滚动展示商品CCell_name
@property(nonatomic,retain) NSMutableArray *homeCCell_name;
//滚动展示商品CCell_image
@property(nonatomic,retain) NSMutableArray *homeCCell_image;
//滚动展示商品CCell_price
@property(nonatomic,retain) NSMutableArray *homeCCell_price;
//滚动展示商品CCell_sn
@property(nonatomic,retain) NSMutableArray *homeCCell_sn;

//Tier列表A
@property(nonatomic,retain) NSMutableArray *tierAList;
//Tier列表B
@property(nonatomic,retain) NSMutableArray *tierBList;
//Tier列表C
@property(nonatomic,retain) NSMutableArray *tierCList;

//Tier列表A name
@property(nonatomic,retain) NSMutableArray *tierAList_name;
////Tier列表A cat_id
@property(nonatomic,retain) NSMutableArray *tierAList_cat_id;
//Tier列表A parent_id
@property(nonatomic,retain) NSMutableArray *tierAList_parent_id;
//Tier列表B cat_id
@property(nonatomic,retain) NSMutableArray *tierBList_cat_id;
//Tier列表B parent_id
@property(nonatomic,retain) NSMutableArray *tierBList_parent_id;
//Tier列表C cat_id
@property(nonatomic,retain) NSMutableArray * tierCList_catId;
//Tier列表C parent_id
@property(nonatomic,retain) NSMutableArray * tierCList_parentId;

//Tier列表C id
@property(nonatomic,retain) NSMutableArray * tierCList_Id;
//Tier列表C image
@property(nonatomic,retain) NSMutableArray * tierCList_Image;
//Tier列表C price
@property(nonatomic,retain) NSMutableArray * tierCList_Price;
//Tier列表C name
@property(nonatomic,retain) NSMutableArray * tierCList_Name;
//Tier列表C sn
@property(nonatomic,retain) NSMutableArray * tierCList_Sn;

+(Session *)sharedInstance;
@end
