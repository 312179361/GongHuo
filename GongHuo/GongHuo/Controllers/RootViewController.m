//
//  RootViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RootViewController.h"
#import "RootCollectionViewCell.h"
#import "RootHeaderCollectionViewCell.h"
#import "Manager.h"
#import "AlertManager.h"
#import "UploadProductViewController.h"
#import "NewsViewController.h"
#import "SVProgressHUD.h"
@interface RootViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


//数据源
@property(nonatomic,strong)NSArray *cellDataSourceArr;
@property (weak, nonatomic) IBOutlet UICollectionView *rootCollectionView;

@end

@implementation RootViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginNotiAction:) name:@"loginNoti" object:nil];

    }
    return self;
}


//登录后的通知
- (void)loginNotiAction:(NSNotification *)noti {
    Manager *manager = [Manager shareInstance];
    self.title = manager.memberInfoModel.f_name;
    //查看有没有新订单
    [self httpIsNewOrderAction];
}

- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {

    NewsViewController *newsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsViewController"];
    [self.navigationController pushViewController:newsVC animated:YES];
    
}

#pragma mark - 隐藏头部 -
//--------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    Manager *manager = [Manager shareInstance];
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    NSLog(@"++%f",yOffset);
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    CGFloat alpha=yOffset/80.0f>1.0f?1:yOffset/80.0f;
    NSLog(@"%f",alpha);
    //改变navigation的背景色
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
    //隐藏navi下面的那条线
    if (alpha>0.6) {
//        self.navigationItem.rightBarButtonItem.tintColor = kColor(57, 209, 103, 1);
        [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
        
    }else{
//        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [manager isClearNavigationBarLine:YES withNavigationController:self.navigationController];
    }
}

 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //隐藏navigation
    [self scrollViewDidScroll:self.rootCollectionView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    Manager *manager = [Manager shareInstance];
    
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    //显示navigation 那条线
    [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    //进入应用要执行一下登录，保证每次都是登录状态
    [self checkLoginAction];
   
    self.cellDataSourceArr = @[
        @{@"title":@"审核中心",@"img":@"btn_audit.png"},
        @{@"title":@"供货列表",@"img":@"btn_supply.png"},
        @{@"title":@"订单中心",@"img":@"icon_dingdan.png"},
        @{@"title":@"人员管理",@"img":@"btn_people.png"},
        @{@"title":@"设置中心",@"img":@"btn_set.png"},
        @{@"title":@"添加功能",@"img":@"icon_tjgn.png"}];
}

//进入应用要执行一下登录，保证每次都是登录状态
- (void)checkLoginAction {
    Manager *manager = [Manager shareInstance];

    //从本地读取个人信息，然后尝试自动登录一下
    BOOL result = [manager readMemberInfoModelFromLocation];
    if (result == YES) {
        //有个人信息。尝试一下登陆
        NSLog(@"%@--%@",manager.memberInfoModel.u_mobile,manager.memberInfoModel.password);
        //执行一下登录
        [manager httpLoginWithMobile:manager.memberInfoModel.u_mobile withPassword:manager.memberInfoModel.password withLoginSuccess:^(id successResult) {
            //查看有没有新订单
            [self httpIsNewOrderAction];
            
        } withLoginFail:^(NSString *failResultStr) {
            //登录失败，直接跳转到登录界面
            UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
            [self presentViewController:loginNav animated:YES completion:nil];
        }];
        
    }else {
        //本地没有保存账号密码信息，直接跳转到登录界面
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }

}

#pragma mark - 有没有新订单 -
- (void)httpIsNewOrderAction {
    Manager *manager = [Manager shareInstance];
    
    [manager httpIsNewOrderWithAFID:manager.memberInfoModel.l_s_id withIsNewSuccess:^(id successResult) {
        //计算时间
        
//        orderListModel.etm - orderListModel.time
        
        
    } withIsNewFail:^(NSString *failResultStr) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - collectionview Delegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;//头部
    }else {
        return self.cellDataSourceArr.count;
    }

}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenW, kScreenW/15*13);
    }else {
        return CGSizeMake((kScreenW-78)/3, (kScreenW-40)/3);
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RootHeaderCollectionViewCell *headCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rootHeadCell" forIndexPath:indexPath];
        return headCell;
    }else {
        RootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
        [cell updateRootCellWithInfo:self.cellDataSourceArr[indexPath.row]];
        return cell;

    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];

    if (indexPath.section == 0) {
        //上传产品
        //先判断一下是否可以上传
        [manager httpCheckAccordUploadWithASpId:manager.memberInfoModel.l_s_id withCheckAccordSuccess:^(id successResult) {
            
            if ([successResult isEqualToString:@"可以上传"]) {
                [self performSegueWithIdentifier:@"rootToUploadProductVC" sender:nil];

            }else {
                
                [alertM showAlertViewWithTitle:@"暂时不能上传产品" withMessage:successResult actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    //缺少人员，就跳转到添加人员里面
                    [self performSegueWithIdentifier:@"rootToManagerPeopleVC" sender:nil];
                }];
                
            }
            
        } withCheckAccordFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"暂时不能上传产品" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
        
    }else {
        //下面的六大块
        switch (indexPath.row) {
            case 0:
                //审核中心
                [self performSegueWithIdentifier:@"rootToReviewListVC" sender:indexPath];
                break;
                
            case 1:
                //供货
                [self performSegueWithIdentifier:@"rootToSupplyProductListVC" sender:indexPath];
                break;
                
            case 2:
                //订单中心
                [self performSegueWithIdentifier:@"rootToOrderListVC" sender:indexPath];
                break;
            case 3:
                //人员管理
                [self performSegueWithIdentifier:@"rootToManagerPeopleVC" sender:indexPath];
                break;
                
            case 4:
                //设置中心
                [self performSegueWithIdentifier:@"rootToSetVC" sender:indexPath];
                break;
                
            case 5:
                //添加功能
            {

                [alertM showAlertViewWithTitle:@"暂未开通" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"rootToUploadProductVC"]) {
        UploadProductViewController *uploadVC = [segue destinationViewController];
        uploadVC.tempType = 1;
    }
    
}


@end
