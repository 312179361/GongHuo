//
//  ReviewListViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ReviewListViewController.h"
#import "Manager.h"
#import "LineButton.h"
#import "ReviewListHeaderTableViewCell.h"
#import "ReviewListTableViewCell.h"
#import "ReviewDetailViewController.h"
@interface ReviewListViewController ()<UITableViewDataSource,UITableViewDelegate>
//头部四大按钮
@property (weak, nonatomic) IBOutlet LineButton *allButton;
@property (weak, nonatomic) IBOutlet LineButton *inReviewButton;
@property (weak, nonatomic) IBOutlet LineButton *passedButton;
@property (weak, nonatomic) IBOutlet LineButton *notPassButton;


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
//数据源
@property(nonatomic,strong)NSMutableDictionary *checkListDataSourceDic;
@property(nonatomic,strong)NSString *currentType;//当前类型，9全部、0审核中、1已通过、2未通过


@end

@implementation ReviewListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，刷新列表
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshReviewListNotiAction:) name:@"refreshReviewList" object:nil];
 
    }
    return self;
}

- (void)refreshReviewListNotiAction:(NSNotification *)noti {
    //清空所有列表信息
    self.checkListDataSourceDic = nil;
    
}

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
#warning 消息列表
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //首次进入，类型是全部
    self.currentType = @"9";
//    [self httpCheckListWithStatus:self.currentType withPages:@"1"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //查看一下原来有没有信息,如果没有，就请求信息
    if ([self.checkListDataSourceDic objectForKey:self.currentType] == nil) {
        [self httpCheckListWithStatus:self.currentType withPages:1];
    }
    
}



#pragma mark - 网络请求列表 -
- (NSMutableDictionary *)checkListDataSourceDic {
    if (_checkListDataSourceDic == nil) {
        self.checkListDataSourceDic = [NSMutableDictionary dictionary ];
    }
    return _checkListDataSourceDic;
}

- (void)httpCheckListWithStatus:(NSString *)status withPages:(NSInteger)pages {
    
    Manager *manager = [Manager shareInstance];
    if ([status isEqualToString: @"9"]) {
        status = @"";
    }
    [manager httpCheckListWithA_SP_ID:manager.memberInfoModel.l_s_id withMobile:manager.memberInfoModel.u_mobile withStatus:status withIsAdmin:manager.memberInfoModel.l_is_admin withUserID:manager.memberInfoModel.userid withPageIndex:pages withCheckListSuccess:^(id successResult) {
        
        [self.checkListDataSourceDic setValue:successResult forKey:self.currentType];
        [self.listTableView reloadData];
        
    } withCheckListFail:^(NSString *failResultStr) {
        
    }];
}

#pragma mark - 四大分类 -
//头部四个按钮方法
- (IBAction)allButtonAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"9"]) {
        self.currentType = @"9";
        //改变颜色
        [self.allButton setColor:kMainColor];
        [self.inReviewButton setColor:[UIColor clearColor]];
        [self.passedButton setColor:[UIColor clearColor]];
        [self.notPassButton setColor:[UIColor clearColor]];
        
        [self.allButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.inReviewButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.passedButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.notPassButton setTitleColor:k333333Color forState:UIControlStateNormal];

        //请求信息。查看一下原来有没有信息
        if ([self.checkListDataSourceDic objectForKey:@"9"] == nil) {
            [self httpCheckListWithStatus:self.currentType withPages:1];
        }else {
            [self.listTableView reloadData];
        }
        

    }
    
   
}

- (IBAction)inReviewButtonAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"0"]) {
        self.currentType = @"0";
        //改变颜色
        [self.allButton setColor:[UIColor clearColor]];
        [self.inReviewButton setColor:kMainColor];
        [self.passedButton setColor:[UIColor clearColor]];
        [self.notPassButton setColor:[UIColor clearColor]];
        
        [self.allButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.inReviewButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.passedButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.notPassButton setTitleColor:k333333Color forState:UIControlStateNormal];

        
        //请求信息。查看一下原来有没有信息
        if ([self.checkListDataSourceDic objectForKey:@"0"] == nil) {
            [self httpCheckListWithStatus:self.currentType withPages:1];
        }else {
            [self.listTableView reloadData];
        }

    }
    

}

- (IBAction)passedButtonAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"1"]) {
        self.currentType = @"1";

        //改变颜色
        [self.allButton setColor:[UIColor clearColor]];
        [self.inReviewButton setColor:[UIColor clearColor]];
        [self.passedButton setColor:kMainColor];
        [self.notPassButton setColor:[UIColor clearColor]];
        
        [self.allButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.inReviewButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.passedButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.notPassButton setTitleColor:k333333Color forState:UIControlStateNormal];

        //请求信息。查看一下原来有没有信息
        if ([self.checkListDataSourceDic objectForKey:@"1"] == nil) {
            [self httpCheckListWithStatus:self.currentType withPages:1];
        }else {
            [self.listTableView reloadData];
        }


    }
    

}

- (IBAction)notPassButtonAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"2"]) {
        self.currentType = @"2";

        //改变颜色
        [self.allButton setColor:[UIColor clearColor]];
        [self.inReviewButton setColor:[UIColor clearColor]];
        [self.passedButton setColor:[UIColor clearColor]];
        [self.notPassButton setColor:kMainColor];
        
        [self.allButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.inReviewButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.passedButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.notPassButton setTitleColor:kMainColor forState:UIControlStateNormal];

        //请求信息。查看一下原来有没有信息
        if ([self.checkListDataSourceDic objectForKey:@"2"] == nil) {
            [self httpCheckListWithStatus:self.currentType withPages:1];
        }else {
            [self.listTableView reloadData];
        }


    }
    

}

#pragma mark - TableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *listArr = [[self.checkListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    
    return listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45   ;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //返回值就是区页眉。那么我们就让他返回headViewCell
    ReviewListHeaderTableViewCell *headViewCell = [tableView dequeueReusableCellWithIdentifier:@"reviewListHeaderCell"];
    
    NSMutableArray *listArr = [[self.checkListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    CheckListModel *tempModel = listArr[section];

    [headViewCell updateHeaderCellWithListModel:tempModel];
    
//    headViewCell.reviewStatusLabel.text = @"已通过";
    
    return headViewCell;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReviewListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewListCell" forIndexPath:indexPath];
    NSMutableArray *listArr = [[self.checkListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    CheckListModel *tempModel = listArr[indexPath.section];
    [cell updateReviewCellWithListModel:tempModel];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *listArr = [[self.checkListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    CheckListModel *tempModel = listArr[indexPath.section];
    if ([tempModel.A_STATUS_CHECK isEqualToString:@"0"] || [tempModel.A_STATUS_CHECK isEqualToString:@"2"]) {
        //可以点击
        [self performSegueWithIdentifier:@"reviewListToDetailVC" sender:tempModel];
        
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
    if ([segue.identifier isEqualToString:@"reviewListToDetailVC"]) {
        ReviewDetailViewController *reviewDetailVC = [segue destinationViewController];
        reviewDetailVC.fromType = 0;
        reviewDetailVC.tempCheckModel = sender;
    }
}


@end
