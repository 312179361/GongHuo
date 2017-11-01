//
//  PeopleManagerViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PeopleManagerViewController.h"
#import "PeopleManagerTableViewCell.h"
#import "AddPeopleViewController.h"
#import "Manager.h"
#import "MJRefresh.h"
#import "NewsViewController.h"
@interface PeopleManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)BOOL isHttp;//标记是否要刷新

@property (weak, nonatomic) IBOutlet UILabel *factoryNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *peopleMangerTableView;
@property(nonatomic,strong)NSMutableArray *userListDataSourceArr;

@end

@implementation PeopleManagerViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，刷新列表
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPeopleListNotiAction:) name:@"refreshPeopleListNoti" object:nil];
        
    }
    return self;
}

- (void)refreshPeopleListNotiAction:(NSNotification *)noti {
    //标记需要刷新
    self.isHttp = YES;
}

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    NewsViewController *newsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsViewController"];
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];
    self.factoryNameLabel.text = manager.memberInfoModel.f_name;

    
    self.isHttp = YES;//首次进入肯定要请求数据
    
    //添加下拉刷新和上拉加载
    [self downPushRefresh];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏navigation
    [self scrollViewDidScroll:self.peopleMangerTableView];
    
    //请求列表数据
    if (self.isHttp == YES) {
        //需要请求数据
        [self httpUserList];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    //显示Navigate
    Manager *manager = [Manager shareInstance];
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    //显示navigation 那条线
    [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
    
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
    //改变通知按钮的颜色
    if (alpha>0.6) {
        self.navigationItem.rightBarButtonItem.tintColor = kColor(57, 209, 103, 1);
        [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
        
    }else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [manager isClearNavigationBarLine:YES withNavigationController:self.navigationController];
    }
}

#pragma mark - 下拉刷新 -
//下拉刷新
- (void)downPushRefresh {
    [self.peopleMangerTableView addHeaderWithCallback:^{
        NSLog(@"下拉刷新啦");
        //不管ishttp是否为YES，都要请求最新列表信息
        [self httpUserList];

    }];
    
}



#pragma mark - 网络请求人员列表 -
- (NSMutableArray *)userListDataSourceArr {
    if (_userListDataSourceArr == nil) {
        self.userListDataSourceArr = [NSMutableArray array];
    }
    return _userListDataSourceArr;
}


- (void)httpUserList {
    Manager *manager = [Manager shareInstance];
    [manager httpUserListWithASpId:manager.memberInfoModel.l_s_id withMobile:manager.memberInfoModel.u_mobile withUserId:manager.memberInfoModel.userid withUserListSuccess:^(id successResult) {
        
        //请求后，标记已经刷新过了
        self.isHttp = NO;
        //数据源
        self.userListDataSourceArr = [successResult objectForKey:@"list"];
        [self.peopleMangerTableView reloadData];
        [self.peopleMangerTableView headerEndRefreshing];//取消头部刷新效果
        
    } withUserListFail:^(NSString *failResultStr) {
        
    }];
}










#pragma mark - 添加人员 -
//添加人员
- (IBAction)AddPeopleTap:(UITapGestureRecognizer *)sender {
    
    [self performSegueWithIdentifier:@"peopleManagerToAddPeopleVC" sender:nil];
}


#pragma mark - TableView Delegat -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userListDataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PeopleManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peopleManagerCell" forIndexPath:indexPath];
    UserListModel *tempModel = self.userListDataSourceArr[indexPath.row];

    [cell updatePeopleManagerCellWithModel:tempModel];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UserListModel *tempModel = self.userListDataSourceArr[indexPath.row];
//    [self performSegueWithIdentifier:@"peopleManagerToAddPeopleVC" sender:tempModel];


    AlertManager *alertM = [AlertManager shareIntance];
    UserListModel *tempModel = self.userListDataSourceArr[indexPath.row];
    if ([tempModel.edit integerValue] == 1) {
        //可编辑
        [self performSegueWithIdentifier:@"peopleManagerToAddPeopleVC" sender:tempModel];

    }else {
        //不可编辑
        [alertM showAlertViewWithTitle:@"这个人员不可编辑" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }

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
    if ([segue.identifier isEqualToString:@"peopleManagerToAddPeopleVC"]) {
        AddPeopleViewController *addPeopleVC = [segue destinationViewController];
        
        if (sender != nil) {
            addPeopleVC.tempUserModel = sender;
        }
        
    }
}

@end
