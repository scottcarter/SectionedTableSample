//
//  MainTableViewController.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/17/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "MainTableViewController.h"

#import "Project.h"

#import "YouTubeViewController.h"
#import "ArticleViewController.h"

#import "AppDelegate.h"

#import "CoreDataConnection.h"

#import "BookmarkedTableViewCell.h"



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Private Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
@interface MainTableViewController () <YouTubeViewControllerDelegate, ArticleViewControllerDelegate>

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties


// Properties for article and video information that we retrieve via public API
// or Core Data (bookmarked assets).
//
// We use a dictionary to store this information, keyed by asset id, to allow for
// easy merging between API data and Core Data.
//
// The dictionary information is translated into sorted arrays after every merge
// for processing by the Table View.
//

// Each articleDict entry is keyed by articleId and contains a dictionary
// with keys title, url, bookmarked
@property (strong, nonatomic) NSMutableDictionary *articleDict;

// Each videoDict entry is keyed by videoId and contains a dictionary
// with keys title, thumbnailUrl, bookmarked
@property (strong, nonatomic) NSMutableDictionary *videoDict;



// Each articleArr element is a dictionary with keys articleId, title, url, bookmarked
@property (strong, nonatomic) NSArray *articleArr;

// Each videoArr element is a dictionary with keys videoId, title, thumbnailUrl, bookmarked
@property (strong, nonatomic) NSArray *videoArr;


// We wish to be able to display placeholder information while information is loading,
// or feedback to user on error.
@property (nonatomic) BOOL validArticles;
@property (nonatomic) BOOL validVideos;
@property (strong, nonatomic) NSString *noArticlesRowText;
@property (strong, nonatomic) NSString *noVideosRowText;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


// CoreDataConnection model
@property (strong, nonatomic) CoreDataConnection *coreDataConnection;


@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation MainTableViewController

// ==========================================================================
// Constants and Defines
// ==========================================================================
//
#pragma mark -
#pragma mark Constants and Defines

// Table sections
//
NSUInteger const MainProgressSection = 0;
NSUInteger const MainVideoSection = 1;
NSUInteger const MainArticleSection = 2;


// Number of results to display
NSUInteger const VideoNumResults = 5; // 1 - 50
NSUInteger const ArticleNumResults = 5; // 1 - 20



// ==========================================================================
// Getters and Setters
// ==========================================================================
//
#pragma mark -
#pragma mark Getters and Setters

- (NSMutableDictionary *)articleDict
{
    if(!_articleDict){
        _articleDict = [[NSMutableDictionary alloc] init];
    }
    return _articleDict;
}


- (NSMutableDictionary *)videoDict
{
    if(!_videoDict){
        _videoDict = [[NSMutableDictionary alloc] init];
    }
    return _videoDict;
    
}

- (NSArray *)articleArr
{
    if(!_articleArr){
        _articleArr = [[NSArray alloc] init];
    }
    return _articleArr;
}


- (NSArray *)videoArr
{
    if(!_videoArr){
        _videoArr = [[NSArray alloc] init];
    }
    return _videoArr;
}


// ==========================================================================
// Actions
// ==========================================================================
//
#pragma mark -
#pragma mark Actions

// None



// ==========================================================================
// Initializations
// ==========================================================================
//
#pragma mark -
#pragma mark Initializations


