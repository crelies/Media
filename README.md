# 🖼️ Media

A **beautiful**, **simple**, **declarative**, **convenient** and **unit-tested** *wrapper API* for Apple's `PhotoKit`

## ❤️ Motivation

What I don't like about `PhotoKit` is that it's *not declarative* and that developers have to *think about too many details*.
That's why I created this Swift package which will dramatically *improve the readability* of your `PhotoKit` code.

Easily fetch media from the photo library with `Albums.all`, `album.photos` or `Photos.live` and many more.

Additionally you can perform many operations on the photo library in a very easy and robust way, like

- changing the *favorite* state of media,
- fetching metadata or
- deleting media
- ...

Check out the below **API** section.

## ℹ️ Installation

Just add this Swift package as a dependency to your `Package.swift`

```swift
.package(url: "https://github.com/crelies/Media.git", from: "0.1.0"),
```

## 📖 Implementation

This Swift package provides its functionality through wrapper types for many common `PhotoKit` media types:

- Album(s)
- Audio(s)
- LivePhoto(s)
- Photo(s)
- Video(s)

Many types implement static factory methods to make it easy for the developer to access and manage the photo library.

In addition to that this Swift package contains some simple and ready-to-use **SwiftUI views** for interacting with the photo library, like a `Camera` view or a view for an instance of  `LivePhoto`, `Photo` and `Video`.

That's all you need to know. Now let's take a look at the **API**.

## 🧭 API

This section gives you an overview of the currently available functionality. Most of the following should be self-explanatory. Nevertheless every public type, function and property is documented. *If the Xcode autocompletion works* you should get the information you need when using the *APIs* provided by this Swift package 🚀

### Media

- `Media.requestPermission { result in }`

- `Media.isAccessAllowed`

- `Media.currentPermission`

- **SwiftUI only**: `Media.browser { result in }` (*some View*)

### Albums

- `Albums.all`

- `Albums.user`

- `Albums.smart`

- `Albums.cloud`

#### Album

##### Content

- `album.metadata`
- `album.audios`
- `album.livePhotos`
- `album.photos`
- `album.videos`
- `album.allMedia`

##### **C**reate & **R**ead

- `Album.create(title:) { result in }`

- `Album.with(identifier:) -> Album?`

- `Album.with(localizedTitle:) -> Album?` (check for existence if you want)`

##### **U**pdate & **D**elete

- `album.add(audio|livePhoto|photo|video) { result in }`

- `album.delete(audio|livePhoto|photo|video) { result in }`

- `album.delete { result in }`

### Audios

- `Audios.all`

#### Audio

- `Audio.with(identifier:) - > Audio? (check for existence if you want)`
- `audio.metadata`
- `audio.delete { result in }`

### Camera

- **SwiftUI only**: `Camera.view { result in }` (*some View*)

### LivePhotos

- `LivePhotos.all`

#### LivePhoto

- `livePhoto.metadata`
- `livePhoto.displayRepresentation(targetSize:contentMode) { result in }`
- `LivePhoto.save(data:) { result in }`
- `LivePhoto.with(identifier:) -> LivePhoto? (check for existence if you want)`
- `livePhoto.delete { result in }`
- `livePhoto.favorite(true|false) { result in }`

##### **SwiftUI**

- **SwiftUI only**: `LivePhoto.camera { result in }` (*some View*)

- **SwiftUI only**: `LivePhoto.browser { result in }` (*some View*)

- **SwiftUI only**: `livePhoto.view(size:)` (*some View*)

### Photos

- `Media.Photos.all (includes livePhotos)`

- `Media.Photos.live`

- `Media.Photos.panorama`

- `Media.Photos.hdr`

- `Media.Photos.screenshot`

- `Media.Photos.depthEffect`

#### Photo

- `photo.metadata`
- `photo.subtypes`
- `photo.properties { result in }`
- `photo.data { result in }`
- `photo.uiImage(targetSize:contentMode:) { result in }`
- `Photo.save(Media.URL<Photo>) { result in }`
- `Photo.save(UIImage) { result in }`
- `Photo.with(identifier:) -> Photo? (check for existence if you want)`
- `photo.delete { result in }`
- `photo.favorite(true|false) { result in }`

##### **SwiftUI**

- **SwiftUI only**: `Photo.camera { result in }` (*some View*)

- **SwiftUI only**: `Photo.browser { result in }` (*some View*)

- **SwiftUI only**: `photo.view { image in image.resizable().aspectRatio(contentMode: .fit) }` (*some View*)

### Videos

- `Videos.all`

- `Videos.streams`

- `Videos.highFrameRates`

- `Videos.timelapses`

#### Video

- `video.subtypes`
- `video.metadata`
- `video.properties { result in }`
- `video.playerItem(deliveryMode:) { result in }`
- `video.avAsset(deliveryMode:) { result in }`
- `video.export(options, progress: { progress in }) { result in }`
- `Video.save(Media.URL<Video>) { result in }`
- `Video.with(identifier:) -> Video? (check for existence if you want)`
- `video.favorite(true|false) { result in }`
- `video.delete { result in }`

##### **SwiftUI**

- **SwiftUI only**: `Video.camera { result in }` (*some View*)

- **SwiftUI only**: `Video.browser { result in }` (*some View*)

- **SwiftUI only**: `video.view` (*some View*)

### 🚀 `@propertyWrapper`

The `Media` package also includes some generic property wrappers you can use to interact with the photo library.

- `@FetchAssets(filter:sort:fetchLimit:includeAllBurstAssets:includeHiddenAssets) var assets: [ <Audio | LivePhoto | Photo | Video> ]`

- `@FetchAsset(filter:) var asset: <Audio | LivePhoto | Photo | Video>?`

- `@FetchAlbums(ofType:filter:sort:fetchLimit) var albums: [Album]`

- `@FetchAlbum(filter:) var album: Album?`
