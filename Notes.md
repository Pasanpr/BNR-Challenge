I started with UI work and moved the custom cell to a Storyboard based implementation. The cells display the title, author, summary and publish date as requested but a lot can be done to improve it. The collection view cell can be made self sizing so that the entire post summary is displayed if needed. 

I modified `PostMetadata` to define an `Author` property. This made grouping by author fairly easy. Given a list of metadata objects, I used a set to get unique authors and then mapped over the `postMetadataList` creating a grouping where each post matched an author.

Grouping by month was solved the same way. To avoid any stringly typed code I defined an `Month` enum with `Int` raw values. By using the `Calendar` type I was able to get the month for any metadata object and then follow a similar logic. Non-duplicate months were sorted and then groupings were created for each month.

When sorting I took into account the fact that data might already be grouped and handled it for both cases. For both grouped and sorted sections, section headers were added for clarity. 

The main source of delay in the UI was in `collectionView(_:didSelectItemAt:)` where on any cell tap, every single post was being downloaded. This was easily remedied by using `postUrlFor(id:)` to only fetch a single post along with the `postId`

There are a good amount of things I would've done here, given more time. First off I'd clean up `PostMetadataCollectionViewController` . Right now its role includes setting up the collection view, fetching data, serving as data source and as multiple delegates.

Instead of creating convenience methods in `PostMetadataDataSource`, I'd rewrite it to act as the data source itself and move all relevant methods in here. 

Similarly individual delegate objects can be created for `UICollectionViewDelegate` and `UICollectionViewDelegateFlowLayout.`

All of the network calls and model decoding can be moved into a different object as well, leaving view setup as the only responsibility for `PostMetadataCollectionViewController.`

Additionally, my unit tests only cover a few simple cases. I test for additional groupings but sorting and combinations of groups and sorts are not handled. 