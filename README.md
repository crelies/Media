# 🖼️ Media

A **beautiful**, **simple**, **declarative**, **convenient**, **cross-platform (iOS, macOS & tvOS)** and **unit-tested** *wrapper API* for Apple's `PhotoKit`

[![Swift 5.3](https://img.shields.io/badge/swift-5.3-green.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com)
[![Current Version](https://img.shields.io/github/v/tag/crelies/Media?longCache=true&style=flat-square)](https://github.com/crelies/Media)
[![Build status](https://travis-ci.com/crelies/Media.svg?token=THnaziKxRFFz1nKcsPgz&branch=dev)](https://travis-ci.com/crelies/Media)
[![codecov](https://codecov.io/gh/crelies/Media/branch/dev/graph/badge.svg?token=DhJyoUKNPM)](https://codecov.io/gh/crelies/Media)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

## ❤️ Motivation

What I don't like about `PhotoKit` is that it's *not declarative* and that developers have to *think about too many details*.
That's why I created this Swift package which will dramatically *improve the readability* of your `PhotoKit` code.

Easily fetch media from the photo library with `Albums.all`, `album.photos` or `Photos.live` and many more.

Additionally you can perform many operations on the photo library in a very easy and robust way, like

- changing the *favorite* state of a media object,
- fetching metadata or
- deleting media
- ...

Check out the below **API** section for more.

**And please feel free to contribute.** **Any kind of contribution is more than welcome!** I can guarantee you that even with a good unit test coverage there are still bugs hiding somewhere 🐛.

## ℹ️ Installation

Just add this Swift package as a dependency to your `Package.swift`

```swift
.package(url: "https://github.com/crelies/Media.git", from: "0.1.0"),
```

## 📖 Implementation

This Swift package provides its functionality through wrapper types for many common `PhotoKit` media types:

- (Lazy)Album(s)
- Audio(s)
  - LazyAudios
- LivePhoto(s)
  - LazyLivePhotos
- (Media.)Photo(s)
  - Media.LazyPhotos
- Video(s)
  - LazyVideos

Many types implement static factory methods to make it easy for the developer to access and manage the photo library.

In addition to that this Swift package contains some simple and ready-to-use **SwiftUI views** for interacting with the photo library, like a `Camera` view or a view for an instance of  `LivePhoto`, `Photo` and `Video`.

The core functionality is available through `import MediaCore`. If you want to use the included **SwiftUI** views `import MediaSwiftUI` as well.

That's all you need to know. Now let's take a look at the **API**.

## 🕹️ Examples

Check out the example project in the `Example` directory to explore the power of this Swift package.

## 🧭 API

This section gives you an overview of the currently available functionality. Most of the following should be self-explanatory. Nevertheless every public type, function and property is documented. *If the Xcode autocompletion works* you should get the information you need when using the *APIs* provided by this Swift package 🚀.

### Media

- `Media.requestPermission { result in }`

  *Request the users permission to access his photo library*
  
- `Media.requestCameraPermission { result in }`

  *Requests the user's permission to access the camera*

- `Media.isAccessAllowed`

  *Check if the access to the photo library is allowed*

- `Media.currentPermission`

  *Get the current permission*

- **SwiftUI only**: `Media.browser(selectionLimit:) { result in }` (*some View*)

  *Creates a ready-to-use media browser **SwiftUI** view (UIImagePickerController) for photos and videos*

### Albums

Use the `LazyAlbums` wrapper if you want to fetch albums only on demand (request an album through the provided `subscript` on the `LazyAlbums` type).

- `Albums.all`

  *Fetch all albums in the photo library*

- `Albums.user`

  *Fetch all albums related to the user*

- `Albums.smart`

  *Fetch all smart albums, like screenshots, self-portraits, ...*

- `Albums.cloud`

  *Fetch all cloud albums, like the photo stream or the iCloud shared album*

#### Album

##### Content

- `album.metadata`

  *Get locally available metadata of the album, like the estimated asset count or the earliest creation date among all assets in the album*

- `album.audios`

  *Get all audios in the album*

- `album.livePhotos`

  *Access all live photos in album*

- `album.photos`

  *Fetch all photos in the album*

- `album.videos`

  *Fetch all videos in the album*

- `album.allMedia`

  *Get all media items in the album (audios, (live) photos and videos)*

##### **C**reate & **R**ead

- `Album.create(title:) { result in }`

  *Create an album with the given title*

- `Album.with(identifier:) -> Album?`

  *Get an album with the given identifier*

- `Album.with(localizedTitle:) -> Album?`

  *Get an album with the given localized title*

##### **U**pdate & **D**elete

- `album.add(audio|livePhoto|photo|video) { result in }`

  *Add the given media item (audio, (live) photo or video) to the album*

- `album.delete(audio|livePhoto|photo|video) { result in }`

  *Deletes the given media item (audio, (live) photo or video) from the album*

- `album.delete { result in }`

  *Deletes the album*

### Audios

Use the `LazyAudios` wrapper if you want to fetch audios only on demand (request an audio through the provided `subscript` on the `LazyAudios` type).

- `Audios.all`

  *Get all audios in the photo library*

#### Audio

- `Audio.with(identifier:) - > Audio? (check for existence if you want)`

  *Get an audio with the given identifier*

- `audio.metadata`

  *Fetch the locally available metadata of the audio*

- `audio.delete { result in }`

  *Deletes the audio*

### Camera

- **SwiftUI only**: `Camera.view { result in }` (*some View*)

  *Creates a ready-to-use camera **SwiftUI** view (UIImagePickerController) for capturing photos and videos*

### LivePhotos

Use the `LazyLivePhotos` wrapper if you want to fetch live photos only on demand (request a live photo through the provided `subscript` on the `LazyLivePhotos` type).

- `LivePhotos.all`

  *Get all live photos in the photo library*

#### LivePhoto

- `livePhoto.metadata`

  *Fetch the locally available metadata of the live photo*

- `livePhoto.displayRepresentation(targetSize:contentMode) { result in }`

  *Get a PHLivePhoto representation of the live photo*

- `LivePhoto.save(data:) { result in }`

  *Create a new live photo in the library from the given data object (**LivePhotoData**: holds image and video portion)*

- `LivePhoto.with(identifier:) -> LivePhoto? (check for existence if you want)`

  *Get a live photo with the given identifier*

- `livePhoto.delete { result in }`

  *Delete the receiving live photo*

- `livePhoto.favorite(true|false) { result in }`

  *Update the favorite state of the receiving live photo*

##### **SwiftUI**

- **SwiftUI only**: `LivePhoto.camera { result in }` (*some View*)

  *Creates a ready-to-use **SwiftUI** camera view for capturing live photos (this is not a UIImagePickerController)*

- **SwiftUI only**: `LivePhoto.browser(selectionLimit:) { result in }` (*some View*)

  *Creates a ready-to-use **SwiftUI** view for browsing live photos in the library (UIImagePickerController)*

- **SwiftUI only**: `livePhoto.view(size:)` (*some View*)

  *Get a ready-to-use **SwiftUI** view for displaying the receiving live photo in your UI*

### Photos

Use the `Media.LazyPhotos` wrapper if you want to fetch photos only on demand (request a photo through the provided `subscript` on the `Media.LazyPhotos` type).

- `Media.Photos.all (includes livePhotos)`

  *Get all photos in the library, including the live photos*

- `Media.Photos.live`

  *Get all live photos in the library*

- `Media.Photos.panorama`

  *Fetch all panorama photos in the library*

- `Media.Photos.hdr`

  *Get all HDR photos*

- `Media.Photos.screenshot`

  *Get all screenshots in the library*

- `Media.Photos.depthEffect`

  *Fetch all depth effect photos in the library*

#### Photo

- `photo.metadata`

  *Fetch all locally available metdata of the photo*

- `photo.subtypes`

  *Get all subtypes of the photo, like HDR or panorama*

- `photo.properties { result in }`

  *Fetch all properties (metadata) of the photo, including EXIF, GPS and TIFF data*

- `photo.data { result in }`

  *Get a data representation of the photo*

- `photo.uiImage(targetSize:contentMode:) { result in }`

  *Get a UIImage representation of the photo*

- `Photo.save(Media.URL<Photo>) { result in }`

  *Create a new photo using the given photo url*

- `Photo.save(UIImage) { result in }`

  *Create a new photo from the given UIImage instance*

- `Photo.with(identifier:) -> Photo?`

  *Get a photo with the given identifier*

- `photo.delete { result in }`

  *Delete the receiving photo*

- `photo.favorite(true|false) { result in }`

  *Update the favorite state of the receiving photo*

##### **SwiftUI**

- **SwiftUI only**: `Photo.camera { result in }` (*some View*)

  *Creates a ready-to-use camera **SwiftUI** view for capturing photos (UIImagePickerController)*

- **SwiftUI only**: `Photo.browser(selectionLimit:) { result in }` (*some View*)

  *Creates a ready-to-use **SwiftUI** view for browsing photos in the library (UIImagePickerController)*

- **SwiftUI only**: `photo.view(targetSize:contentMode:) { image in image.resizable().aspectRatio(contentMode: .fit) }` (*some View*)

  *Get a ready-to-use **SwiftUI** view for displaying the photo in your UI*

### Videos

Use the `LazyVideos` wrapper if you want to fetch videos only on demand (request a video through the provided `subscript` on the `LazyVideos` type).

- `Videos.all`

  *Get all videos in the library*

- `Videos.streams`

  *Get all video streams in the library*

- `Videos.highFrameRates`

  *Fetch all high frame rates videos in the library*

- `Videos.timelapses`

  *Get all timelapse videos in the library*

#### Video

- `video.subtypes`

  *Get the subtypes of the receiving video, like high frame rate*

- `video.metadata`

  *Fetch all locally available metadata*

- `video.properties { result in }`

  *Get all properties (metadata) of the video, including location and model data*

- `video.playerItem(deliveryMode:) { result in }`

  *Get an AVPlayerItem representation of the receiving video*

- `video.avAsset(deliveryMode:) { result in }`

  *Fetch an AVAsset representation of the video*
  
- `video.previewImage(at:) { result in }`

  *Generates a preview image for the receiving video*

- `video.export(options, progress: { progress in }) { result in }`

  *Export the receiving video using the given options*

- `Video.save(Media.URL<Video>) { result in }`

  *Create a new video using the given url*

- `Video.with(identifier:) -> Video?`

  *Get a video with the given identifier*

- `video.favorite(true|false) { result in }`

  *Update the favorite state of the receiving video*

- `video.delete { result in }`

  *Delete the video*

##### **SwiftUI**

- **SwiftUI only**: `Video.camera { result in }` (*some View*)

  *Creates a ready-to-use video camera **SwiftUI** view for capturing videos (UIImagePickerController)*

- **SwiftUI only**: `Video.browser(selectionLimit:) { result in }` (*some View*)

  *Creates a ready-to-use **SwiftUI** view for browsing videos in the library*

- **SwiftUI only**: `video.view` (*some View*)

  *Get a ready-to-use **SwiftUI** view for displaying the video in your UI*

### 🚀 `@propertyWrapper`

The `Media` package also includes some generic property wrappers you can use to interact with the photo library.

- `@FetchAllAssets(sort:fetchLimit:includeAllBurstAssets:includeHiddenAssets) var assets: [AnyMedia]`

- `@FetchAssets(filter:sort:fetchLimit:includeAllBurstAssets:includeHiddenAssets) var assets: [ <Audio | LivePhoto | Photo | Video> ]`

  *Fetch audios, live photos, photos or videos matching the given filter and sorted by the given sort*

- `@FetchAsset(filter:) var asset: <Audio | LivePhoto | Photo | Video>?`

  *Fetch a single audio, live photo, photo or video from the library which matches the given filter*

- `@FetchAlbums(ofType:filter:sort:fetchLimit) var albums: [Album]`

  *Fetch albums of the given type which match the given filter, matching albums are sorted by the given sort*

- `@FetchAlbum(filter:) var album: Album?`

  *Fetch a single album which matches the given filter*

## Contributions

This a another open source project I created in my free time. Even with a full time job and a family I'm highly motivated to create software for the community. I trust the community in pushing things forward. So feel free to contribute in any way. Fix bugs, add more documentation or add a completely new feature. Just create a pull request if you are finished and I will take a look at it. Be advised that I will give feedback to assure the highest quality possible 🙂