//
//  Photo+Properties.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

#if canImport(UIKit)
import CoreLocation
import UIKit

extension Photo {
    /// Represents properties / metadata of the underlying
    /// image file, including EXIF, GPS and TIFF data
    ///
    public struct Properties {
        /// The resolution, in dots per inch, in the y dimension.
        /// If present, this key is a CFNumber value.
        ///
        public let dpiWidth: Int?
        /// The resolution, in dots per inch, in the x dimension.
        /// If present, this key is a CFNumber value.
        ///
        public let dpiHeight: Int?
        /// The number of pixels in the x dimension.
        /// If present, this key is a CFNumber value.
        ///
        public let pixelWidth: Int?
        /// The number of pixels in the y dimension.
        /// If present, this key is a CFNumber value.
        ///
        public let pixelHeight: Int?
        /// No overview available
        public var primaryImage: Int?
        /// The color model of the image such as, RGB, CMYK, Gray, or Lab.
        /// The value of this key is of type CFStringRef.
        public let colorModel: String?
        /// The name of the optional ICC profile embedded in the image, if known.
        /// If present, the value of this key is of type CFStringRef.
        public let profileName: String?
        /// Exchangeable Image File Format data
        public let exif: EXIF
        /// Global Positioning System (GPS) data
        public let gps: GPS
        /// Tagged Image File Format data
        public let tiff: TIFF

        /// Keys for an image that uses Exchangeable Image File Format (EXIF).
        ///
        public struct EXIF {
            /// The aperture value.
            public let apertureValue: Double?
            /// The brightness value.
            public let brightnessValue: Double?
            /// The color space.
            public let colorSpace: Int?
            /// The components configuration. For compressed data, specifies that
            /// the channels of each component are arranged in increasing
            ///  numeric order (from first component to the fourth).
            ///
            public let componentsConfiguration: [Int]?
            /// No overview available
            public var compositeImage: Int?
            /// The digitized date and time.
            public let dateTimeDigitized: String?
            /// The original date and time.
            public let dateTimeOriginal: String?
            /// The Exif version.
            public let exifVersion: [Int]?
            /// The exposure bias value.
            public let exposureBiasValue: Int?
            /// The exposure mode setting.
            public let exposureMode: Int?
            /// The exposure program.
            public let exposureProgram: Int?
            /// The exposure time.
            public let exposureTime: Double?
            /// The F-number.
            public let fNumber: Double?
            /// The flash status when the image was shot.
            public let flash: Int?
            /// The FlashPix version supported by an FPXR file. FlashPix is a
            /// format for multiresolution tiled images that facilitates
            /// fast onscreen viewing.
            ///
            public let flashPixVersion: [Int]?
            /// The equivalent focal length in 35 mm film.
            public let focalLenIn35mmFilm: Int?
            /// The focal length.
            public let focalLength: Double?
            /// The ISO speed ratings.
            public let isoSpeedRatings: [Int]?
            /// The value associated with this key is a string that provides the name of the lens’s manufacturer.
            public let lensMake: String?
            /// The value associated with this key is a string that provides the lens’s model.
            public let lensModel: String?
            /// The values associated with this key provide the specification information for
            /// the lens used to photograph the image.
            ///
            public let lensSpecification: [Double]?
            /// The metering mode.
            public let meteringMode: Int?
            /// No overview available
            public var offsetTime: String?
            /// No overview available
            public var offsetTimeDigitized: String?
            /// No overview available
            public var offsetTimeOriginal: String?
            /// The x dimension of a pixel.
            public let pixelXDimension: Int?
            /// The y dimension of a pixel.
            public let pixelYDimension: Int?
            /// The scene capture type (standard, landscape, portrait, night).
            public let sceneCaptureType: Int?
            /// The scene type.
            public let sceneType: Int?
            /// The sensor type of the camera or input device.
            public let sensingMethod: Int?
            /// The shutter speed value.
            public let shutterSpeedValue: Double?
            /// The subject area.
            public let subjectArea: [Int]?
            /// The fraction of seconds for the digitized time and date tag.
            public let subsecTimeDigitized: String?
            /// The fraction of seconds for the original date and time tag.
            public let subsecTimeOriginal: String?
            /// The white balance mode.
            public let whiteBalance: Int?
        }

