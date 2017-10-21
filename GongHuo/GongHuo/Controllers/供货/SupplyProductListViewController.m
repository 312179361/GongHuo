//
//  SupplyProductListViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SupplyProductListViewController.h"
#import "Manager.h"
#import "LineButton.h"
#import "SupplyProductListTableViewCell.h"
#import "SupplyProductListTwoTableViewCell.h"
#import "SupplyProductListThreeTableViewCell.h"
#import "AlertCustomizeViewController.h"
#import "ReviewDetailViewController.h"
@interface SupplyProductListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *supplyListTableview;
//四个按钮
@property (weak, nonatomic) IBOutlet LineButton *upperButton;
@property (weak, nonatomic) IBOutlet LineButton *modifyButton;
@property (weak, nonatomic) IBOutlet LineButton *lowerButton;

//数据源
@property(nonatomic,strong)NSMutableDictionary *supplyListDataSourceDic;
@property(nonatomic,strong)NSString *currentType;//当前类型，0上架中、1、修改记录、2已下架



@end

@implementation SupplyProductListViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
    }
    return self;
}

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
#warning 消息
    [self.supplyListTableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //首次进入，类型是全部
    self.currentType = @"0";
    
    // 让cell自适应高度
    self.supplyListTableview.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.supplyListTableview.estimatedRowHeight = 44;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //查看一下原来有没有信息,如果没有，就请求信息
    if ([self.supplyListDataSourceDic objectForKey:self.currentType] == nil) {
        [self httpSupplyListWithStatus:self.currentType withPages:1];
    }
    
}

#pragma mark - 网络请求列表 -
- (NSMutableDictionary *)supplyListDataSourceDic {
    if (_supplyListDataSourceDic == nil) {
        self.supplyListDataSourceDic = [NSMutableDictionary dictionary];
    }
    return _supplyListDataSourceDic;
}

- (void)httpSupplyListWithStatus:(NSString *)status withPages:(NSInteger)pages {
    
    Manager *manager = [Manager shareInstance];
    
    [manager httpSupplyListWithDFID:manager.memberInfoModel.l_s_id withStatusCheck:status withSid:@"" withAid:@"" withPageIndex:pages withSupplyListSuccess:^(id successResult) {
        
        [self.supplyListDataSourceDic setValue:successResult forKey:self.currentType];
        [self.supplyListTableview reloadData];

    } withSupplyListFail:^(NSString *failResultStr) {
        
    }];

}


#pragma mark - 三大分类 -
//头部三个button
- (IBAction)upperButtonAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"0"]) {
        self.currentType = @"0";
        //改变颜色
        [self.upperButton setColor:kMainColor];
        [self.modifyButton setColor:[UIColor clearColor]];
        [self.lowerButton setColor:[UIColor clearColor]];
        
        [self.upperButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.modifyButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.lowerButton setTitleColor:k333333Color forState:UIControlStateNormal];
        
        //请求信息。查看一下原来有没有信息
        if ([self.supplyListDataSourceDic objectForKey:@"0"] == nil) {
            [self httpSupplyListWithStatus:self.currentType withPages:1];
        }else {
            [self.supplyListTableview reloadData];
        }


    }
   
    

}


- (IBAction)modifyButtonAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"1"]) {
        self.currentType = @"1";
        //改变颜色
        [self.upperButton setColor:[UIColor clearColor]];
        [self.modifyButton setColor:kMainColor];
        [self.lowerButton setColor:[UIColor clearColor]];
        
        [self.upperButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.modifyButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.lowerButton setTitleColor:k333333Color forState:UIControlStateNormal];

        //请求信息。查看一下原来有没有信息
        if ([self.supplyListDataSourceDic objectForKey:@"1"] == nil) {
            [self httpSupplyListWithStatus:self.currentType withPages:1];
        }else {
            [self.supplyListTableview reloadData];
        }

        
    }
   
}