- (void)dealloc
{
    PLOG_TOP("dealloc !!!!!!!")
    
    // Unregister from all notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// If text size changed, reload table cells
//
// Reference: http://useyourloaf.com/blog/2013/12/17/supporting-dynamic-type.html
//
- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self reloadData];
}



 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
     
     NSInteger row = [indexPath row];
     
     
     // Set the videoId of YouTubeViewController instance before we segue.
     if ([[segue identifier] isEqualToString:@"youtubeSegue"]) {
         
         YouTubeViewController *youTubeController = (YouTubeViewController *)[segue destinationViewController];
         
         // Set ourself as delegate
         [youTubeController setDelegate:self];
         
         [youTubeController setVideoId:self.videoArr[row][@"videoId"]];
         [youTubeController setVideoTitle:self.videoArr[row][@"title"]];
         [youTubeController setThumbnailUrl:self.videoArr[row][@"thumbnailUrl"]];
         
         NSNumber *bookmarkedNum = (NSNumber *)self.videoArr[row][@"bookmarked"];
         [youTubeController setBookmarked:[bookmarkedNum boolValue]];
     }
     
     // Set the articleId of ArticleViewController instance before we segue.
     else if ([[segue identifier] isEqualToString:@"articleSegue"]) {
         
         ArticleViewController *articleViewController = (ArticleViewController *)[segue destinationViewController];
         
         // Set ourself as delegate
         [articleViewController setDelegate:self];
         
         [articleViewController setArticleId:self.articleArr[row][@"articleId"]];
         [articleViewController setArticleTitle:self.articleArr[row][@"title"]];
         [articleViewController setUrl:self.articleArr[row][@"url"]];
         
         NSNumber *bookmarkedNum = (NSNumber *)self.articleArr[row][@"bookmarked"];
         [articleViewController setBookmarked:[bookmarkedNum boolValue]];
     }
     
     
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //PLOG_TOP("")
    
    // Set our managedObjectContext from reference in AppDelegate.
    //
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    
    // Instance a CoreDataConnection model.
    self.coreDataConnection = [[CoreDataConnection alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    
    // Listen for changes to text size
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    // Add a refresh button to navigation bar that can be used to update to latest content.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchContent)];
    self.navigationItem.leftBarButtonItem = addButton;

    
    // Add a refresh control.
    // Good reference on how to implement here: http://www.appcoda.com/pull-to-refresh-uitableview-empty/
    //
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchContent)
                  forControlEvents:UIControlEventValueChanged];

    
    
    // Fetch initial content
    [self fetchContent];
    
}





// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods


#pragma mark ArticleViewControllerDelegate

