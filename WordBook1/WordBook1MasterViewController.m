//
//  WordBook1MasterViewController.m
//  WordBook1
//
//  Created by Hiromasa Suzuki on 13/07/28.
//  Copyright (c) 2013年 Hiromasa Suzuki. All rights reserved.
//

#import "WordBook1MasterViewController.h"

#import "WordBook1DetailViewController.h"

@interface WordBook1MasterViewController () {
}
@end

@implementation WordBook1MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}
#pragma mark - ファイル操作
// indexファイルのパスを算出する
- (NSString *)makeIndexFilePath {
    NSString *docFolder = [NSHomeDirectory()
                           stringByAppendingPathComponent:@"Documents"];
    NSString *indexFilePath = [NSString
                               stringWithFormat:@"%@/index.plist", docFolder];
    NSLog(@"%@",indexFilePath);
    return indexFilePath;
}

// indexファイルの load
-(void)loadIndexList {
    NSString *indexFilePath = [self makeIndexFilePath];
    if ( ! indexList ) {
        indexList = [[NSMutableArray alloc] init];
    }
    if ( [[NSFileManager defaultManager]
          fileExistsAtPath:indexFilePath] ) {
        [indexList setArray:[NSMutableArray
                             arrayWithContentsOfFile:indexFilePath]];
    }
}

// indexファイルの save
-(BOOL)saveIndexList {
    NSString *indexFilePath = [self makeIndexFilePath];
    return [indexList writeToFile:indexFilePath atomically:YES];
}
// indexファイルへ追加
-(BOOL)addIndexList:(NSInteger)fileIdx {
    NSNumber *number = [NSNumber numberWithInteger:fileIdx];
    [indexList insertObject:number atIndex:0];
    return [self saveIndexList];
}
// データファイルとして存在していないデータ番号を求める
-(NSInteger)makeUniqeDataIndex {
    NSString *uniquePath;
    int i=0;
    do {
        i=i+1;
        uniquePath = [WordBook1DetailViewController
                      makeDataFilePath:i];
    } while([[NSFileManager defaultManager]
             fileExistsAtPath:uniquePath]);
    return i;
}
// indexListのデータ番号に対応するデータファイルがないなら項目を削除する
-(void)validateIndexList {
    NSMutableArray *aryIgnore =
    [NSMutableArray arrayWithCapacity:0];
    NSNumber *n;
    for (n in indexList) {
        NSString *detailDataPath = [WordBook1DetailViewController
                                    makeDataFilePath:[n integerValue]];
        
        if (![[NSFileManager defaultManager]
              fileExistsAtPath:detailDataPath]) {
            [aryIgnore addObject:n];
        }
    }
    for (n in aryIgnore) {
        [indexList removeObject:n];
    }
}

#pragma mark - 「＋」ボタン
-(void)addWord {
	NSLog(@"＋ボタン");
    [self performSegueWithIdentifier:@"createDetail" sender:self];
}
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"単語帳", @"単語帳");
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addWord)];
    self.navigationItem.leftBarButtonItem = addButton;
    [self loadIndexList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self validateIndexList];
    [[self tableView] reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [indexList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSInteger cellIdx = [indexPath row];
    NSNumber *number = [indexList objectAtIndex:cellIdx];
    NSInteger fileIdx = [number integerValue];
    NSString *dataFilePath =
    [WordBook1DetailViewController makeDataFilePath:fileIdx];
    NSString* title = @"新規データ";
    
    if ( [[NSFileManager defaultManager]
          fileExistsAtPath:dataFilePath] == YES ) {
        NSMutableDictionary* dic = [NSMutableDictionary
                                    dictionaryWithContentsOfFile:dataFilePath];
        NSString* savedTitle = [dic valueForKey:@"SearchWord"];
        title = savedTitle;
    }
    [[cell textLabel] setText:title];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger cellIdx = [indexPath row];
        NSNumber *number = [indexList objectAtIndex:cellIdx];
        NSInteger fileIdx = [number integerValue];
        [[segue destinationViewController] setFileIdx:fileIdx];
    } else if ([[segue identifier] isEqualToString:@"createDetail"]) {
        NSInteger fileIdx = [self makeUniqeDataIndex];
        if ([self addIndexList:fileIdx] == FALSE) {
            NSLog(@"新規追加でindexファイルの保存ができませんでした");
            return;
        } else {
            NSLog(@"fileIdx:%d",fileIdx);
        }
        [[segue destinationViewController] setFileIdx:fileIdx];
    }
}

@end
