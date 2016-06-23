//
//  ViewController.m
//  zhengzeTest
//
//  Created by 杨小兵 on 15/9/18.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import "ViewController.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "Masonry.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property(nonatomic , weak)UIWebView *messageWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self zhengzeTest_ServersImage2String];
    //
    //    [self test];
        [self test1];
}





- (void)zhengzeTest_ServersImage2String
{
    NSString *checkString = @"[emoticons=E___0480ZH00SIG]赞[/emoticons],[emoticons=E___0305EN00SIG]美好[/emoticons]哈哈哈";
    NSMutableString *emotionsString = [checkString mutableCopy];
    NSError *error;
    NSString *pattern = @"\\[emoticons=E___([0-9a-zA-Z]*)](.*?)\\[\\/emoticons]";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regular matchesInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    int i = (int)[arrayOfAllMatches count];
    for (; i>0; i--)
    {
        NSTextCheckingResult *match = arrayOfAllMatches[i-1];
        NSString* substringForMatch = [checkString substringWithRange:match.range];
        NSLog(@"%d %@  ---> %@",i,substringForMatch,[self idOfemoticons:substringForMatch]);
        [emotionsString replaceCharactersInRange:match.range withString:@"["];
    }
    checkString = [emotionsString stringByReplacingOccurrencesOfString:@"[/emoticons]" withString:@"]" ];
    self.testLabel.text = checkString;
}




















- (void)zhengzeTest_ServersImage
{
    NSString *checkString = @"[emoticons=E___0480ZH00SIG]赞[/emoticons],[emoticons=E___0305EN00SIG]美好[/emoticons]哈哈哈";
    NSMutableString *htmlString = [checkString mutableCopy];
    NSError *error;
    NSString *pattern = @"\\[emoticons=E___([0-9a-zA-Z]*)](.*?)\\[\\/emoticons]";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regular matchesInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: checkString];
    int i = (int)[arrayOfAllMatches count];
    for (; i>0; i--)
    {
        NSTextCheckingResult *match = arrayOfAllMatches[i-1];
        NSString* substringForMatch = [checkString substringWithRange:match.range];
        NSLog(@"%d %@  ---> %@",i,substringForMatch,[self idOfemoticons:substringForMatch]);
        
        //NSAttachmentAttributeName 设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
        
        NSTextAttachment *textAttachment01 = [[NSTextAttachment alloc] init];
        textAttachment01.image = [UIImage imageNamed:@"icon"];  //设置图片源
        textAttachment01.bounds = CGRectMake(0, 0, 40, 40);     //设置图片位置和大小
        [attrStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 25] range: NSMakeRange(0, attrStr.length)];
        NSAttributedString *attrStr11 = [NSAttributedString attributedStringWithAttachment: textAttachment01];
        NSLog(@"++++%@",@(match.range.location));
        [attrStr insertAttributedString: attrStr11 atIndex: match.range.location];  //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
        NSRange range = match.range;
        range.location +=1;
        [attrStr replaceCharactersInRange:range withString:@""];
        
        [htmlString replaceCharactersInRange:match.range withString:[self htmlWithImageID:[self idOfemoticons:substringForMatch]]];
    }
    
    self.testLabel.attributedText = attrStr;
    NSLog(@"---->\n\n\n  html ---->\n%@\n",htmlString);
    
    [self.messageWebView loadHTMLString:[self htmlStringWithBodyString:htmlString] baseURL:nil];
}
- (NSString *)idOfemoticons:(NSString *)emoticons
{
    NSString *emoticonsID = @"";
    NSError *error;
    NSString *pattern = @"\\[emoticons=E___([0-9a-zA-Z]*)\\]";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regular matchesInString:emoticons options:NSMatchingReportProgress range:NSMakeRange(0, [emoticons length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        emoticonsID = [emoticons substringWithRange:match.range];
    }
    
    
    
    NSString *pattern2 = @"\\[emoticons=";
    NSRegularExpression *regular2 = [[NSRegularExpression alloc] initWithPattern:pattern2 options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches2 = [regular2 matchesInString:emoticons options:NSMatchingReportProgress range:NSMakeRange(0, [emoticonsID length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches2)
    {
        NSRange range;
        range.location = match.range.location + match.range.length;
        range.length = emoticonsID.length - match.range.length - 1;
        emoticonsID = [emoticonsID substringWithRange:range];
    }
    return emoticonsID;
}
- (NSString *)htmlStringWithBodyString:(NSString *)bodyString
{
    NSMutableString *html = [NSMutableString string];
    // 头部内容
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"</head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">", [[NSBundle mainBundle] URLForResource:@"NewsDetail.css" withExtension:nil]];
    [html appendString:@"</head>"];
    // 具体内容
    [html appendString:@"<body>"];
    [html appendFormat:@"<div class=\"title\">%@</div>", bodyString];
    [html appendString:@"</body>"];
    // 尾部内容
    [html appendString:@"</html>"];
    return html;
}
- (NSString *)htmlWithImageID:(NSString *)imageID
{
   NSString *urlString = [NSString stringWithFormat:@"<img src=\"http://www.sinaimg.cn/uc/myshow/blog/misc/gif/%@T.gif\" style=\"margin:1px;\" border=\"0\";width=\"40\" height=\"40\"/>",imageID];
    return urlString;
}
- (UIImage *)imageWithImageID:(NSString *)imageID
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.sinaimg.cn/uc/myshow/blog/misc/gif/%@T.gif",imageID];
    return nil;
}


- (UIWebView *)messageWebView
{
    if (_messageWebView == nil)
    {
        UIWebView *messageVebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        messageVebView.delegate = self;
        messageVebView.alpha = 0.0;
        messageVebView.backgroundColor = [UIColor redColor];
        [self.view addSubview:messageVebView];
        _messageWebView = messageVebView;
        _messageWebView.scrollView.backgroundColor = [UIColor redColor];
        [messageVebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.testLabel).with.insets(UIEdgeInsetsMake(0,0,-4,0));
        }];
    }
    return nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.messageWebView.alpha = 1.0;
    self.testLabel.alpha = 0.0;
}
























































- (void)zhengzeTest_localImage
{
    NSString *checkString = @"[emoticons=E___0480ZH00SIG]赞[/emoticons],[emoticons=E___0305EN00SIG]美好[/emoticons]哈哈哈";
    NSError *error;
    NSString *pattern = @"\\[emoticons=E___([0-9a-zA-Z]*)](.*?)\\[\\/emoticons]";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regular matchesInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: checkString];
    int i = (int)[arrayOfAllMatches count];
    for (; i>0; i--)
    {
        NSTextCheckingResult *match = arrayOfAllMatches[i-1];
        NSString* substringForMatch = [checkString substringWithRange:match.range];
        NSLog(@"%d %@  ---> %@",i,substringForMatch,[self idOfemoticons:substringForMatch]);
        
        //NSAttachmentAttributeName 设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
        
        NSTextAttachment *textAttachment01 = [[NSTextAttachment alloc] init];
        textAttachment01.image = [UIImage imageNamed:@"icon"];  //设置图片源
        //        textAttachment01.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.sinaimg.cn/uc/myshow/blog/misc/gif/E___0480ZH00SIGT.gif"]]];
        textAttachment01.bounds = CGRectMake(0, 0, 30, 30);     //设置图片位置和大小
        [attrStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 25] range: NSMakeRange(0, attrStr.length)];
        NSAttributedString *attrStr11 = [NSAttributedString attributedStringWithAttachment: textAttachment01];
        NSLog(@"++++%@",@(match.range.location));
        [attrStr insertAttributedString: attrStr11 atIndex: match.range.location];  //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
        NSRange range = match.range;
        range.location +=1;
        [attrStr replaceCharactersInRange:range withString:@""];
    }
    
    self.testLabel.attributedText = attrStr;
    NSLog(@"---->\n\n\n");
}