- (void)bookmarkState:(BOOL)bookmarked forArticleId:(NSString *)articleId title:(NSString *)title url:(NSString *)url
{
    NSError *error = nil;
    
    
    // Update our dictionary
    self.articleDict[articleId][@"bookmarked"] = [NSNumber numberWithBool:bookmarked];
    
    
    // Update Core Data
    if(bookmarked){
        [self.coreDataConnection findOrAddArticleWithIdentifier:articleId title:title url:url error:&error];
    }
    else {
        [self.coreDataConnection deleteArticleWithIdentifier:articleId error:&error];
    }
    if(error){
        return; // Error
    }


    // Update self.articleArr
    //
    [self updateArticleArr];
    
    
    // Update Table
    //
    // Only necessary to update single cell.  We need to find the row that contains this articleId
    //
    // We will give a hint that the Block enumeration should be concurrent.
    //
    NSUInteger row = [self.articleArr indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        if([dict[@"articleId"] isEqualToString:articleId]){
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if(row == NSNotFound){
        EXCEPTION_LOG("Did not find articleId %@ in self.articleArr",articleId)
        return;
    }
    
    // Reload single row instead of calling reloadData.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:MainArticleSection];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark YouTubeViewControllerDelegate



// Bookmark state has changed in selected video.
//
// Lookup entry in self.videoDict, set the bookmark state, update self.videoArr
// and reload the table.
- (void)bookmarkState:(BOOL)bookmarked forVideoId:(NSString *)videoId title:(NSString *)title thumbnailUrl:(NSString *)thumbnailUrl
{
    NSError *error = nil;
    
    
    // Update our dictionary
    self.videoDict[videoId][@"bookmarked"] = [NSNumber numberWithBool:bookmarked];
    
    
    // Update Core Data
    if(bookmarked){
        [self.coreDataConnection findOrAddVideoWithIdentifier:videoId title:title thumbnailUrl:thumbnailUrl error:&error];
    }
    else {
        [self.coreDataConnection deleteVideoWithIdentifier:videoId error:&error];
    }
    if(error){
        return; // Error
    }

    
    
    // Update self.videoArr
    //
    [self updateVideoArr];
    
    
    // Update Table
    //
    // Only necessary to update single cell.  We need to find the row that contains this videoId
    //
    // We will give a hint that the Block enumeration should be concurrent.
    //
    NSUInteger row = [self.videoArr indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        if([dict[@"videoId"] isEqualToString:videoId]){
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if(row == NSNotFound){
        EXCEPTION_LOG("Did not find videoId %@ in self.videoArr",videoId)
        return;
    }
    
    // Reload single row instead of calling reloadData.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:MainVideoSection];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;  // Progress, Videos, Articles
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case MainProgressSection:
            return @"Progress";
            break;
            
        case MainVideoSection:
            return @"Videos";
            break;
            
        case MainArticleSection:
            return @"Articles";
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %d",section)
            return 0;
            break;
    }

}


// Customize the header.   At a minimum we wish to use dynamic text.
//
// http://stackoverflow.com/questions/19802336/ios-7-changing-font-size-for-uitableview-section-headers
//
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor brownColor];
    header.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    // Need to resize the frame after changing font.
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
    //header.textLabel.textAlignment = NSTextAlignmentCenter;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case MainProgressSection:
            return 1; // Placeholder
            break;
            
        case MainVideoSection:
            if(self.validVideos){
                return [self.videoArr count];
            }
            else {
                return 1; // Information row.
            }
            break;
            
        case MainArticleSection:
            if(self.validArticles){
                return [self.articleArr count];
            }
            else {
                return 1; // Information row.
            }
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %d",section)
            return 0;
            break;
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookmarkedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell" forIndexPath:indexPath];
    
    
    // Use a text style that scales for Dynamic Text
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    // Set the default accessoryType.  We will override to a checkmark if we find we are bookmarked.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    switch (section) {
        case MainProgressSection:
            cell.textLabel.text = @"Not yet implemented";
            cell.imageView.image = nil;
            break;
            
        case MainVideoSection:
            if(self.validVideos){
                [self configureVideoCell:cell row:row];
            }
            else {
                cell.textLabel.text = self.noVideosRowText;
            }
            break;
            
        case MainArticleSection:
            if(self.validArticles){
                
                // If article is bookmarked, show a checkmark.
                NSNumber *bookmarkedNum = (NSNumber *)self.articleArr[row][@"bookmarked"];
                if([bookmarkedNum boolValue]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                
                cell.assetId = self.articleArr[row][@"articleId"];
                cell.assetUrl = self.articleArr[row][@"url"];
                cell.textLabel.text = self.articleArr[row][@"title"];
            }
            else {
                cell.textLabel.text = self.noArticlesRowText;
            }
            cell.imageView.image = nil;
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %d",section)
            return 0;
            break;
            
            
    }
    
    return cell;
    
}


- (void)configureVideoCell:(BookmarkedTableViewCell *)cell
                       row:(NSInteger)row
{
    
    // If video is bookmarked, show a checkmark.
    NSNumber *bookmarkedNum = (NSNumber *)self.videoArr[row][@"bookmarked"];
    if([bookmarkedNum boolValue]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.assetId = self.videoArr[row][@"videoId"];
    cell.assetUrl = self.videoArr[row][@"thumbnailUrl"];
    cell.textLabel.text = self.videoArr[row][@"title"];
    
    
    // Set placeholder for thumbnail image.
    NSString* imagePath = [ [ NSBundle mainBundle] pathForResource:@"blank" ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = image;
    
    // Note:
    // In order to set the size, I included layoutSubviews in BookmarkedTableViewCell.m
    
    // Download image for cell
    [self setImageForCell:cell];
    
}



// Download image in separate queue.
//
- (void)setImageForCell:(BookmarkedTableViewCell *)cell
{
    
    NSString *assetUrl = cell.assetUrl;
    NSString *assetId = [cell.assetId copy];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);  // NULL = Serial queue
    dispatch_async(downloadQueue, ^{
        
        NSURL *url = [NSURL URLWithString:assetUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        
        // Go back to main thread to display thumbnail.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = data ? [UIImage imageWithData:data] : nil;
            
            // NLOG("width = %f  height = %f",image.size.width, image.size.height)
            
            // http://stackoverflow.com/questions/8052999/check-if-a-specific-uitableviewcell-is-visible-in-a-uitableview
            BOOL cellVisible = [self.tableView.visibleCells containsObject:cell];
            
            
            // Is cell reference the same or did we get a new cell (recorded in cellArray) since starting the thread?
            if(cellVisible && [cell.assetId isEqual:assetId]) {
                
                // Set the thumbnail image
                cell.imageView.image = image;
            }
            
        });
        
        
    });
    

}



// The dimensions of our video thumbnails are 120x90.  See method fetchVideos
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    
    switch (section) {
        case MainProgressSection:
            return DEFAULT_ROW_HEIGHT;
            break;
            
        case MainVideoSection:
            if(self.validVideos){
                return THUMBNAIL_ROW_HEIGHT;
            }
            else {
                return DEFAULT_ROW_HEIGHT;
            }
            break;
            
        case MainArticleSection:
            return DEFAULT_ROW_HEIGHT;
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %d",section)
            return DEFAULT_ROW_HEIGHT;
            break;
    }
    

}


// Handle row selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    
    switch (section) {
        case MainProgressSection:
            // Nothing to do for this section.
            break;
            
        case MainVideoSection:
            if(self.validVideos){
                [self performSegueWithIdentifier:@"youtubeSegue" sender:self];
            }
            break;
            
        case MainArticleSection:
            if(self.validArticles){
                [self performSegueWithIdentifier:@"articleSegue" sender:self];
            }
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %d",section)
            break;
    }

    
    
}




