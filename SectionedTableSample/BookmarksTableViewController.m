//
//  BookmarksTableViewController.m
//  SectionedTableSample
//
//  Created by Scott Carter on 2/17/15.
//  Copyright (c) 2015 Scott Carter. All rights reserved.
//

#import "BookmarksTableViewController.h"

#import "Project.h"

#import "AppDelegate.h"

#import "Videos.h"
#import "Articles.h"

#import "YouTubeViewController.h"
#import "ArticleViewController.h"

#import "CoreDataConnection.h"

#import "BookmarkedTableViewCell.h"



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Private Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
@interface BookmarksTableViewController () <NSFetchedResultsControllerDelegate, YouTubeViewControllerDelegate, ArticleViewControllerDelegate>

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

// Use a pair of NSFetchedResultsControllers for Articles, Videos
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerArticles;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerVideos;



@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// CoreDataConnection model
@property (strong, nonatomic) CoreDataConnection *coreDataConnection;


@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation BookmarksTableViewController

// ==========================================================================
// Constants and Defines
// ==========================================================================
//
#pragma mark -
#pragma mark Constants and Defines

// Table sections
//
NSUInteger const BookmarksVideoSection = 0;
NSUInteger const BookmarksArticleSection = 1;




// ==========================================================================
// Getters and Setters
// ==========================================================================
//
#pragma mark -
#pragma mark Getters and Setters

// None


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
    [self.tableView reloadData];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    BookmarkedTableViewCell *cell = (BookmarkedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *assetId = cell.assetId;
    NSString *title = cell.textLabel.text;
    NSString *assetUrl = cell.assetUrl;
    
    
    // Set the videoId of YouTubeViewController instance before we segue.
    if ([[segue identifier] isEqualToString:@"youtubeBookmarkedSegue"]) {
        
        YouTubeViewController *youTubeController = (YouTubeViewController *)[segue destinationViewController];
        
        // Set ourself as delegate
        [youTubeController setDelegate:self];
        
        [youTubeController setVideoId:assetId];
        [youTubeController setVideoTitle:title];
        [youTubeController setThumbnailUrl:assetUrl];
        
        [youTubeController setBookmarked:YES];
    }
    
    // Set the articleId of ArticleViewController instance before we segue.
    else if ([[segue identifier] isEqualToString:@"articleBookmarkedSegue"]) {
        
        ArticleViewController *articleViewController = (ArticleViewController *)[segue destinationViewController];
        
        // Set ourself as delegate
        [articleViewController setDelegate:self];
        
        [articleViewController setArticleId:assetId];
        [articleViewController setArticleTitle:title];
        [articleViewController setUrl:assetUrl];
        
        [articleViewController setBookmarked:YES];
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
    
    // Configure for self sizing cells
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    
    // Update Core Data
    if(bookmarked){
        [self.coreDataConnection findOrAddArticleWithIdentifier:articleId title:title url:url error:&error];
    }
    else {
        [self.coreDataConnection deleteArticleWithIdentifier:articleId error:&error];
    }
    
    // Not handling error condition currently.
    
}


#pragma mark YouTubeViewControllerDelegate


- (void)bookmarkState:(BOOL)bookmarked forVideoId:(NSString *)videoId title:(NSString *)title thumbnailUrl:(NSString *)thumbnailUrl
{
    NSError *error = nil;
    
    // Update Core Data
    if(bookmarked){
        [self.coreDataConnection findOrAddVideoWithIdentifier:videoId title:title thumbnailUrl:thumbnailUrl error:&error];
    }
    else {
        [self.coreDataConnection deleteVideoWithIdentifier:videoId error:&error];
    }
    
    // Not handling error condition currently.
    
}





#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case BookmarksVideoSection:
            return @"Videos";
            break;
            
        case BookmarksArticleSection:
            return @"Articles";
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %ld",(long)section)
            return 0;
            break;
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo;
    
    switch (section) {
        case BookmarksVideoSection:
            sectionInfo = [self.fetchedResultsControllerVideos sections][0];
            return [sectionInfo numberOfObjects];
            break;
            
        case BookmarksArticleSection:
            sectionInfo = [self.fetchedResultsControllerArticles sections][0];
            return [sectionInfo numberOfObjects];
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %ld",(long)section)
            return 0;
            break;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    
    BookmarkedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookmarkedCell" forIndexPath:indexPath];
    
    
    // We need to create a derived indexPath for use with our Fetched results controllers.  The section
    // is fixed at 0.
    NSInteger row = [indexPath row];
    NSIndexPath *fetchedControllerIndexPath = [NSIndexPath indexPathForRow:row inSection:0];

    
    switch (section) {
        case BookmarksVideoSection:
            [self configureVideoCell:cell atIndexPath:fetchedControllerIndexPath];
            break;
            
        case BookmarksArticleSection:
            [self configureArticleCell:cell atIndexPath:fetchedControllerIndexPath];
            break;

        default:
            EXCEPTION_LOG("Invalid table section %ld",(long)section)
            break;
    }
    
    // Use a text style that scales for Dynamic Text
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}



- (void)configureVideoCell:(BookmarkedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Videos *video = (Videos *)[self.fetchedResultsControllerVideos objectAtIndexPath:indexPath];
    
    NSString *videoId = video.videoId;
    NSString *title = video.title;
    NSString *thumbnailUrl = video.thumbnailUrl;
    
    cell.assetId = videoId;
    cell.assetUrl = thumbnailUrl;
    cell.textLabel.text = title;
    
    // Set thumbnail image
    [super setImageForCell:cell];
    
}

- (void)configureArticleCell:(BookmarkedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Articles *article = (Articles *)[self.fetchedResultsControllerArticles objectAtIndexPath:indexPath];
    
    NSString *articleId = article.articleId;
    NSString *title = article.title;
    NSString *url = article.url;
    
    cell.assetId = articleId;
    cell.assetUrl = url;
    
    cell.textLabel.text = title;
    cell.imageView.image = nil;
}


// The dimensions of our video thumbnails are 120x90.  See method fetchVideos
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    
    switch (section) {
        case BookmarksVideoSection:
            return THUMBNAIL_ROW_HEIGHT;
            break;
            
        case BookmarksArticleSection:
            return DEFAULT_ROW_HEIGHT;
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %ld",(long)section)
            return DEFAULT_ROW_HEIGHT;
            break;
    }
    
    
}


