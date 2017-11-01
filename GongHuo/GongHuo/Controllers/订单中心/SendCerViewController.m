//
//  SendCerViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/25.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SendCerViewController.h"
#import "Manager.h"
#import "UIImageView+ImageViewCategory.h"
@interface SendCerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *sendCerImgeView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation SendCerViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];
    //查看发货单接口
    [manager httpOrderInvoiceWithAid:self.tempOrderListModel.orderId withInvoiceSuccess:^(id successResult) {
        /* 返回值
         "A_TIME_CREATE":"25-SEP-17",
         "A_DEILVERY_ENDTIME":"27-SEP-17",
         "A_TIME_END":"25-SEP-17",
         "A_T_ID":"0",
         "A_END":"1",
         "A_F_UID":"60C236F4B528445F80CA00EB58F36146",
         "A_ACTURAL_TIME":"25-SEP-17",
         "A_DEILVERY_TIME":"25-SEP-17",
         "A_IS_TRANSFER":"0",
         "A_STATUS":"3",
         "A_ID":"E9860EA2858A4D24B81BE330C8BDE188",
         "A_O_ID":"F1611A4740E24646BE198976650988B7",
         "A_NOTE":"123",
         "A_FILE":"20179/9/E5B93C5CFCA94E30B6C501BC4DCA7F4B.jpg",
         "A_F_ID":"2205"
         */
        [self.sendCerImgeView setWebImageURLWithImageUrlStr:[successResult objectForKey:@"A_FILE"] withErrorImage:nil withIsCenter:YES];
        self.remarkLabel.text = [successResult objectForKey:@"A_NOTE"];
        
    } withInvoiceFail:^(NSString *failResultStr) {
        
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
