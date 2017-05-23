//
//  ViewController.m
//  CS4962ServerInteraction
//
//  Created by WENGzhang on 14/05/2017.
//  Copyright © 2017 WENGzhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, atomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *urlArray;
@property NSString *cellId;
@end

@implementation ViewController
@dynamic view;



- (void)loadView {
    self.view = [[UICollectionView alloc] initWithFrame: UIScreen.mainScreen.bounds collectionViewLayout: [[UICollectionViewFlowLayout alloc] init]];
    _collectionView = (UICollectionView*)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellId = @"cellId";
    [self.collectionView setContentInset: UIEdgeInsetsMake(NSLayoutAttributeTopMargin, 0, 0, 0)];
    [self.collectionView setDataSource: self];
    [self.collectionView setDelegate: self];

    [self.collectionView registerClass: UICollectionViewCell.self forCellWithReuseIdentifier: self.cellId];
    [self initImageArray];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.collectionView setDataSource: nil];
    [self.collectionView setDelegate: nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
   
}

- (void)dealloc {
    NSLog(@"deallocated");
}

- (void)initImageArray {
    if (_imageArray == NULL) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    if (_urlArray == NULL) {
        _urlArray = [[NSMutableArray alloc] init];
    }
    NSString *string = ([_urlString  isEqual: @""] ? @"https://www.nytimes.com" : _urlString);
    NSURL* url = [[NSURL alloc] initWithString: string];
    
    //NSURLConnection* connection = [NSURLConnection alloc] initWithRequest:<#(nonnull NSURLRequest *)#> delegate:<#(nullable id)#>];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL: url];
    
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@",response);
        
        if (connectionError != nil) return;
        
        NSString* stringData = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        [self populateImageArrayByRegex:stringData];
    }];
    
}

- (void)populateImageArrayByRegex:(NSString *)stringData {
    
    NSString *pattern = @"src=\"(https?:\\/\\/.*?\\.(?:png|jpg|gif))";
    NSError* error = nil;
    NSRange rangeOfString = NSMakeRange(0, [stringData length]);
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSArray *matchs = [regex matchesInString: stringData options:0 range:rangeOfString];
    for (NSTextCheckingResult* match in matchs) {
        NSLog(@"url: %@", [stringData substringWithRange:[match rangeAtIndex:1]]);
        NSString *addedString = [stringData substringWithRange:[match rangeAtIndex:1]];
        [_urlArray addObject: addedString];
    }
    
    NSURLSession *session = NSURLSession.sharedSession;
    
    for (NSString *urlString in _urlArray) {
        NSURL *url = [[NSURL alloc] initWithString: urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        [[session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage* image = [UIImage imageWithData: data];
            if (image != nil) {
                [_imageArray addObject:image];
            }
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
        }] resume];
    }
    
    
}

- (void)populateImageArray:(NSString *)httpString {
    NSString *stringData = httpString;
    for(;;){
        
        NSRange startRange = [stringData rangeOfString: @"<img src=\""];
        if (startRange.location == NSNotFound) {
            NSLog(@"search out of range");
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
            return;
        }
        NSString* subString = [stringData substringFromIndex:startRange.location + startRange.length];
        NSRange endRange = [subString rangeOfString: @"\""];
        NSRange findRange;
        findRange.length = endRange.location;
        findRange.location = startRange.location + startRange.length;
        NSString* imgURLString = [stringData substringWithRange: findRange];
        
        NSLog(@"imgURLString is %@",imgURLString);
        
        NSURL* imgURL = [[NSURL alloc] initWithString: imgURLString];
        UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgURL]];
        if (image != nil) {
            [_imageArray addObject:image];
        }
        stringData = [stringData substringFromIndex:startRange.location + startRange.length + findRange.length];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.cellId forIndexPath:indexPath];
    UIImage* image = _imageArray[indexPath.item];
    UIImageView* view = [[UIImageView alloc] initWithImage:image];
    for (UIView* view in [[cell contentView] subviews]) {
        [view removeFromSuperview];
    };
    [cell.contentView addSubview:view];
    [cell setClipsToBounds: YES];
    return cell;
}
@end