- (void)test
{
    NSString *checkString = @"a34sd231";
    //1.创建正则表达式，[0-9]:表示‘0’到‘9’的字符的集合
    NSString *pattern = @"[0-9]";
    //1.1将正则表达式设置为OC规则
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //2.利用规则测试字符串获取匹配结果
    NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
    //    NSLog(@"%ld",results.count);
    for (NSTextCheckingResult *match in results)
    {
        NSString* substringForMatch = [checkString substringWithRange:match.range];
        NSLog(@"%@ \n+++>> %@",match,substringForMatch);
    }
}

- (void)test1
{
    NSString *checkString = @"http://  https://";
    //1.创建正则表达式，[0-9]:表示‘0’到‘9’的字符的集合
    NSString *pattern = @"https?://";
    //1.1将正则表达式设置为OC规则
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //2.利用规则测试字符串获取匹配结果
    NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
    //    NSLog(@"%ld",results.count);
    for (NSTextCheckingResult *match in results)
    {
        NSString* substringForMatch = [checkString substringWithRange:match.range];
        NSLog(@"%@ \n+++>> %@",match,substringForMatch);
    }
}

- (void)test2
{
    //需要被筛选的字符串
    NSString *str = @"#今日要闻#[偷笑] http://asd.fdfs.2ee/aas/1e @sdf[test] #你确定#@rain李23: @张三[挖鼻屎]m123m";
    //表情正则表达式
    //  \\u4e00-\\u9fa5 代表unicode字符
    NSString *emopattern = @"\\[[a-zA-Z\\u4e00-\\u9fa5]+\\]";
    //@正则表达式
    NSString *atpattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    //#...#正则表达式
    NSString *toppattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    //url正则表达式
    NSString *urlpattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    //设定总的正则表达式
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@",emopattern,atpattern,toppattern,urlpattern];
    //根据正则表达式设定OC规则
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //获取匹配结果
    NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    //NSLog(@"%@",results);
    //遍历结果
    for (NSTextCheckingResult *result in results) {
        NSLog(@"%@ %@",NSStringFromRange(result.range),[str substringWithRange:result.range]);
    }
}
@end