        /// Keys for an image that has Global Positioning System (GPS) information.
        ///
        public struct GPS {
            /// The altitude.
            public let altitude: Double?
            /// The reference altitude.
            public let altitudeRef: Int?
            /// The bearing to the destination point.
            public let destBearing: Double?
            /// The reference for giving the bearing to the destination point.
            public let destBearingRef: String?
            /// No overview available
            public let hPositioningError: Int?
            /// The direction of the image.
            public let imgDirection: Double?
            /// The reference for the direction of the image.
            public let imgDirectionRef: String?
            /// The latitude.
            public let latitude: Double?
            /// Whether the latitude is north or south.
            public let latitudeRef: String?
            /// The longitude.
            public let longitude: Double?
            /// Whether the longitude is east or west.
            public let longitudeRef: String?
            /// The GPS receiver speed of movement.
            public let speed: Int?
            /// The unit for expressing the GPS receiver speed of movement.
            public let speedRef: String?

            /// Computes a `CLLocation` if the underlying
            /// latitude and longitude values are present
            ///
            public var location: CLLocation? {
                guard let latitude = latitude else { return nil }
                guard let longitude = longitude else { return nil }
                return CLLocation(latitude: latitude, longitude: longitude)
            }
        }

        /// Keys for an image that uses Tagged Image File Format (TIFF).
        ///
        public struct TIFF {
            /// The date and time that the image was created.
            public let dateTime: String?
            /// The name of the manufacturer of the camera or input device.
            public let make: String?
            /// The camera or input device model.
            public let model: String?
            /// The image orientation.
            public let orientation: Int?
            /// The units of resolution.
            public let resolutionUnit: Int?
            /// The name and version of the software used for image creation.
            public let software: String?
            /// No overview available
            public let tileLength: Int?
            /// No overview available
            public let tileWidth: Int?
            /// The number of pixels per resolution unit in the image width direction.
            public let xResolution: Int?
            /// The number of pixels per resolution unit in the image height direction.
            public let yResolution: Int?
        }
    }
}

extension Photo.Properties {
    init(dictionary: [String: Any]) {
        let exifDictionary = dictionary["{Exif}"] as? [String: Any]
        var exif = EXIF(
            apertureValue: exifDictionary?[kCGImagePropertyExifApertureValue as String] as? Double,
            brightnessValue: exifDictionary?[kCGImagePropertyExifBrightnessValue as String] as? Double,
            colorSpace: exifDictionary?[kCGImagePropertyExifColorSpace as String] as? Int,
            componentsConfiguration: exifDictionary?[kCGImagePropertyExifComponentsConfiguration as String] as? [Int],
            dateTimeDigitized: exifDictionary?[kCGImagePropertyExifDateTimeDigitized as String] as? String,
            dateTimeOriginal: exifDictionary?[kCGImagePropertyExifDateTimeOriginal as String] as? String,
            exifVersion: exifDictionary?[kCGImagePropertyExifVersion as String] as? [Int],
            exposureBiasValue: exifDictionary?[kCGImagePropertyExifExposureBiasValue as String] as? Int,
            exposureMode: exifDictionary?[kCGImagePropertyExifExposureMode as String] as? Int,
            exposureProgram: exifDictionary?[kCGImagePropertyExifExposureProgram as String] as? Int,
            exposureTime: exifDictionary?[kCGImagePropertyExifExposureTime as String] as? Double,
            fNumber: exifDictionary?[kCGImagePropertyExifFNumber as String] as? Double,
            flash: exifDictionary?[kCGImagePropertyExifFlash as String] as? Int,
            flashPixVersion: exifDictionary?[kCGImagePropertyExifFlashPixVersion as String] as? [Int],
            focalLenIn35mmFilm: exifDictionary?[kCGImagePropertyExifFocalLenIn35mmFilm as String] as? Int,
            focalLength: exifDictionary?[kCGImagePropertyExifFocalLength as String] as? Double,
            isoSpeedRatings: exifDictionary?[kCGImagePropertyExifISOSpeedRatings as String] as? [Int],
            lensMake: exifDictionary?[kCGImagePropertyExifLensMake as String] as? String,
            lensModel: exifDictionary?[kCGImagePropertyExifLensModel as String] as? String,
            lensSpecification: exifDictionary?[kCGImagePropertyExifLensSpecification as String] as? [Double],
            meteringMode: exifDictionary?[kCGImagePropertyExifMeteringMode as String] as? Int,
            pixelXDimension: exifDictionary?[kCGImagePropertyExifPixelXDimension as String] as? Int,
            pixelYDimension: exifDictionary?[kCGImagePropertyExifPixelYDimension as String] as? Int,
            sceneCaptureType: exifDictionary?[kCGImagePropertyExifSceneCaptureType as String] as? Int,
            sceneType: exifDictionary?[kCGImagePropertyExifSceneType as String] as? Int,
            sensingMethod: exifDictionary?[kCGImagePropertyExifSensingMethod as String] as? Int,
            shutterSpeedValue: exifDictionary?[kCGImagePropertyExifShutterSpeedValue as String] as? Double,
            subjectArea: exifDictionary?[kCGImagePropertyExifSubjectArea as String] as? [Int],
            subsecTimeDigitized: exifDictionary?[kCGImagePropertyExifSubsecTimeDigitized as String] as? String,
            subsecTimeOriginal: exifDictionary?[kCGImagePropertyExifSubsecTimeOrginal as String] as? String,
            whiteBalance: exifDictionary?[kCGImagePropertyExifWhiteBalance as String] as? Int
        )

        if #available(iOS 13.1, macOS 10.15, tvOS 13.1, *) {
            exif.compositeImage = exifDictionary?[kCGImagePropertyExifCompositeImage as String] as? Int
        }

