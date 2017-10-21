//
//  NetManager.m
//  AFNet
//
//  Created by TongLi on 15/12/6.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager
+ (NetManager *)shareInstance{
    static NetManager *netManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [[NetManager alloc]init];
        
    });
    return netManager;
}

//get请求
- (void)getRequestWithURL:(NSString *)requestURL withParameters:(NSDictionary *)parametersDic withContentTypes:(NSString *)contentType withHeaderArr:(NSArray *)headerArr withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult {
    //网络请求操作管理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (headerArr.count > 0) {
        NSDictionary *headerDic = headerArr[0];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [[headerDic allValues] objectAtIndex:0] ] forHTTPHeaderField:[[headerDic allKeys] objectAtIndex:0]];
    }
    
    //设置请求格式和返回格式(默认分别为http和json)
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //返回格式设为二进制
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //支持的返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    //设置返回值类型为二进制
    if ([contentType isEqualToString:@"string"]) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }

    NSString *parameterStr = nil;
    if (parametersDic != nil) {
        //如果有参数，将字典变为json格式
        parameterStr = [self dictionaryToJson:parametersDic];
    }
    
    //开始get请求
    [manager GET:requestURL parameters:parameterStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求成功
        //如果返回的是字符串，就消除双引号。因为返回如果是字符串，就会带双引号
        if ([contentType isEqualToString:@"string"]) {
            
            NSString *responseObjectStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

            responseObjectStr = [responseObjectStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            responseObject = responseObjectStr;
        }

        successResult(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求失败
        failResult(operation ,error);

    }];
    
}

//POST请求
- (void)postRequestWithURL:(NSString *)requestURL withParameters:(NSDictionary *)parametersDic withResponseType:(NSString *)responseType withContentTypes:(NSSet *)contentTypes  withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    //设置返回值为二进制
    if ([responseType isEqualToString:@"data"]) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    if (contentTypes!= nil) {
        //支持的返回类型
        manager.responseSerializer.acceptableContentTypes = contentTypes;
    }

//    NSString *parameterStr = nil;
//    
//   
//    if ([parametersDic isKindOfClass:[NSDictionary class]]) {
//        //如果有参数，将字典变为json格式
//        parameterStr = [self dictionaryToJson:parametersDic];
//    }
//    if ([parametersDic isKindOfClass:[NSString class]]) {
//        parameterStr = parametersDic;
//    }
    NSLog(@"---%@",[self dictionaryToJson:parametersDic]);
    
    [manager POST:requestURL parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //如果返回的是字符串，就消除双引号。因为返回如果是字符串，就会带双引号
//        if ([contentType isEqualToString:@"string"]) {
//            
//            NSString *responseObjectStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//            
//            responseObjectStr = [responseObjectStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            responseObject = responseObjectStr;
//        }

        //打印结果
//       NSLog(@"%@", [self dictionaryToJson:responseObject]);
        successResult(operation ,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求失败
        
        failResult(operation ,error);
    }];
}

//delete请求
- (void)deleteRequestWithURL:(NSString *)requestURL withParameters:(NSDictionary *)parametersDic withContentTypes:(NSString *)contentType withHeaderArr:(NSArray *)headerArr withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (headerArr.count > 0) {
        NSDictionary *headerDic = headerArr[0];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [[headerDic allValues] objectAtIndex:0] ] forHTTPHeaderField:[[headerDic allKeys] objectAtIndex:0]];
    }

    //设置返回值类型为二进制
    if ([contentType isEqualToString:@"string"]) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    }

    NSString *parameterStr = nil;
    if (parametersDic != nil) {
        //如果有参数，将字典变为json格式
        parameterStr = [self dictionaryToJson:parametersDic];
    }
    
    [manager DELETE:requestURL parameters:parameterStr success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //请求成功
        //如果返回的是字符串，就消除双引号。因为返回如果是字符串，就会带双引号
        if ([contentType isEqualToString:@"string"]) {
            
            NSString *responseObjectStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            responseObjectStr = [responseObjectStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            responseObject = responseObjectStr;
        }

        successResult(operation ,responseObject);

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //请求失败
        failResult(operation ,error);

    }];
    
}


- (void)putRequestWithURL:(NSString *)requestURL withParameters:(id)parametersDic withContentTypes:(NSString *)contentType withHeaderArr:(NSArray *)headerArr withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (headerArr.count > 0) {
        NSDictionary *headerDic = headerArr[0];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [[headerDic allValues] objectAtIndex:0] ] forHTTPHeaderField:[[headerDic allKeys] objectAtIndex:0]];
    }

    NSString *parameterStr = nil;
    if ([parametersDic isKindOfClass:[NSDictionary class]]) {
        //如果有参数，将字典变为json格式
        parameterStr = [self dictionaryToJson:parametersDic];
    }
    if ([parametersDic isKindOfClass:[NSString class]]) {
        parameterStr = parametersDic;
    }
    
    //设置返回值类型为二进制
    if ([contentType isEqualToString:@"string"]) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    
    
    [manager PUT:requestURL parameters:parameterStr success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //成功结果
        //如果返回的是字符串，就消除双引号。因为返回如果是字符串，就会带双引号
        if ([contentType isEqualToString:@"string"]) {
            
            NSString *responseObjectStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            responseObjectStr = [responseObjectStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            responseObject = responseObjectStr;
        }

        successResult(operation ,responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //请求失败
        failResult(operation ,error);
    }];
    
}


/*
- (void)uploadImageWithURL:(NSString *)requestURL withParameters:(NSDictionary *)parameterDic withImage:(UIImage *)uploadImg withImageName:(NSString *)imageName withSuccessResult:(SuccessResultBlock)successResult withFailResult:(FailResultBlock)failResult {
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [requestManager POST:requestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //  appendPartWithFileURL     指定上传的文件
        // name                      指定在服务器中获取对应文件或文本时的key
        //  fileName                  指定上传文件的原始文件名
        //  mimeType                  指定商家文件的MIME类型
        //
        //        [formData appendPartWithFileURL:filePath name:@"filename" fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png" error:nil];
        
        NSData *imageData = UIImagePNGRepresentation(uploadImg);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"text.png" mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功%@",str);
        
        
        NSDictionary *responseDic = [self getNewJsonWithData:responseObject];
        
        successResult(operation ,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //上传图片失败
        failResult(operation ,error);
    }];
    
}

*/


#pragma mark - 将字典变为json格式的字符串 -
- (NSString *)dictionaryToJson:(id )dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *tempStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return tempStr;

}



@end
