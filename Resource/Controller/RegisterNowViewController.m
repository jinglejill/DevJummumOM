//
//  RegisterNowViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 2/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RegisterNowViewController.h"
#import "CustomTableViewCellText.h"
#import "UserAccount.h"


@interface RegisterNowViewController ()
{
    UserAccount *_userAccount;
    BOOL _validate;
    UIToolbar *_toolBar;
}
@end

@implementation RegisterNowViewController
static NSString * const reuseIdentifierText = @"CustomTableViewCellText";


@synthesize tbvData;
@synthesize dtPicker;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if(textField.tag == 4)
    {
        NSString *strDate = textField.text;
        if([strDate isEqualToString:@""])
        {
            NSInteger year = [[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy"] integerValue];
            NSString *strDefaultDate = [NSString stringWithFormat:@"01/01/%ld",year-20];
            NSDate *datePeriod = [Utility stringToDate:strDefaultDate fromFormat:@"dd/MM/yyyy"];
            [dtPicker setDate:datePeriod];
        }
        else
        {
            NSDate *datePeriod = [Utility stringToDate:strDate fromFormat:@"d MMM yyyy"];
            [dtPicker setDate:datePeriod];
        }
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:4];
    if([textField isFirstResponder])
    {
        textField.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
        _userAccount.birthDate = dtPicker.date;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            _userAccount.username = [Utility trimString:textField.text];
            _userAccount.email = [Utility trimString:textField.text];
        }
            break;
        case 2:
        {
            _userAccount.password = [Utility trimString:textField.text];
        }
            break;
        case 3:
        {
            _userAccount.fullName = [Utility trimString:textField.text];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _userAccount = [[UserAccount alloc]init];
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    
    _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [_toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideDatePicker)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [_toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierText bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierText];
    }
}
///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    

    CustomTableViewCellText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierText];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (item)
    {
        case 0:
        {
            cell.textValue.tag = 1;
            cell.textValue.delegate = self;
            cell.textValue.placeholder = @"อีเมล";
            cell.textValue.text = _userAccount.username;
        }
            break;
        case 1:
        {
            cell.textValue.tag = 2;
            cell.textValue.delegate = self;
            cell.textValue.placeholder = @"พาสเวิร์ด";
            cell.textValue.text = _userAccount.password;
            cell.textValue.secureTextEntry = YES;
        }
            break;
        case 2:
        {
            cell.textValue.tag = 3;
            cell.textValue.delegate = self;
            cell.textValue.placeholder = @"ชื่อเต็ม";
            cell.textValue.text = _userAccount.fullName;
        }
            break;
        case 3:
        {
            cell.textValue.tag = 4;
            cell.textValue.delegate = self;
            cell.textValue.placeholder = @"วันเกิด";
            cell.textValue.inputView = dtPicker;
            cell.textValue.text = [Utility dateToString:_userAccount.birthDate toFormat:@"dd/MM/yyyy"];
            [cell.textValue setInputAccessoryView:_toolBar];
        }
            break;
        default:
            break;
    }
    
    
    
    
    cell.textLabel.text = @"กรอกบัตรเครดิต";
    cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

//-(void)validate
//{
//    
//
////    [self loadingOverlayView];
//
//}

- (IBAction)createAccount:(id)sender
{
//    [self validate];
    [self loadingOverlayView];

    [self.homeModel downloadItems:dbUserAccount withData:_userAccount.username];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items
{
    [self removeOverlayViews];
    
    
    //validate
    if(![Utility validateEmailWithString:_userAccount.username])
    {
//        _validate = NO;
        [self showAlert:@"" message:@"กรุณาระบุอีเมล"];
        return;
    }
    
    
    if([items count] > 0 && [items[0] count]>0)
    {
        [self showAlert:@"" message:@"อีเมลนี้ถูกใช้แล้ว"];
        return;
    }
    
    
    if(![Utility validateStrongPassword:_userAccount.password])
    {
        [self showAlert:@"" message:@"พาสเวิร์ดต้องประกอบไปด้วย 1.อักษรตัวเล็กอย่างน้อย 1 ตัว\n2.อักษรตัวใหญ่อย่างน้อย 1 ตัว\n3.ตัวเลขหรืออักษรพิเศษอย่างน้อย 1 ตัว\n4.ความยาวขั้นต่ำ 8 ตัวอักษร"];
        return ;
    }
    
    
    if([Utility isStringEmpty:_userAccount.fullName])
    {
        [self showAlert:@"" message:@"กรุณาระบุชื่อเต็ม"];
        return;
    }
    
    
    if([_userAccount.birthDate isEqual:[Utility notIdentifiedDate]])
    {
        [self showAlert:@"" message:@"กรุณาระบุวันเกิด"];
        return;
    }
    //-----
    
    
    UserAccount *userAccount = [[UserAccount alloc]initWithUsername:_userAccount.username password:[Utility hashTextSHA256:_userAccount.password] deviceToken:[Utility deviceToken] fullName:_userAccount.fullName nickName:@"" birthDate:_userAccount.birthDate email:_userAccount.email phoneNo:@"" lineID:@"" roleID:0];
    [self.homeModel insertItems:dbUserAccount withData:userAccount actionScreen:@"create new account"];
    [self loadingOverlayView];
}

-(void)itemsInserted
{
    [self removeOverlayViews];
    [self showAlert:@"" message:@"สร้างบัญชีสำเร็จ" method:@selector(segUnwindToLogIn)];
}

-(void)segUnwindToLogIn
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

-(void)hideDatePicker
{
    [dtPicker removeFromSuperview];
    [_toolBar removeFromSuperview];
    UITextField *txtBirthDate = [self.view viewWithTag:4];
    [txtBirthDate resignFirstResponder];
}
@end