// Handle row selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    
    switch (section) {
            
        case BookmarksVideoSection:
            [self performSegueWithIdentifier:@"youtubeBookmarkedSegue" sender:self];
            break;
            
        case BookmarksArticleSection:
            [self performSegueWithIdentifier:@"articleBookmarkedSegue" sender:self];
            break;
            
        default:
            EXCEPTION_LOG("Invalid table section %ld",(long)section)
            break;
    }
    
}




#pragma mark - Fetched results controller

// Articles Fetched results controller
- (NSFetchedResultsController *)fetchedResultsControllerArticles
{
    if(_fetchedResultsControllerArticles != nil){
        return _fetchedResultsControllerArticles;
    }
    
    _fetchedResultsControllerArticles = [self fetchedResultsControllerForEntity:@"Articles"];
    
    NSError *error = nil;
    if (![self.fetchedResultsControllerArticles performFetch:&error]) {

        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsControllerArticles;
}


// Articles Fetched results controller
- (NSFetchedResultsController *)fetchedResultsControllerVideos
{
    if(_fetchedResultsControllerVideos != nil){
        return _fetchedResultsControllerVideos;
    }
    
    _fetchedResultsControllerVideos = [self fetchedResultsControllerForEntity:@"Videos"];
    
    NSError *error = nil;
    if (![self.fetchedResultsControllerVideos performFetch:&error]) {
        
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsControllerVideos;
}



- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString *)entityName
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
//    // Optional predicate
//    NSPredicate *predicate = [self fetchPredicate];
//    if(predicate){
//        fetchRequest.predicate = predicate;
//    }
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    
    // PLOG_TOP("fetchedResultsController=%@  fetchRequest=%@ self=%@", aFetchedResultsController, fetchRequest, self)

    return aFetchedResultsController;
}


 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
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

// None



@end
