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
#import "MJRefresh.h"
#import "NewsViewController.h"
@interface ReviewListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableDictionary *isHttpDic;
//头部四大按钮
@property (weak, nonatomic) IBOutlet LineButton *allButton;
@property (weak, nonatomic) IBOutlet LineButton *inReviewButton;
@property (weak, nonatomic) IBOutlet LineButton *passedButton;
@property (weak, nonatomic) IBOutlet LineButton *notPassButton;


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
//数据源
@property(nonatomic,strong)NSMutableDictionary *checkListDataSourceDic;

@property(nonatomic,strong)NSString *currentType;//当前类型，9全部、0审核中、1已通过、2未通过
@property (nonatomic,strong)NSMutableDictionary *currentPageDic;//当前页数字典

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
    //标记所有产品都需要刷新
    self.isHttpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"YES",@"9",@"YES",@"0",@"YES",@"1",@"YES",@"2", nil];
    
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
    // 让cell自适应高度
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.listTableView.estimatedRowHeight = 44;
    
    //首次进入，类型是全部
    self.currentType = @"9";
    
    self.isHttpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"YES",@"9",@"YES",@"0",@"YES",@"1",@"YES",@"2", nil];//首次进入肯定要请求数据
    
    //默认都是第一页
    self.currentPageDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"9",@"1",@"0",@"1",@"1",@"1",@"2",nil];
    //添加下拉刷新和上拉加载
    [self downPushRefresh];
    [self upPushReload];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //请求列表数据
    if ([[self.isHttpDic objectForKey:self.currentType] isEqualToString:@"YES"]) {
        //需要请求数据
        [self httpCheckListWithStatus:self.currentType withPages:1];

    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
    
}

#pragma mark - 下拉刷新 上拉加载 -
//下拉刷新
- (void)downPushRefresh {
    [self.listTableView addHeaderWithCallback:^{
        NSLog(@"下拉刷新啦");
        //不管ishttp是否为YES，都要请求最新列表信息
        [self httpCheckListWithStatus:self.currentType withPages:1];

    }];
    
}
//上拉加载
- (void)upPushReload {
   
    [self.listTableView addFooterWithCallback:^{
        NSLog(@"上拉加载啦");
        //现在第几页
        NSInteger tempCurrentPage = [[self.currentPageDic objectForKey:self.currentType] integerValue] ;
        //总共有几页
        
        NSInteger totalPage = [[[self.checkListDataSourceDic objectForKey:self.currentType] objectForKey:@"pages"] integerValue];
        
        if (tempCurrentPage < totalPage) {
            //进行加载
            [self httpCheckListWithStatus:self.currentType withPages:tempCurrentPage+1];
            
        }else {
            [self.listTableView footerEndRefreshing];
        }

    }];
    
    
    
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
    
    [manager httpCheckListWithA_SP_ID:manager.memberInfoModel.l_s_id withMobile:manager.memberInfoModel.u_mobile withStatus:status withIsAdmin:manager.memberInfoModel.l_is_admin withUserID:manager.memberInfoModel.userid withPageIndex:pages withCheckListSuccess:^(id successResult) {
        
        if (pages == 1) {
            //刷新
            //请求后，标记已经刷新过了
            [self.isHttpDic setValue:@"NO" forKey:status];
            //刷新了，就要重置currentPage
            [self.currentPageDic setValue:@"1" forKey:status];
            //数据源
            [self.checkListDataSourceDic setValue:successResult forKey:status];

            [self.listTableView headerEndRefreshing];//取消头部刷新效果
        }else {
            //加载
            //在原来的基础上增加数据源
            //得到对应的数据源
            NSMutableDictionary *tempDic = [self.checkListDataSourceDic objectForKey:status];
            NSMutableArray *tempData = [tempDic objectForKey:@"list"];
            [tempData addObjectsFromArray:[successResult objectForKey:@"list"]];
            [tempDic setValue:[successResult objectForKey:@"pages"] forKey:@"pages"];
            
            [self.listTableView footerEndRefreshing];//取消尾部加载效果
            //加载要刷新currentPage
            [self.currentPageDic setValue:[NSString stringWithFormat:@"%ld",pages] forKey:status];
            
        }
        
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
        if ([self.checkListDataSourceDic objectForKey:@"9"] == nil || [[self.isHttpDic objectForKey:@"9"] isEqualToString:@"YES"]) {
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
        if ([self.checkListDataSourceDic objectForKey:@"0"] == nil || [[self.isHttpDic objectForKey:@"0"] isEqualToString:@"YES"]) {
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
        if ([self.checkListDataSourceDic objectForKey:@"1"] == nil || [[self.isHttpDic objectForKey:@"1"] isEqualToString:@"YES"]) {
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
        if ([self.checkListDataSourceDic objectForKey:@"2"] == nil || [[self.isHttpDic objectForKey:@"2"] isEqualToString:@"YES"]) {
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *listArr = [[self.checkListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    CheckListModel *tempModel = listArr[indexPath.section];
    
    [self performSegueWithIdentifier:@"reviewListToDetailVC" sender:tempModel];

    /*
    if ([tempModel.A_STATUS_CHECK isEqualToString:@"0"] || [tempModel.A_STATUS_CHECK isEqualToString:@"2"]) {
        //可以点击
        [self performSegueWithIdentifier:@"reviewListToDetailVC" sender:tempModel];
        
    }
     */
    
    
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
