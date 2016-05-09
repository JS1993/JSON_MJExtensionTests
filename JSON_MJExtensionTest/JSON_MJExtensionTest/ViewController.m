//
//  ViewController.m
//  JSON_MJExtensionTest
//
//  Created by  江苏 on 16/5/9.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"
#import "VideoModel.h"
#import "MJExtension.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray* videos;

@property(nonatomic,strong)UITableView* tableView;

@end

@implementation ViewController

-(UITableView *)tableView
{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    
    [VideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    
    NSString* urlStr=@"http://120.25.226.186:32812/video";
    
    NSURL* url=[NSURL URLWithString:urlStr];
    
    NSURLRequest* request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        self.videos=[VideoModel mj_objectArrayWithKeyValuesArray:dict[@"videos"]];
        
        NSLog(@"%@ ",[self.videos[0] name]);
        
        [self.tableView reloadData];
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.videos.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* ID=@"cell";
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    VideoModel* video=self.videos[indexPath.row];
    
    NSString* urlString=[@"http://120.25.226.186:32812/video" stringByAppendingPathComponent:video.image];
    
    NSLog(@"%@",urlString);
    
    NSURL* url=[NSURL URLWithString:urlString];
    
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeHoldes"] options:0];
    
    cell.textLabel.text=video.name;
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"时长：%ld",(long)video.length];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoModel* video=self.videos[indexPath.row];
    
    NSString* urlString=[@"http://120.25.226.186:32812/video" stringByAppendingPathComponent:video.url];
    
    NSURL* url=[NSURL URLWithString:urlString];
    
    MPMoviePlayerViewController* mpVC=[[MPMoviePlayerController alloc]initWithContentURL:url];
    
    [self presentViewController:mpVC animated:YES completion:nil];
}
@end