        if #available(iOS 13, macOS 10.15, tvOS 13, *) {
            exif.offsetTime = exifDictionary?[kCGImagePropertyExifOffsetTime as String] as? String
            exif.offsetTimeDigitized = exifDictionary?[kCGImagePropertyExifOffsetTimeDigitized as String] as? String
            exif.offsetTimeOriginal = exifDictionary?[kCGImagePropertyExifOffsetTimeOriginal as String] as? String
        }

        let gpsDictionary = dictionary["{GPS}"] as? [String: Any]
        let gps = GPS(
            altitude: gpsDictionary?[kCGImagePropertyGPSAltitude as String] as? Double,
            altitudeRef: gpsDictionary?[kCGImagePropertyGPSAltitudeRef as String] as? Int,
            destBearing: gpsDictionary?[kCGImagePropertyGPSDestBearing as String] as? Double,
            destBearingRef: gpsDictionary?[kCGImagePropertyGPSDestBearingRef as String] as? String,
            hPositioningError: gpsDictionary?[kCGImagePropertyGPSHPositioningError as String] as? Int,
            imgDirection: gpsDictionary?[kCGImagePropertyGPSImgDirection as String] as? Double,
            imgDirectionRef: gpsDictionary?[kCGImagePropertyGPSImgDirectionRef as String] as? String,
            latitude: gpsDictionary?[kCGImagePropertyGPSLatitude as String] as? Double,
            latitudeRef: gpsDictionary?[kCGImagePropertyGPSLatitudeRef as String] as? String,
            longitude: gpsDictionary?[kCGImagePropertyGPSLongitude as String] as? Double,
            longitudeRef: gpsDictionary?[kCGImagePropertyGPSLongitudeRef as String] as? String,
            speed: gpsDictionary?[kCGImagePropertyGPSSpeed as String] as? Int,
            speedRef: gpsDictionary?[kCGImagePropertyGPSSpeedRef as String] as? String
        )

        let tiffDictionary = dictionary["{TIFF}"] as? [String: Any]
        let tiff = TIFF(
            dateTime: tiffDictionary?[kCGImagePropertyTIFFDateTime as String] as? String,
            make: tiffDictionary?[kCGImagePropertyTIFFMake as String] as? String,
            model: tiffDictionary?[kCGImagePropertyTIFFModel as String] as? String,
            orientation: tiffDictionary?[kCGImagePropertyTIFFOrientation as String] as? Int,
            resolutionUnit: tiffDictionary?[kCGImagePropertyTIFFResolutionUnit as String] as? Int,
            software: tiffDictionary?[kCGImagePropertyTIFFSoftware as String] as? String,
            tileLength: tiffDictionary?[kCGImagePropertyTIFFTileLength as String] as? Int,
            tileWidth: tiffDictionary?[kCGImagePropertyTIFFTileWidth as String] as? Int,
            xResolution: tiffDictionary?[kCGImagePropertyTIFFXResolution as String] as? Int,
            yResolution: tiffDictionary?[kCGImagePropertyTIFFYResolution as String] as? Int
        )

        var properties = Self(
            dpiWidth: dictionary[kCGImagePropertyDPIWidth as String] as? Int,
            dpiHeight: dictionary[kCGImagePropertyDPIHeight as String] as? Int,
            pixelWidth: dictionary[kCGImagePropertyPixelWidth as String] as? Int,
            pixelHeight: dictionary[kCGImagePropertyPixelHeight as String] as? Int,
            colorModel: dictionary[kCGImagePropertyColorModel as String] as? String,
            profileName: dictionary[kCGImagePropertyProfileName as String] as? String,
            exif: exif,
            gps: gps,
            tiff: tiff
        )

        if #available(iOS 11, macOS 10.15, tvOS 11, *) {
            properties.primaryImage = dictionary[kCGImagePropertyPrimaryImage as String] as? Int
        }

        self = properties
    }
}
#endif
