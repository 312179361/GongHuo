//
//  OrderListViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/21.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "OrderListViewController.h"
#import "Manager.h"
#import "LineButton.h"
#import "OrderListModel.h"
#import "OrderListHeaderTableViewCell.h"
#import "OrderListFootOneTableViewCell.h"
#import "OrderListOneTableViewCell.h"
#import "OrderListTwoTableViewCell.h"
#import "SendDetailViewController.h"
#import "SendCerViewController.h"
@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableDictionary *isHttpDic;//是否要请求数据(因为有三个类型，所以要用字典)主要用于别的界面发送通知修改这个界面的内容

@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
//头部三个类型按钮
@property (weak, nonatomic) IBOutlet LineButton *headOneButton;
@property (weak, nonatomic) IBOutlet LineButton *headTwoButton;
@property (weak, nonatomic) IBOutlet LineButton *headThreeButton;


//数据源
@property(nonatomic,strong)NSMutableDictionary *orderListDataSourceDic;
@property(nonatomic,strong)NSString *currentType; //当前类型 0待接单 1待发货 3已完成
//定时器
@property(nonatomic,strong)NSTimer *tempTimer;
@property(nonatomic,assign)BOOL isTimerRun;//定时器是否要运行

@end

@implementation OrderListViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，刷新列表
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshOrderListNotiAction:) name:@"refreshOrderList" object:nil];
        
    }
    return self;
}

- (void)refreshOrderListNotiAction:(NSNotification *)noti {
    //通知标记 是否要刷新
    for (NSString *keyStr in [noti.userInfo allKeys]) {
        [self.isHttpDic setValue:[noti.userInfo objectForKey:keyStr] forKey:keyStr];
    }
}

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentType = @"0";//默认类型为0，即待接单
    self.isHttpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"YES",@"0",@"YES",@"1",@"YES",@"3", nil];//首次进入肯定要请求数据
    
    //创建定时器。
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    //但是要先暂停
    [self.tempTimer setFireDate:[NSDate distantFuture]];
    
    // 让cell自适应高度
    self.orderListTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.orderListTableView.estimatedRowHeight = 44;
    
    /*
    
    NSMutableArray *dataSourceArr = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        OrderListModel *tempModel = [[OrderListModel alloc] init];
        tempModel.orderTitleStr = [NSString stringWithFormat:@"标题一 == %d",i];
        tempModel.orderTimeCount = arc4random()%10+10;
        tempModel.isCountDown = YES;
        tempModel.tempIndex = [NSIndexPath indexPathForRow:0 inSection:i];
        [dataSourceArr addObject:tempModel];
    }
    
    NSMutableArray *dataSourceArr2 = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        OrderListModel *tempModel = [[OrderListModel alloc] init];
        tempModel.orderTitleStr = [NSString stringWithFormat:@"标题二 == %d",i];
        tempModel.orderTimeCount = arc4random()%10+30;
        tempModel.isCountDown = YES;
        tempModel.tempIndex = [NSIndexPath indexPathForRow:0 inSection:i];
        [dataSourceArr2 addObject:tempModel];
    }

    [self.orderListDataSourceDic setValue:@{@"page":@"1",@"list":dataSourceArr} forKey:@"0"];
    [self.orderListDataSourceDic setValue:@{@"page":@"1",@"list":dataSourceArr2} forKey:@"1"];

     */
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //请求列表数据
    if ([[self.isHttpDic objectForKey:self.currentType] isEqualToString:@"YES"]) {
        //需要请求数据
        [self httpSupplyListWithStatus:self.currentType withPages:1];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    //页面消失，定时器释放
    [self.tempTimer invalidate];

}

#pragma mark - 网络请求数据源 -
- (NSMutableDictionary *)orderListDataSourceDic {
    if (_orderListDataSourceDic == nil) {
        self.orderListDataSourceDic = [NSMutableDictionary dictionary];
    }
    return _orderListDataSourceDic;
}

//网络请求
- (void)httpSupplyListWithStatus:(NSString *)status withPages:(NSInteger)page {
    Manager *manager = [Manager shareInstance];
    
    [manager httpOrderListWithAFID:manager.memberInfoModel.l_s_id withAStatus:status withPageIndex:page withOrderListSuccess:^(id successResult) {
        //模型赋值
        [self.orderListDataSourceDic setValue:successResult forKey:status];
        
        
        //请求成功后，将对应的isHttpDic变为NO
        [self.isHttpDic setObject:@"NO" forKey:status];
        
        //刷新列表
        [self.orderListTableView reloadData];
        //请求成功，开启定时器
        [self.tempTimer setFireDate:[NSDate distantPast]];
        
    } withOrderListFail:^(NSString *failResultStr) {
        
    }];

}



