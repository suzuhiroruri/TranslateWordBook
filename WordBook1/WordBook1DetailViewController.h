//
//  WordBook1DetailViewController.h
//  WordBook1
//
//  Created by Hiromasa Suzuki on 13/07/28.
//  Copyright (c) 2013年 Hiromasa Suzuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface WordBook1DetailViewController : UIViewController
<
UITextFieldDelegate // 単語編集用
>

@property(nonatomic,retain) IBOutlet UITextField *aTextField;

@property (nonatomic,retain) IBOutlet UILabel *englishLabel;
@property (nonatomic,retain) IBOutlet UILabel *germanLabel;
@property (nonatomic,retain) IBOutlet UILabel *frenchLabel;
@property (nonatomic,retain) IBOutlet UILabel *koreanLabel;

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property(nonatomic,assign) NSInteger fileIdx;

-(IBAction)translateSave:(id)sender;
// データ番号を指定して、該当するデータファイルのパスを算出する
+ (NSString *)makeDataFilePath:(NSInteger)idx;

@end