// ==========================================================================
// Class methods
// ==========================================================================
//
#pragma mark -
#pragma mark Class methods

// None


// ==========================================================================
// Instance methods
// ==========================================================================
//
#pragma mark -
#pragma mark Instance methods


// Fetch articles, videos.
//
// Table will be reloaded in completion blocks of API calls for video, articles.
//
- (void)fetchContent
{
    [self.videoDict removeAllObjects];
    [self.articleDict removeAllObjects];
    
    self.videoArr = @[];
    self.articleArr = @[];
    
    self.validVideos = NO;
    self.validArticles = NO;
    
    self.noVideosRowText = @"Fetching videos ...";
    self.noArticlesRowText = @"Fetching articles ...";
    
    
    // Fetch bookmarked content.  We count on the fact that this occurs before API content
    // is fetched.  Why?  In API completion blocks we assume we are bookmarked if
    // dictionary entries already exist for asset ids.
    //
    // A future enhancement could cache the initial load from Core Data in memory, so that
    // we don't load from Core Data on every call to fetchContent.
    //
    NSError *error = nil;
    NSArray *coreDataVideoArr = [self.coreDataConnection coreDataRecordArrForEntityName:@"Videos" predicate:nil properties:@[@"thumbnailUrl", @"title",@"videoId"] sortOnKey:nil ascending:YES includeObjectId:NO error:&error];
    
    // There are better ways to handle core data errors, but this will suffice for now.
    if(error){
        self.noVideosRowText = @"Problem fetching bookmarked data. Try reloading.";
        self.noArticlesRowText = @"Problem fetching bookmarked data. Try reloading.";
        return;
    }
    
    NSArray *coreDataArticleArr = [self.coreDataConnection coreDataRecordArrForEntityName:@"Articles" predicate:nil properties:@[@"url", @"title",@"articleId"] sortOnKey:nil ascending:YES includeObjectId:NO error:&error];
    
    // There are better ways to handle core data errors, but this will suffice for now.
    if(error){
        self.noVideosRowText = @"Problem fetching bookmarked data. Try reloading.";
        self.noArticlesRowText = @"Problem fetching bookmarked data. Try reloading.";
        return;
    }

    // Add Core Data assets
    
    // Videos
    for (NSDictionary *videoDict in coreDataVideoArr) {
        // videoDict  contains videoId, title, thumbnailUrl
        NSString *videoId = videoDict[@"videoId"];
        NSString *title = videoDict[@"title"];
        NSString *thumbnailUrl = videoDict[@"thumbnailUrl"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":title, @"thumbnailUrl":thumbnailUrl, @"bookmarked":@YES}];
        
        [self.videoDict setObject:dict forKey:videoId];
    }
    

    // Articles
    for (NSDictionary *articleDict in coreDataArticleArr) {
        // articleDict  contains articleId, title, url
        NSString *articleId = articleDict[@"articleId"];
        NSString *title = articleDict[@"title"];
        NSString *url = articleDict[@"url"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":title, @"url":url, @"bookmarked":@YES}];
  
        [self.articleDict setObject:dict forKey:articleId];
    }
    
    
    
    // Fetch content from APIs
    [self fetchVideos];
    
    [self fetchArticles];
}


- (void)reloadData
{
    
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        // Let's indicate the time of the last refresh when the refresh control is visible.
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
    
}


// Update self.articleArr using information from self.articleDict
- (void)updateArticleArr
{
    
    // First form an unsorted array which has the format of self.articleArr
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [self.articleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *articleId = (NSString *)key;
        NSString *title = (NSString *)obj[@"title"];
        NSString *url = (NSString *)obj[@"url"];
        NSNumber *bookmarked = (NSNumber *)obj[@"bookmarked"];
        
        [arr addObject:@{@"articleId":articleId, @"title":title, @"url":url, @"bookmarked":bookmarked}];
    }];
    
    // Now sort by title
    NSSortDescriptor *sortDescriptior = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];

    
    self.articleArr = [arr sortedArrayUsingDescriptors:@[sortDescriptior]];

}


