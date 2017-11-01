//
//  Manager.h
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceManager.h"
#import "NetManager.h"
#import "UploadProductModel.h"
#import "ProductClassModel.h"
#import "DosageModel.h"
#import "MemberInfoModel.h"
#import "CheckListModel.h"
#import "AlertManager.h"
#import "SupplyListModel.h"
#import "OrderListModel.h"
#import "UserListModel.h"
#import "NewsModel.h"

#import "SVProgressHUD.h"
typedef void(^SuccessResult)(id successResult);
typedef void(^FailResult)(NSString *failResultStr);

@interface Manager : NSObject
//个人用户
@property (nonatomic,strong)MemberInfoModel *memberInfoModel;

//地区树
@property(nonatomic,strong)NSArray *areaTree;


+ (Manager *)shareInstance;
#pragma mark - 审核中心 -
//审核中心列表 A_STATUS_CHECK：审核状态 0待审核 1通过 2未通过，
- (void)httpCheckListWithA_SP_ID:(NSString *)a_sp_id withMobile:(NSString *)mobile withStatus:(NSString *)status withIsAdmin:(NSString *)isAdmin withUserID:(NSString *)userid withPageIndex:(NSInteger)pageIndex withCheckListSuccess:(SuccessResult)checkListSuccess withCheckListFail:(FailResult)checkListFail;

//产品详情
- (void)httpProductInfoWithAID:(NSString *)aid withProductInfoSuccess:(SuccessResult)infoSuccess withProductInfoFail:(FailResult )infoFail;

//产品分类
- (void)httpProductClassWithClassSuccess:(SuccessResult)classSuccess withClassFail:(FailResult)classFail;

//产品添加
- (void)addProductWithUploadProductModel:(UploadProductModel *)uploadModel withMemberInfo:(MemberInfoModel *)memberInfo withAddProductSuccess:(SuccessResult)addSuccess withAddProductFail:(FailResult)addFail;

//产品编辑
- (void)editProductWithUploadProductModel:(UploadProductModel *)uploadModel withMemberInfo:(MemberInfoModel *)memberInfo withEditProductSuccess:(SuccessResult)addSuccess withEditProductFail:(FailResult)addFail;

//判断产品能否上传
- (void)httpCheckAccordUploadWithASpId:(NSString *)a_sp_id withCheckAccordSuccess:(SuccessResult )checkAccordSuccess withCheckAccordFail:(FailResult )checkAccordFail ;

#pragma mark - 供货中心 -
//供货中心列表和详情
- (void)httpSupplyListWithDFID:(NSString *)d_f_id withStatusCheck:(NSString *)a_status_check withSid:(NSString *)s_id withAid:(NSString *)a_id withPageIndex:(NSInteger)pageIndex withSupplyListSuccess:(SuccessResult )supplyListSuccess withSupplyListFail:(FailResult)supplyListFail ;

//供货中心的产品编辑
- (void)httpEditSupplyProductWithModel:(SupplyListModel *)productModel withMemberInfo:(MemberInfoModel *)memberInfo withEditType:(NSString *)editType withNewPrice:(NSString *)newPrice withNewInventory:(NSString *)newInventory withShelfInt:(NSString *)shelfInt withShelfReason:(NSString *)shelfReason withEditSupplySuccess:(SuccessResult)editSupplySuccess withEditSupplyFail:(FailResult)editSupplyFail ;

//产品上架
- (void)httpSupplyShelvesWithAid:(NSString *)a_id withAUid:(NSString *)a_u_id withShelvesSuccess:(SuccessResult)shelvesSuccess withShelvesFail:(FailResult)shelvesFail;

//产品删除
- (void)httpSupplyDeleteWithAid:(NSString *)a_id withSupplyDeleteSuccess:(SuccessResult)supplyDeleteSuccess withSupplyDeleteFail:(FailResult)supplyDeleteFail;


//产品剂型
- (void)httpProductDosageWithDosageSuccess:(SuccessResult)dosageSuccess withDosageFail:(FailResult)dosageFail;

