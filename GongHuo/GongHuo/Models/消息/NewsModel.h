//
//  NewsModel.h
//  GongHuo
//
//  Created by TongLi on 2017/10/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property(nonatomic,strong)NSString *i_title;
@property(nonatomic,strong)NSString *i_id;
@property(nonatomic,strong)NSString *i_introduce;
@property(nonatomic,strong)NSString *i_classify_name;
@property(nonatomic,strong)NSString *i_status;
@property(nonatomic,strong)NSString *i_level;
@property(nonatomic,strong)NSString *i_type;
@property(nonatomic,strong)NSString *i_keyword;
@property(nonatomic,strong)NSString *i_time_create;
@property(nonatomic,strong)NSString *i_classify;
@property(nonatomic,strong)NSString *i_source;
@property(nonatomic,strong)NSString *i_hits;
@property(nonatomic,strong)NSString *c_seo_title;
@property(nonatomic,strong)NSString *i_author;
@property(nonatomic,strong)NSString *c_seo_keywords;
@property(nonatomic,strong)NSString *c_seo_description;
@property(nonatomic,strong)NSString *i_code;
@property(nonatomic,strong)NSString *i_source_url;
@property(nonatomic,strong)NSString *rn;
@property(nonatomic,strong)NSString *i_icon_path;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