// Update self.videoArr using information from self.videoDict
- (void)updateVideoArr
{
    
    // First form an unsorted array which has the format of self.videoArr
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [self.videoDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *videoId = (NSString *)key;
        NSString *title = (NSString *)obj[@"title"];
        NSString *thumbnailUrl = (NSString *)obj[@"thumbnailUrl"];
        NSNumber *bookmarked = (NSNumber *)obj[@"bookmarked"];
        
        [arr addObject:@{@"videoId":videoId, @"title":title, @"thumbnailUrl":thumbnailUrl, @"bookmarked":bookmarked}];
    }];
    
    // Now sort by title
    NSSortDescriptor *sortDescriptior = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    
    self.videoArr = [arr sortedArrayUsingDescriptors:@[sortDescriptior]];
    
}


#pragma mark New York Times

- (void)fetchArticles {
    
    
    [[UNIRest get:^(UNISimpleRequest *request) {
        // First 20 results shown by default.
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/30.json?api-key=%@",NYTIMES_API_KEY];
        
        [request setUrl:requestUrl];
        [request setHeaders:nil];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        
        // Completion block not called on main thread, so we call dispatch_sync here.
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // Uncomment for debug.
//            self.noArticlesRowText = @"Unable to fetch articles.  Try reloading.";
//            [self reloadData];
//            return;
            
            
            if(error){
                self.noArticlesRowText = @"Unable to fetch articles.  Try reloading.";
                [self reloadData];
                ERROR_LOG("%@",error)
                return;
            }
            
            
            // We have some valid articles
            self.validArticles = YES;
            
            
            //        NSInteger code = response.code;
            //        NSDictionary *responseHeaders = response.headers;
            UNIJsonNode *body = response.body;
            //        NSData *rawBody = response.rawBody;
            
            NSDictionary *json = [body JSONObject];
            
            NSArray *arr = json[@"results"];
            
            NSInteger count = 1;
            for (NSDictionary *dict in arr) {
                
                //NLOG("dict=%@",dict)
                
                NSString *articleId = dict[@"id"];
                NSString *title = dict[@"title"];
                NSString *url = dict[@"url"];
                
            
                // Example:
                //
                // articleId=100000003468826
                // title=After a Deal, British Chocolates Won’t Cross the Pond
                // url=http://www.nytimes.com/2015/01/24/nyregion/after-a-deal-british-chocolates-wont-cross-the-pond.html
                
                // If entry already exists for this articleId then we will assume we are bookmarked.
                // In that case, we are just updating title, url.
                //
                if([self.articleDict objectForKey:articleId]){
                    self.articleDict[articleId][@"title"] = title;
                    self.articleDict[articleId][@"url"] = url;
                }
                else {
                    // Need a mutable dictionary as value for articleId so that we can toggle
                    // bookmarked state.
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":title, @"url":url, @"bookmarked":@NO}];
                    [self.articleDict setObject:dict forKey:articleId];
                }
                
                //NLOG("articleId=%@ title=%@  url=%@",articleId, title, url)
                
                // Unlike the YouTube API, the New York Times API doesn't allow you to specify the number of results
                // to return in a range.  It gives first 20 results (you can page for more).
                //
                // Limit the number of results that we store.
                if(count >= ArticleNumResults){
                    break;
                }
                count++;
            }
            
            // Update self.articleArr after populating articleDict
            [self updateArticleArr];
            
            
            [self reloadData];
            
        });
        
        
        
    }];
}




#pragma mark YouTube