- (IBAction)lowerButtonAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"2"]) {
        self.currentType = @"2";
        //改变颜色
        [self.upperButton setColor:[UIColor clearColor]];
        [self.modifyButton setColor:[UIColor clearColor]];
        [self.lowerButton setColor:[UIColor redColor]];

        [self.upperButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.modifyButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.lowerButton setTitleColor:kMainColor forState:UIControlStateNormal];
        
        //请求信息。查看一下原来有没有信息
        if ([self.supplyListDataSourceDic objectForKey:@"2"] == nil) {
            [self httpSupplyListWithStatus:self.currentType withPages:1];
        }else {
            [self.supplyListTableview reloadData];
        }

        
    }

}


#pragma mark - TableViewDelega -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    
    return listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    SupplyListModel *tempModel = listArr[indexPath.section];
    
    if ([self.currentType isEqualToString:@"0"]) {
        //上架中
        SupplyProductListTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"supplyProductListCell" forIndexPath:indexPath];
        
        [cell1 updateSupplyListCellWithModel:tempModel withCellIndex:indexPath];

        return cell1;
    }
    
    if ([self.currentType isEqualToString:@"1"]) {
        //修改记录
        SupplyProductListTwoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"supplyProductListTwoCell" forIndexPath:indexPath];
        [cell2 updateSupplyListTwoCellWithModel:tempModel];
        
        return cell2;
    }
    
    if ([self.currentType isEqualToString:@"2"]) {
        //已架了
        SupplyProductListThreeTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"supplyProductListThreeCell" forIndexPath:indexPath];
        [cell3 updateSupplyThreeCellWithModel:tempModel withCellIndex:indexPath];
        
        return cell3;
        
    }
    
    return 0;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    SupplyListModel *tempModel = listArr[indexPath.section];
    
    [self performSegueWithIdentifier:@"supplyListToDetailVC" sender:tempModel];
}


#pragma mark - 底部button -
//上架中 底部第一个button
- (IBAction)oneCellOneBottomBtnAction:(IndexButton *)sender {
    Manager *manager = [Manager shareInstance];
    
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:@"0"] objectForKey:@"list"];
    SupplyListModel *tempModel = listArr[sender.btnIndex.section];

    //下架 弹出alertView
    AlertCustomizeViewController *alertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"alertCustomizeVC"];
    alertVC.alertTypeInt = alertOne;
    alertVC.enterBlock = ^(id enterBLock) {
        NSLog(@"%@",enterBLock);
        /*下架操作
         返回值是字典
         @{@"reasonInt":下架类型int,
         @"reasonStr":下架原因字符串}
         */
        [manager httpEditSupplyProductWithModel:tempModel withMemberInfo:manager.memberInfoModel withEditType:@"1" withNewPrice:@"" withNewInventory:@"" withShelfInt:[enterBLock objectForKey:@"reasonInt"] withShelfReason:[enterBLock objectForKey:@"reasonStr"] withEditSupplySuccess:^(id successResult) {
            //下架成功后，将这个数据从数据源中删除
            [listArr removeObject:tempModel];
            [self.supplyListTableview reloadData];
            
            //清空一下 已下架的产品，方便下次刷新
            [self.supplyListDataSourceDic setValue:nil forKey:@"2"];
            
        } withEditSupplyFail:^(NSString *failResultStr) {
            
        }];
        
        
    };
    [self presentViewController:alertVC animated:YES completion:nil];

    
}

//上架中 底部第二个button
- (IBAction)oneCellTwoBottomBtnAction:(IndexButton *)sender {
    Manager *manager = [Manager shareInstance];
    
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:@"0"] objectForKey:@"list"];
    SupplyListModel *tempModel = listArr[sender.btnIndex.section];
    
    //修改价格 弹出alertView
    AlertCustomizeViewController *alertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"alertCustomizeVC"];
    alertVC.alertTypeInt = alertTwo;
    alertVC.alertTwoTitleStr = @"修改价格";
    alertVC.oldNumberStr = tempModel.A_PRICE_COST;//老价格
    alertVC.enterBlock = ^(id enterBLock) {
        //修改价格
        NSLog(@"%@",enterBLock);
        [manager httpEditSupplyProductWithModel:tempModel withMemberInfo:manager.memberInfoModel withEditType:@"2" withNewPrice:enterBLock withNewInventory:@"" withShelfInt:@"" withShelfReason:@"" withEditSupplySuccess:^(id successResult) {
            //修改价格后，将这个数据从数据源中删除
            [listArr removeObject:tempModel];
            [self.supplyListTableview reloadData];

            //清空一下 修改记录的产品，方便下次刷新
            [self.supplyListDataSourceDic setValue:nil forKey:@"1"];
            
        } withEditSupplyFail:^(NSString *failResultStr) {
            
        }];
        
        
    };
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

