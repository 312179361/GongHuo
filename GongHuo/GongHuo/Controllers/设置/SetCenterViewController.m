//
//  SetCenterViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SetCenterViewController.h"
#import "Manager.h"
#import "SDImageCache.h"
@interface SetCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *dataSourceArr;
@property (weak, nonatomic) IBOutlet UITableView *setCenterTableView;

//缓存大小
@property (nonatomic,assign)NSUInteger cacheSize;

@end

@implementation SetCenterViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
#warning 消息
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSourceArr = @[@"清除缓存",@"修改密码",@"退出登录"];
    
    //计算缓存
    self.cacheSize = [[SDImageCache sharedImageCache]getSize];
    
}

#pragma mark - tableview Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCenterCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArr[indexPath.row];
    //缓存
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = [self cacheSizeToString];
        
    }else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            //清除缓存
            [self clearCacheAction];
            break;
        case 1:
            //修改密码
            [self performSegueWithIdentifier:@"setToMotifyPasswordVC" sender:indexPath];
            break;
        case 2:
            //退出登录
            [self logOffAction];
            break;
        default:
            break;
    }
}

//清除缓存
- (void)clearCacheAction {
    //清理缓存
    AlertManager *alertM = [AlertManager shareIntance];
    [alertM showAlertViewWithTitle:nil withMessage:@"是否要清理缓存" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            if (self.cacheSize > 0) {
                //清理缓存
                [[SDImageCache sharedImageCache]clearDisk];
                //重新计算
                self.cacheSize = [[SDImageCache sharedImageCache]getSize];
                //更新UI
                [self.setCenterTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
    }];
}

//缓存计算
- (NSString *)cacheSizeToString {
    float tempCacheFloat = self.cacheSize;
    
    if (tempCacheFloat > 0) {
        //如果大于1K,就换算成K
        if (tempCacheFloat >= 1024) {
            tempCacheFloat = tempCacheFloat / 1024.0;
            
            //看看有没有达到 1M的
            if (tempCacheFloat >= 1024) {
                tempCacheFloat = tempCacheFloat / 1024.0;
                
                //看看有没有达到 1G的
                if (tempCacheFloat >= 1024) {
                    tempCacheFloat = tempCacheFloat / 1024.0;
                    return [NSString stringWithFormat:@"%.2f G",tempCacheFloat];
                    
                }else {
                    //不满1G
                    return [NSString stringWithFormat:@"%.2f M",tempCacheFloat];
                }
                
            }else {
                //不满1M
                return [NSString stringWithFormat:@"%.2f K",tempCacheFloat];
            }
            
        }else {
            //不满1K
            return [NSString stringWithFormat:@"%.2f B",tempCacheFloat];
        }
        
        
    }else {
        return @"0 KB";
    }
}

//退出登录
- (void)logOffAction {
    Manager *manager = [Manager shareInstance];
    
    AlertManager *alert = [AlertManager shareIntance];
    [alert showAlertViewWithTitle:nil withMessage:@"确定退出登录" actionTitleArr:@[@"取消" ,@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            //确定按钮， 退出登录；
            [manager logOffAction];
            //弹出登录界面
            UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
            [self presentViewController:loginNav animated:YES completion:nil];
            //返回到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