- (void)fetchVideos {
    
    GTLServiceYouTube *service = self.youTubeService;
    
    // The snippet property contains all the fields we need.
    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosListWithPart:@"snippet"];
    
    // Return the most popular videos for the specified content region and video category.
    query.chart = kGTLYouTubeChartMostPopular;
    
    // The regionCode parameter instructs the API to select a video chart available in
    // the specified region. This parameter can only be used in conjunction with the
    // chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
    //
    // http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
    //
    query.regionCode = @"US";
    
    
    
    // maxResults specifies the number of results per page.  We are only fetching
    // one page since we set service.shouldFetchNextPages = NO;
    //
    // (1..50, default 5)
    query.maxResults = VideoNumResults;
    
    
    // We can specify the fields we want here to reduce the network
    // bandwidth and memory needed for the fetched collection.
    //
    // For example, leave query.fields as nil during development.
    // When ready to test and optimize your app, specify just the fields needed.
    // For example, this sample app might use
    //
    // query.fields = @"kind,etag,items(id,etag,kind,contentDetails)";
    
    
    // Execute the query
    GTLServiceTicket *ticket = [service executeQuery:query
                                   completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                                       // This callback block is run when the fetch completes
                                       
                                       // Called on Main Thread.
                                       
                                       // Uncomment for debug.
//                                       self.noVideosRowText = @"Unable to fetch videos.  Try reloading.";
//                                       [self reloadData];
//                                       return;
                                       
                                       if(error){
                                           self.noVideosRowText = @"Unable to fetch videos.  Try reloading.";
                                           [self reloadData];
                                           ERROR_LOG("%@",error)
                                           return;
                                       }
                                       
                                       
                                       // We have some valid articles
                                       self.validVideos = YES;
                                       
                                       
                                       
                                       GTLYouTubeVideoListResponse *response = (GTLYouTubeVideoListResponse *)object;
                                       
                                       NSArray *arr = response.items;
                                       
                                       //NLOG("arr count = %d", [arr count])
                                       
                                       
                                       for (GTLYouTubeVideo *item in arr) {
                                           // Print the name of each product result item
                                           //NLOG("dict = %@\n\n", item.JSON)
                                           
                                           NSDictionary *json = item.JSON;
                                           NSString *videoId = json[@"id"];
                                           NSString *title = json[@"snippet"][@"title"];
                                           
                                           
                                           // We will use the default thumbnail which has a resolution of 120x90
                                           // https://developers.google.com/youtube/v3/docs/thumbnails
                                           //
                                           NSDictionary *thumbnails = json[@"snippet"][@"thumbnails"];
                                           NSString *thumbnailUrl = thumbnails[@"default"][@"url"];
                                           
                                           // Example:
                                           //
                                           // videoId=ImaYMoTi2g8
                                           // title=Celebrity Jeopardy - SNL 40th Anniversary Special
                                           // thumbnailUrl=https://i.ytimg.com/vi/ImaYMoTi2g8/default.jpg
                                           
                                           
                                           // If entry already exists for this videoId then we will assume we are bookmarked.
                                           // In that case, we are just updating title, thumbnailUrl.
                                           //
                                           if([self.videoDict objectForKey:videoId]){
                                               self.videoDict[videoId][@"title"] = title;
                                               self.videoDict[videoId][@"thumbnailUrl"] = thumbnailUrl;
                                           }
                                           else {
                                               // Need a mutable dictionary as value for videoId so that we can toggle
                                               // bookmarked state.
                                               NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":title, @"thumbnailUrl":thumbnailUrl, @"bookmarked":@NO}];
                                               [self.videoDict setObject:dict forKey:videoId];
                                           }
                                           
                                           
                                           
                                           //NLOG("videoId=%@ title=%@ thumbnailUrl=%@",videoId,title,thumbnailUrl)
                                           
                                       }
                                       
                                       // Update self.videoArr after populating videoDict
                                       [self updateVideoArr];
                                       
                                       [self reloadData];
                                       
                                   }];
    
    ticket = nil;  // Not using ticket
    
}



// Get a service object with the current username/password.
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information such as cookies set by the server in response
// to queries.

- (GTLServiceYouTube *)youTubeService {
    static GTLServiceYouTube *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[GTLServiceYouTube alloc] init];
        
        // We could have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        //
        // We are not using this feature here.
        // https://code.google.com/p/google-api-objectivec-client/wiki/Introduction#Result_Pages
        //
        service.shouldFetchNextPages = NO;
        
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
        
        
        // Set the API Key.  We will only use unauthenticated public calls.
        // https://code.google.com/p/google-api-objectivec-client/wiki/Introduction#Objects_and_Queries
        //
        service.APIKey = YOUTUBE_API_KEY;
        
        
        // Enable fetches to continue in the background on iOS
        // https://code.google.com/p/google-api-objectivec-client/wiki/Introduction#Services_and_Tickets
        //
        service.shouldFetchInBackground = YES;
        
        
        
        
    });
    return service;
}







@end