//修改记录中的删除
- (void)httpSupplyHiddenWithAid:(NSString *)a_id withHiddenSuccess:(SuccessResult)hiddenSuccess withHiddenFail:(FailResult)hiddenFail;


//是否有新订单
- (void)httpIsNewOrderWithAFID:(NSString *)a_f_id withIsNewSuccess:(SuccessResult)isNewSuccess withIsNewFail:(FailResult)isNewFail;

#pragma mark - 订单 -
//订单列表
- (void)httpOrderListWithAFID:(NSString *)a_f_id withAStatus:(NSString *)a_status withPageIndex:(NSInteger)pageIndex withOrderListSuccess:(SuccessResult)orderListSuccess withOrderListFail:(FailResult)orderListFail ;

//订单接单
- (void)httpOrdersWithAId:(NSString *)a_id withOrdersSuccess:(SuccessResult)ordersSuccess withOrdersFail:(FailResult)ordersFail;

//订单发货 A_ID列表中的id O_ID列表中的oid A_F_UID:"操作人id即是登陆人id" A_FILE:"发货单"
- (void)httpOrderDeliverWithAId:(NSString *)a_id withOId:(NSString *)o_id withToken:(NSString *)token withAFUid:(NSString *)a_f_uid withAFile:(NSString *)a_file withANote:(NSString *)a_note withDeliverSuccess:(SuccessResult)deliverSuccess withDeliverFail:(FailResult)deliverFail ;

//查看发货单
- (void)httpOrderInvoiceWithAid:(NSString *)a_id withInvoiceSuccess:(SuccessResult)invoiceSuccess withInvoiceFail:(FailResult)invoiceFail ;


#pragma mark - 人员管理 -
//人员管理列表
- (void)httpUserListWithASpId:(NSString *)a_sp_id withMobile:(NSString *)mobile withUserId:(NSString *)u_id withUserListSuccess:(SuccessResult)userListSuccess withUserListFail:(FailResult)userListFail ;

//人员添加
- (void)httpAddUserWithMemberInfo:(MemberInfoModel *)memberInfo withPostionType:(NSInteger )postionType withTureName:(NSString *)trueName withMobile:(NSString *)mobile withCardPeople:(NSString *)cardPeople withCard:(NSString *)card withAddUserSuccess:(SuccessResult)addUserSuccess withAddUserFail:(FailResult)addUserFail ;
//人员编辑
- (void)httpEditUserWithMemberInfo:(UserListModel *)userList withToken:(NSString *)token withPostionType:(NSInteger )postionType withTureName:(NSString *)trueName withMobile:(NSString *)mobile withCardPeople:(NSString *)cardPeople withCard:(NSString *)card withEditUserSuccess:(SuccessResult)editUserSuccess withEditUserFail:(FailResult)editUserFail ;

//是否允许添加老板
- (void)httpIsAddBossWithLsid:(NSString *)ls_Id withIsAddSuccess:(SuccessResult )isAddSuccess withIdAddFail:(FailResult)isAddFail;



#pragma mark - 登录 -
//判断登录与否
- (BOOL)isLoginStatus;
//登录
- (void)httpLoginWithMobile:(NSString *)mobile withPassword:(NSString *)password withLoginSuccess:(SuccessResult)loginSuccess withLoginFail:(FailResult)loginFail;

//退出登录
- (void)logOffAction ;
//将个人信息写到本地沙盒
- (BOOL)saveMemberInfoModelToLocationWithMemberInfo:(MemberInfoModel *)memberInfo;

#pragma mark - 注册 -
//验证推广人手机
- (void)httpPromoterWithMobile:(NSString *)mobile withPromoterSuccess:(SuccessResult)promoterSuccess withPromoterFail:(FailResult)promoterFail;


//门市列表
- (void)httpRetailListWithAreaId:(NSString *)areaId withRetailSuccess:(SuccessResult)retailSuccess withRetailFail:(FailResult)retailFail;