#pragma mark - 定时器方法 -
//定时器触发方法
- (void)timerAction:(NSTimer *)timer{
    
    self.isTimerRun = NO;//假定不需要倒计时了
    //创建刷新cellIndex数组
    NSMutableArray *reloadArr = [NSMutableArray array];
    //遍历字典内的所有模型
    for (NSString *tempKey in self.orderListDataSourceDic.allKeys) {
        if (![tempKey isEqualToString:@"3"]) {//已完成 没有倒计时
            //得到数组
            NSMutableArray *dataSourceArr = [[self.orderListDataSourceDic objectForKey:tempKey] objectForKey:@"list"];
            
            //修改数据源
            for (OrderListModel *tempModel in dataSourceArr) {
                //遍历数组，如果这个模型需要倒计时，就做操作
                if (tempModel.isCountDown == YES) {
                    //如果现在遍历的类型是展示的类型，那么就将这个index加到数组中
                    if ([self.currentType isEqualToString:tempKey]) {
                        [reloadArr addObject:tempModel.tempIndex];
                    }
                    //自减
                    tempModel.orderTimeCount--;
                    self.isTimerRun = YES;//由于自减了，标记定时器在启动
                    if (tempModel.orderTimeCount == 0) {
                        //自减后如果已经归零，那么就标记一下这个模型不用倒计时了
                        tempModel.isCountDown = NO;
                    }
                }
            }
        }
    }

    //如果标记的定时器正在运行，那么有可能就要刷新cell
    if (self.isTimerRun == YES ) {
        //倒计时正在运行，且刷新数组有内容，就刷新
        if (reloadArr.count > 0) {
            NSLog(@" %@ -- 刷新%@",self.currentType,reloadArr[0]);
            
            [self.orderListTableView reloadRowsAtIndexPaths:reloadArr withRowAnimation:UITableViewRowAnimationNone];
//            [self.orderListTableView reloadData];
            
        }

    }else{
        //如果标记的倒计时停止了，那么就让定时器停止
        NSLog(@"暂停");
        //暂停定时器
        [self.tempTimer setFireDate:[NSDate distantFuture]];
    }
    
}


#pragma mark - 头部三个分类按钮 -
- (IBAction)btnOneAction:(LineButton *)sender {
    
    if (![self.currentType isEqualToString:@"0"]) {
        self.currentType = @"0";
        //改变颜色
        [self.headOneButton setColor:kMainColor];
        [self.headTwoButton setColor:[UIColor clearColor]];
        [self.headThreeButton setColor:[UIColor clearColor]];
        
        [self.headOneButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.headTwoButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.headThreeButton setTitleColor:k333333Color forState:UIControlStateNormal];
        
        NSLog(@"%@",[self.isHttpDic objectForKey:@"0"]);
        
        
        //请求信息。查看一下原来有没有信息，是否要刷新
        if ([self.orderListDataSourceDic objectForKey:@"0"] == nil || [[self.isHttpDic objectForKey:@"0"] isEqualToString:@"YES"]) {
            [self httpSupplyListWithStatus:self.currentType withPages:1];
        }else {
            [self.orderListTableView reloadData];
        }
        
        
    }

    
}
- (IBAction)btnTwoAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"1"]) {
        self.currentType = @"1";
        //改变颜色
        [self.headOneButton setColor:[UIColor clearColor]];
        [self.headTwoButton setColor:kMainColor];
        [self.headThreeButton setColor:[UIColor clearColor]];
        
        [self.headOneButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.headTwoButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [self.headThreeButton setTitleColor:k333333Color forState:UIControlStateNormal];
        
        //请求信息。查看一下原来有没有信息
        if ([self.orderListDataSourceDic objectForKey:@"1"] == nil || [[self.isHttpDic objectForKey:@"1"] isEqualToString:@"YES"]) {
            [self httpSupplyListWithStatus:self.currentType withPages:1];
        }else {
            [self.orderListTableView reloadData];
        }
    }
}
- (IBAction)btnThreeAction:(LineButton *)sender {
    if (![self.currentType isEqualToString:@"3"]) {
        self.currentType = @"3";
        //改变颜色
        [self.headOneButton setColor:[UIColor clearColor]];
        [self.headTwoButton setColor:[UIColor clearColor]];
        [self.headThreeButton setColor:[UIColor redColor]];
        
        [self.headOneButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.headTwoButton setTitleColor:k333333Color forState:UIControlStateNormal];
        [self.headThreeButton setTitleColor:kMainColor forState:UIControlStateNormal];
        
        //请求信息。查看一下原来有没有信息
        if ([self.orderListDataSourceDic objectForKey:@"3"] == nil || [[self.isHttpDic objectForKey:@"3"] isEqualToString:@"YES"]) {
            [self httpSupplyListWithStatus:self.currentType withPages:1];
        }else {
            [self.orderListTableView reloadData];
        }
    }
}

