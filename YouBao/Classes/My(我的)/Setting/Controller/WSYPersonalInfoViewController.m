//
//  WSYPersonalInfoViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/28.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYPersonalInfoViewController.h"

// Controllers
#import "WSYCityPickerViewController.h"
// Models
#import "WSYInfoModel.h"
// Views
#import "WSYInfoCell.h"
#import "ACEExpandableTextCell.h"
//Categories
#import "WRNavigationBar.h"
#import "UIImageView+LBBlurredImage.h"
// Vendors
#import <BRPickerView/BRPickerView.h>
#import "TZImagePickerController.h"



#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)


@interface WSYPersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,ACEExpandableTableViewDelegate,WSYCityPickerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>{
    CGFloat _cellHeight[1];
}

@property (nonatomic, strong) WSYInfoModel *infoModel;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *cellData;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIButton *headBtn;

@property (nonatomic, copy) dispatch_block_t headBtnClickBlock;

@end

@implementation WSYPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.cellData = [NSMutableArray arrayWithArray:@[@""]];
    [self setupUI];
    [self bindUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 设置界面
 */
- (void)setupUI {
    self.navigationItem.title = @"设置个人资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
    [self.tableView addSubview:self.headImageView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.headImageView addSubview:self.headBtn];
    @weakify(self);
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.centerX.equalTo(self.headImageView);
        make.bottom.equalTo(self.headImageView).offset(-30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    [self.headImageView addSubview:self.portraitImageView];
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.centerX.equalTo(self.headImageView);
        make.bottom.equalTo(self.headImageView).offset(-110);
        make.width.height.mas_equalTo(60);
    }];
}


/**
 绑定UI
 */
- (void)bindUI {
    @weakify(self);
    [[self.headBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self clickImagePickerVc:@"headBG"];
    }];

    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:SELECT_BGIMAGE_NOTICE object:nil]subscribeNext:^(NSNotification *notice){
        @strongify(self);
        NSMutableArray *array = [NSMutableArray arrayWithArray:notice.object];
        self.headImageView.image = array[0];
    }];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]init];
    [[recognizer rac_gestureSignal]subscribeNext:^(id x){
        @strongify(self);
        [self clickImagePickerVc:@"portraitImage"];
    }];
    recognizer.delegate = self;
    [self.portraitImageView addGestureRecognizer:recognizer];

    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:SELECT_PORTRAITIMAGE_NOTICE object:nil]subscribeNext:^(NSNotification *notice){
        @strongify(self);
        NSMutableArray *array = [NSMutableArray arrayWithArray:notice.object];
        self.portraitImageView.image = array[0];
    }];
}

#pragma mark ============点击事件============
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickImagePickerVc:(NSString *)str {
    //    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    [WRNavigationBar wr_setDefaultNavBarTintColor:Color_Wathet];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.statusBarStyle = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.barItemTextColor = Color_Wathet;
    //    // 设置竖屏下的裁剪尺寸
    //    NSInteger left = 30;
    //    NSInteger widthHeight = self.view.wsy_width - 2 * left;
    //    NSInteger top = (self.view.wsy_height - widthHeight) / 2;
    //    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if ([str isEqualToString:@"headBG"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:SELECT_BGIMAGE_NOTICE object:photos];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:SELECT_PORTRAITIMAGE_NOTICE object:photos];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark ============UITableViewDataSource============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        static NSString *cellIdentifierID = @"cellId";
        ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:cellIdentifierID];
        if (!cell) {
            cell = [[ACEExpandableTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierID];
        }
        cell.text = self.cellData[0];
        cell.textView.placeholder = @"请输入个性签名";
        return cell;
    } else {
        static NSString *cellID = @"Cell";
        WSYInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WSYInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }

        cell.titleLabel.text = self.titleArr[indexPath.row];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        switch (indexPath.row) {
            case 0:
            {
                cell.isNeed = YES;
                cell.textField.placeholder = @"请输入昵称";
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.text = self.infoModel.nameStr;
            }
                break;
            case 1:
            {
                cell.isNeed = YES;
                cell.textField.placeholder = @"请选择性别";
                cell.textField.text = self.infoModel.genderStr;
            }
                break;
            case 2:
            {
                cell.isNeed = YES;
                cell.textField.placeholder = @"请选择常住地";
                cell.textField.text = self.infoModel.addressStr;
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

#pragma mark ============UITableViewDelegate============

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  indexPath.row == 3 ? MAX(60.0, _cellHeight[indexPath.section]) : 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath {
    _cellHeight[indexPath.section] = height;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath {
    [_cellData replaceObjectAtIndex:indexPath.section withObject:text];
}

#pragma mark ============UIScrollViewDelegate============

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > - IMAGE_HEIGHT)
    {
        CGFloat alpha = (offsetY + IMAGE_HEIGHT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        [self wr_setNavBarTintColor:[UIColor blackColor]];
        [self wr_setNavBarTitleColor:[UIColor blackColor]];
        self.navigationItem.rightBarButtonItem.tintColor = Color_Wathet;
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [self wr_setNavBarTitleColor:[UIColor whiteColor]];

    }

    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }

    // 改变图片框的大小 (上滑的时候不改变)
    // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (-IMAGE_HEIGHT >= newOffsetY)
    {
        self.headImageView.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }
}

#pragma mark ============UITextFieldDelegate============

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 3) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 3) {
        [textField addTarget:self action:@selector(handlerTextFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        return YES; // 当前 textField 可以编辑
    } else {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO; // 当前 textField 不可编辑，可以响应点击事件
    }
}

- (void)handlerTextFieldEndEdit:(UITextField *)textField {
    NSLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 0:
        {
            self.infoModel.nameStr = textField.text;
        }
            break;
        case 3:
        {
            self.infoModel.signStr = textField.text;
        }
            break;
            
        default:
            break;
    }
}

- (void)handlerTextFieldSelect:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
        {
            [BRStringPickerView showStringPickerWithTitle:@"性别" dataSource:@[@"男", @"女", @"保密"] defaultSelValue:textField.text resultBlock:^(id selectValue) {
                textField.text = self.infoModel.genderStr = selectValue;
            }];
        }
            break;
        case 2:
        {
            WSYCityPickerViewController *vc = [WSYCityPickerViewController new];
            vc.delegate = self;
            vc.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
            [self presentViewController:vc animated:YES completion:nil];
        }
        default:
            break;
    }
}


#pragma mark ============WSYCityPickerDelegate============

- (void)cityPickerController:(WSYCityPickerViewController *)cityPickerViewController didSelectCity:(WSYCityModel *)city {
    self.infoModel.addressStr = city.cityName;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ============懒加载============

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT}];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"M_personalBG"];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UIImageView *)portraitImageView {
    if (_portraitImageView == nil) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT}];
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds = YES;
        _portraitImageView.image = [UIImage imageNamed:@"M_personalBG"];
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.layer.cornerRadius = 30;
    }
    return _portraitImageView;
}

- (UIButton *)headBtn {
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setTitle:@"设置背景" forState:UIControlStateNormal];
        _headBtn.layer.borderWidth = 2;
        _headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_headBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _headBtn.titleLabel.font = WSYFont(14);
        _headBtn.layer.cornerRadius = 5;
    }
    return _headBtn;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"昵称", @"性别", @"常住地"];
    }
    return _titleArr;
}

- (WSYInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[WSYInfoModel alloc]init];
    }
    return _infoModel;
}

@end
