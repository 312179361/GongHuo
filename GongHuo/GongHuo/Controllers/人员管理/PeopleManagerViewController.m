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
@interface PeopleManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *peopleMangerTableView;
@property(nonatomic,strong)NSMutableArray *userListDataSourceArr;
@end

@implementation PeopleManagerViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self httpUserList];

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
        
        self.userListDataSourceArr = [successResult objectForKey:@"list"];
        [self.peopleMangerTableView reloadData];
        
    } withUserListFail:^(NSString *failResultStr) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //隐藏navigation
    [self scrollViewDidScroll:self.peopleMangerTableView];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
        //重新请求列表
        addPeopleVC.refreshListBlock = ^{
            [self httpUserList];
        };
        
    }
}

@end