//上架中 底部第三个button
- (IBAction)oneCellThreeBottomBtnAction:(IndexButton *)sender {
    Manager *manager = [Manager shareInstance];
    
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:@"0"] objectForKey:@"list"];
    SupplyListModel *tempModel = listArr[sender.btnIndex.section];
    
    //修改库存 弹出alertView
    AlertCustomizeViewController *alertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"alertCustomizeVC"];
    alertVC.alertTypeInt = alertTwo;
    alertVC.alertTwoTitleStr = @"修改库存";
    alertVC.oldNumberStr = tempModel.D_INVENTORY;//老库存

    alertVC.enterBlock = ^(id enterBLock) {
        //修改库存
        NSLog(@"%@",enterBLock);
        [manager httpEditSupplyProductWithModel:tempModel withMemberInfo:manager.memberInfoModel withEditType:@"3" withNewPrice:@"" withNewInventory:enterBLock withShelfInt:@"" withShelfReason:@"" withEditSupplySuccess:^(id successResult) {
            
            //修改库存后，将这个数据从数据源中删除
            [listArr removeObject:tempModel];
            [self.supplyListTableview reloadData];

            //清空一下 修改记录的产品，方便下次刷新
            [self.supplyListDataSourceDic setValue:nil forKey:@"1"];

        } withEditSupplyFail:^(NSString *failResultStr) {
            
        }];
        
        
    };
    [self presentViewController:alertVC animated:YES completion:nil];
}


//已下架 底部第一个button
- (IBAction)twoCellOneBottomBtnAction:(IndexButton *)sender {
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:@"2"] objectForKey:@"list"];
    SupplyListModel *tempModel = listArr[sender.btnIndex.section];
    
    //上架
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    [alertM showAlertViewWithTitle:@"是否上架该产品" withMessage:nil actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            //上架请求
            [manager httpSupplyShelvesWithAid:tempModel.A_ID withAUid:manager.memberInfoModel.userid withShelvesSuccess:^(id successResult) {
                
                [alertM showAlertViewWithTitle:@"恭喜您，上架成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    
                    //上架成功后。将这个数据从数据源中删除
                    [listArr removeObject:tempModel];
                    [self.supplyListTableview reloadData];
                    
                    //清空一下 已上架的产品，方便下次刷新
                    [self.supplyListDataSourceDic setValue:nil forKey:@"0"];

                }];
                
            } withShelvesFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:@"上架失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
        }
    }];
    
    
}
//已下架 底部第二个button
- (IBAction)twoCellTwoBottomBtnAction:(IndexButton *)sender {
    NSMutableArray *listArr = [[self.supplyListDataSourceDic objectForKey:@"2"] objectForKey:@"list"];
    SupplyListModel *tempModel = listArr[sender.btnIndex.section];
    
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    [alertM showAlertViewWithTitle:@"是否删除该产品" withMessage:nil actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            //删除
            [manager httpSupplyDeleteWithAid:tempModel.A_ID withSupplyDeleteSuccess:^(id successResult) {
                [alertM showAlertViewWithTitle:@"删除成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    
                    //上架成功后。将这个数据从数据源中删除
                    [listArr removeObject:tempModel];
                    [self.supplyListTableview reloadData];
                    
                }];
                
            } withSupplyDeleteFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:@"删除失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];

        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"supplyListToDetailVC"]) {
        //
        ReviewDetailViewController *reviewDetailVC = [segue destinationViewController];
        SupplyListModel *tempSupplyModel = sender;
        //由于模型不一样，所以要装换模型
//        CheckListModel *tempListModel = [[CheckListModel alloc] init];
//        [tempListModel setValuesForKeysWithSupplyModel:tempSupplyModel];
//        NSLog(@"%@",tempListModel);
        reviewDetailVC.fromType = 1;
        reviewDetailVC.tempSupplyModel = tempSupplyModel;
        reviewDetailVC.currentType = self.currentType;
        
    }
    
    
}


@end