#pragma mark - tableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *orderListArr = [[self.orderListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    return orderListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //找到对应的模型
    NSMutableArray *orderListArr = [[self.orderListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    OrderListModel *tempModel = orderListArr[indexPath.section];
    //头部
    if (indexPath.row == 0) {
        //头部cell
        OrderListHeaderTableViewCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"orderListHeadCell" forIndexPath:indexPath];
        [headCell updateOrderListHeaderCellWithModel:tempModel withType:self.currentType];
        return headCell;
    }
    
    //中间部分
    if (indexPath.row == 1) {
        if ([self.currentType isEqualToString:@"0"] || [self.currentType isEqualToString:@"3"]) {
            OrderListOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"orderListOneCell" forIndexPath:indexPath];
            [cellOne updateOrderOneCellWithModel:tempModel];
            
            return cellOne;

        }else {
            OrderListTwoTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"orderListTwoCell" forIndexPath:indexPath];
            [cellTwo updateOrderTwoCellWithModel:tempModel];
            return cellTwo;

        }
        
    }
    
    //尾部
    if (indexPath.row == 2) {
        //尾部cell
        OrderListFootOneTableViewCell *footCell = [tableView dequeueReusableCellWithIdentifier:@"orderListFootOneCell" forIndexPath:indexPath];
        [footCell updateOrderCellWithModel:tempModel withType:self.currentType withCellIndex:indexPath];
        return footCell;
    }
    
    
    
    return 0;
}

#pragma mark - cell底部的按钮 -
- (IBAction)bottomButtonAction:(IndexButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    NSLog(@"%ld",sender.btnIndex.section);
    //找到对应的模型
    NSMutableArray *orderListArr = [[self.orderListDataSourceDic objectForKey:self.currentType] objectForKey:@"list"];
    OrderListModel *tempModel = orderListArr[sender.btnIndex.section];
    
    //接单
    if ([self.currentType isEqualToString:@"0"]) {
        
        [alertM showAlertViewWithTitle:@"是否要接单" withMessage:nil actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            if (actionBlockNumber == 1) {
                [self orderOrdersAction:tempModel];
            }
        }];
        
    }
    //发货
    if ([self.currentType isEqualToString:@"1"]) {
        [self performSegueWithIdentifier:@"orderListToSendDetailVC" sender:tempModel];

    }
    
    if ([self.currentType isEqualToString:@"3"]) {
        //查看发货单
        [self performSegueWithIdentifier:@"sendListToSendCerVC" sender:tempModel];
    }

}


#pragma mark - 接单 -
- (void)orderOrdersAction:(OrderListModel *)tempModel {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    [manager httpOrdersWithAId:tempModel.orderId withOrdersSuccess:^(id successResult) {
        [alertM showAlertViewWithTitle:@"恭喜你，接单成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            
            //接单成功，要请求刷新 待接单列表，和 标记待发货要刷新
            [self httpSupplyListWithStatus:self.currentType withPages:1];
            
            //标记待发货要刷新
            [self.isHttpDic setValue:@"YES" forKey:@"1"];
            
            
        }];
        
    } withOrdersFail:^(NSString *failResultStr) {
        [alertM showAlertViewWithTitle:@"接单失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
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
    if ([segue.identifier isEqualToString:@"orderListToSendDetailVC"]) {
        SendDetailViewController *sendDetailVC = [segue destinationViewController];
        sendDetailVC.tempOrderListModel = sender;
    }
    
    if ([segue.identifier isEqualToString:@"sendListToSendCerVC"]) {
        SendCerViewController *sendCerVC = [segue destinationViewController];
        sendCerVC.tempOrderListModel = sender;
    }
}


@end