//市场列表
- (void)httpMarkListWithAreaId:(NSString *)areaId withMarkSuccess:(SuccessResult)markSuccess withMarkFail:(FailResult)markFail;

//添加门市 mid-市场id name-门市名称 developername-推广者手机 address-门市地址
- (void)httpAddShopWithMid:(NSString *)mid withName:(NSString *)name withDeveloperName:(NSString *)developerName withAreaid:(NSString *)areaId withAddress:(NSString *)address withAddShopSuccess:(SuccessResult)addShopSuccess withAddShopFail:(FailResult)addShopFail;

//注册 添加负责人
- (void)httpRegisterSupplyLeaderWithFuserId:(NSString *)fuserid withPassword:(NSString *)password withTruename:(NSString *)truename withMobile:(NSString *)mobile withAreaid:(NSString *)areaId withIsadmin:(NSString *)isadmin withRegisterSuccess:(SuccessResult)registerSuccess withRegisterFail:(FailResult)registerFail;

//检验这个手机号是否被注册
- (void)httpRegisterCheckPhoneWithMobile:(NSString *)mobile withCheckPhoneSuccess:(SuccessResult)checkPhoneSuccess withCheckPhoneFail:(FailResult)checkPhoneFail;

#pragma mark - 忘记密码 修改密码 -
//忘记密码
- (void)httpForgetPasswordWithMobile:(NSString *)mobile withPassword:(NSString *)password withForgetSuccess:(SuccessResult)forgetSuccess withForgetFail:(FailResult)forgetFail;

//修改密码
- (void)httpMotifyPasswordWithUserId:(NSString *)userId withPassword:(NSString *)password withMotifySuccess:(SuccessResult)motifySuccess withMotifyFail:(FailResult)motifyFail;


#pragma mark - 短信验证码 -
//发送短信验证码
- (void)httpSendMsgCodeWithMobile:(NSString *)mobile withSendMsgSuccess:(SuccessResult)sendMsgSuccess withSendMsgFail:(FailResult)sendMsgFail ;

//验证短信验证码
- (void)httpCheckMsgCodeWithMobile:(NSString *)mobile withMobileCode:(NSString *)mobileCode withCheckCodeSuccess:(SuccessResult)checkCodeSuccess withCheckCodeFail:(FailResult)checkCodeFail ;

#pragma mark - 消息 -
//消息列表
- (void)httpMyNewsListWithPageIndex:(NSInteger)pageIndex withNewsSuccess:(SuccessResult)newsSuccess withNewsFail:(FailResult)newsFail;
//消息详情
- (void)httpNewsDetailWithICode:(NSString *)i_code withNewsDetailSuccess:(SuccessResult)newsDetailSuccess withNewsDetailFail:(FailResult)newsDetailFail;

#pragma mark - 其他 -
//全国地区请求
- (void)httpAreaTreeWithAreaSuccess:(SuccessResult)areaSuccess withAreaFail:(FailResult)areaFail;
//删除图片
- (void)deleteImageWithDeleteImageUrl:(NSString *)imageUrl withToken:(NSString *)token withDeleteSuccess:(SuccessResult )deleteSuccess withDeleteFail:(FailResult)deleteFail  ;

//上传图片附件
- (void)uploadImageWithUploadImage:(UIImage *)uploadImage withUploadSuccess:(SuccessResult )uploadSuccess withUploadFail:(FailResult)uploadFail ;


//从本地读取个人信息数据
- (BOOL)readMemberInfoModelFromLocation ;


//截屏
-(UIImage *)screenShot ;

#pragma mark - 压缩 -
- (UIImage *)compressOriginalImage:(UIImage *)originalImage toMaxDataSizeKBytes:(CGFloat)size;

#pragma mark - 隐藏navigationBar -
//隐藏navigationBar下面的那条线
- (void)isClearNavigationBarLine:(BOOL )hideLine withNavigationController:(UINavigationController *)navi;
/**
 *  根据透明度去绘制一个图片，也可以省略此处用一个透明的图片，没这个效果好
 */
-(UIImage *)getImageWithAlpha:(CGFloat)alpha;

@end
