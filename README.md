# Media 🖼️

A **beautiful**, **declarative** and **convenient** *wrapper API* for Apple's `PhotoKit`

What I don't like about `PhotoKit` is that it's *not declarative* and that developers have to *think about too many details*.
That's why I created this Swift package which will dramatically *improve the readability* of your `PhotoKit` code.

Each *type* in `PhotoKit` got it's own *wrapper type*:

- Album
- Audio
- LivePhoto
- Photo
- Video

**`SwiftUI` special:** This package provides ready-to-use `SwiftUI` views, like a `Camera` view or a view for an instance of  `LivePhoto`, `Photo` and `Video`.

That's all you need to know. Now take a look at the **API**.

## API 🧭

Get started by adding the `Media` Swift package to your project and by importing it.

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

- `album.audios`

- `album.livePhotos`

- `album.photos`

- `album.videos`

- `album.allMedia`

##### **C**reate & **R**ead

- `Album.create(title:) { result in }`

- `Album.with(identifier:) -> Album?`

- `Album.with(title:) -> Album?` (check for existence if you want)`

##### **U**pdate & **D**elete

- `album.add(audio|livePhoto|photo|video) { result in }`

- `album.delete(audio|livePhoto|photo|video) { result in }`

- `album.delete { result in }`

### Audios

- `Audios.all`

#### Audio

- `Audio.with(identifier:) - > Audio? (check for existence if you want)`

- `audio.delete { result in }`

### Camera

- **SwiftUI only**: `Camera.view { result in }` (*some View*)

### LivePhoto

- `livePhoto.displayRepresentation(targetSize:contentMode) { result in }`

- `LivePhoto.save(stillImageData:livePhotoMovieURL:) { result in }`

- `LivePhoto.with(identifier:) -> LivePhoto? (check for existence if you want)`

- `livePhoto.delete { result in }`

- `livePhoto.favorite(true|false) { result in }`

##### **SwiftUI**

- **SwiftUI only**: `LivePhoto.camera()` (*some View*)

- **SwiftUI only**: `LivePhoto.browser { result in }` (*some View*)

- **SwiftUI only**: `livePhoto.view(size:)` (*some View*)

### (Media.)Photos

- `Photos.all (includes livePhotos)`

- `Photos.live`

- `Photos.panorama`

- `Photos.hdr`

- `Photos.screenshot`

- `Photos.depthEffect`

#### Photo

- `photo.data { result in }`

- `photo.uiImage(targetSize:contentMode:) { result in }`

- `Photo.save(URL) { result in }`

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

- `video.playerItem(deliveryMode:) { result in }`

- `video.avAsset(deliveryMode:) { result in }`

- `video.export(options, progress: { progress in }) { result in }`

- `Video.save(URL) { result in }`

- `Video.with(identifier:) -> Video? (check for existence if you want)`

- `video.favorite(true|false) { result in }`

- `video.delete { result in }`

##### **SwiftUI**

- **SwiftUI only**: `Video.camera { result in }` (*some View*)

- **SwiftUI only**: `Video.editor` (*some View*)

- **SwiftUI only**: `Video.browser { result in }` (*some View*)

- **SwiftUI only**: `video.view` (*some View*)

### `@propertyWrapper` 🚀

The `Media` package also includes some generic property wrappers you can use to interact with the photo library.

- `@FetchAssets(filter:sort::fetchLimit) var assets: [ <Audio | LivePhoto | Photo | Video> ]`

- `@FetchAsset(filter:) var asset: <Audio | LivePhoto | Photo | Video>?`

- `@FetchAlbums(ofType:filter:sort:fetchLimit) var albums: [Album]`

- `@FetchAlbum(filter:) var album: Album?`
