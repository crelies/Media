# Media

A **beautiful**, **declarative** and **convenient** *wrapper API* for Apple's `PhotoKit`

What I don't like about `PhotoKit` is that it's *not declarative* and that developers have to *think about too many details*.
That's why I created this Swift package which will dramatically *improve the readability* of your `PhotoKit` code.

Each *type* in `PhotoKit` got it's own *wrapper type*:

- Album
- Audio
- LivePhoto
- Photo
- Video

That's all you need to know. Now take a look at the **API**.

## API

Get started by adding the `Media` Swift package to your project and by importing it.

### Media

- `Media.requestPermission { result in }`

- `Media.isAccessAllowed`

- `Media.currentPermission`

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

### LivePhotos

- `LivePhotos.all`

#### LivePhoto

- `livePhoto.displayRepresentation(targetSize:contentMode) { result in }`

- `LivePhoto.save(URL) { result in }`

- `LivePhoto.with(identifier:) -> LivePhoto? (check for existence if you want)`

- `livePhoto.delete { result in }`

- TODO: livePhoto.edit

- **SwiftUI only**: `LivePhoto.camera { result in }` (*some View*)

### Photo

- `Photo.all (includes livePhotos)`

- `Photo.panorama`

- `Photo.hdr`

- `Photo.screenshot`

- `Photo.depthEffect`

- `photo.data { result in }`

- `Photo.save(URL) { result in }`

- `Photo.save(UIImage) { result in }`

- `Photo.with(identifier:) -> Photo? (check for existence if you want)`

- `photo.delete { result in }`

- TODO: photo.edit

- **SwiftUI only**: `Photo.camera { result in }` (*some View*)

### Videos

- `Videos.all`

- `Videos.streams`

- `Videos.highFrameRates`

- `Videos.timelapses`

#### Video

- `video.playerItem { result in }`

- `Video.save(URL) { result in }`

- `Video.with(identifier:) -> Video? (check for existence if you want)`

- TODO: video.edit

- `video.delete { result in }`

- **SwiftUI only**: `Video.camera { result in }` (*some View*)
