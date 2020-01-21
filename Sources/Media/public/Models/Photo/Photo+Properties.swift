//
//  Photo+Properties.swift
//  
//
//  Created by Christian Elies on 21.01.20.
//

import UIKit

extension Photo {
    public struct Properties {
        public let dpiWidth: Int?
        public let dpiHeight: Int?
        public let pixelWidth: Int?
        public let pixelHeight: Int?
        public var primaryImage: Int?
        public let colorModel: String?
        public let profileName: String?
        public let exif: EXIF
        public let gps: GPS
        public let tiff: TIFF

        public struct EXIF {
            public let apertureValue: String?
            public let brightnessValue: String?
            public let colorSpace: Int?
            public let componentsConfiguration: [Int]?
            public var compositeImage: Int?
            public let dateTimeDigitized: String?
            public let dateTimeOriginal: String?
            public let exifVersion: [Int]?
            public let exposureBiasValue: Int?
            public let exposureMode: Int?
            public let exposureProgram: Int?
            public let exposureTime: String?
            public let fNumber: String?
            public let flash: Int?
            public let flashPixVersion: [Int]?
            public let focalLenIn35mmFilm: Int?
            public let focalLength: String?
            public let isoSpeedRatings: [Int]?
            public let lensMake: String?
            public let lensModel: String?
            public let lensSpecification: [String]?
            public let meteringMode: Int?
            public var offsetTime: String?
            public var offsetTimeDigitized: String?
            public var offsetTimeOriginal: String?
            public let pixelXDimension: Int?
            public let pixelYDimension: Int?
            public let sceneCaptureType: Int?
            public let sceneType: Int?
            public let sensingMethod: Int?
            public let shutterSpeedValue: String?
            public let subjectArea: [Int]?
            public let subsecTimeDigitized: Int?
            public let subsecTimeOriginal: Int?
            public let whiteBalance: Int?
        }

        public struct GPS {
            public let altitude: String?
            public let altitudeRef: Int?
            public let destBearing: String?
            public let destBearingRef: String?
            public let hPositioningError: Int?
            public let imgDirection: String?
            public let imgDirectionRef: String?
            public let latitude: String?
            public let latitudeRef: String?
            public let longitude: String?
            public let longitudeRef: String?
            public let speed: Int?
            public let speedRef: String?
        }

        public struct TIFF {
            public let dateTime: String?
            public let make: String?
            public let model: String?
            public let orientation: Int?
            public let resolutionUnit: Int?
            public let software: String?
            public let tileLength: Int?
            public let tileWidth: Int?
            public let xResolution: Int?
            public let yResolution: Int?
        }
    }
}

extension Photo.Properties {
    init(dictionary: [String: Any]) {
        let exifDictionary = dictionary["{Exif}"] as? [String: Any]
        var exif = EXIF(
            apertureValue: exifDictionary?[kCGImagePropertyExifApertureValue as String] as? String,
            brightnessValue: exifDictionary?[kCGImagePropertyExifBrightnessValue as String] as? String,
            colorSpace: exifDictionary?[kCGImagePropertyExifColorSpace as String] as? Int,
            componentsConfiguration: exifDictionary?[kCGImagePropertyExifComponentsConfiguration as String] as? [Int],
            dateTimeDigitized: exifDictionary?[kCGImagePropertyExifDateTimeDigitized as String] as? String,
            dateTimeOriginal: exifDictionary?[kCGImagePropertyExifDateTimeOriginal as String] as? String,
            exifVersion: exifDictionary?[kCGImagePropertyExifVersion as String] as? [Int],
            exposureBiasValue: exifDictionary?[kCGImagePropertyExifExposureBiasValue as String] as? Int,
            exposureMode: exifDictionary?[kCGImagePropertyExifExposureMode as String] as? Int,
            exposureProgram: exifDictionary?[kCGImagePropertyExifExposureProgram as String] as? Int,
            exposureTime: exifDictionary?[kCGImagePropertyExifExposureTime as String] as? String,
            fNumber: exifDictionary?[kCGImagePropertyExifFNumber as String] as? String,
            flash: exifDictionary?[kCGImagePropertyExifFlash as String] as? Int,
            flashPixVersion: exifDictionary?[kCGImagePropertyExifFlashPixVersion as String] as? [Int],
            focalLenIn35mmFilm: exifDictionary?[kCGImagePropertyExifFocalLenIn35mmFilm as String] as? Int,
            focalLength: exifDictionary?[kCGImagePropertyExifFocalLength as String] as? String,
            isoSpeedRatings: exifDictionary?[kCGImagePropertyExifISOSpeedRatings as String] as? [Int],
            lensMake: exifDictionary?[kCGImagePropertyExifLensMake as String] as? String,
            lensModel: exifDictionary?[kCGImagePropertyExifLensModel as String] as? String,
            lensSpecification: exifDictionary?[kCGImagePropertyExifLensSpecification as String] as? [String],
            meteringMode: exifDictionary?[kCGImagePropertyExifMeteringMode as String] as? Int,
            pixelXDimension: exifDictionary?[kCGImagePropertyExifPixelXDimension as String] as? Int,
            pixelYDimension: exifDictionary?[kCGImagePropertyExifPixelYDimension as String] as? Int,
            sceneCaptureType: exifDictionary?[kCGImagePropertyExifSceneCaptureType as String] as? Int,
            sceneType: exifDictionary?[kCGImagePropertyExifSceneType as String] as? Int,
            sensingMethod: exifDictionary?[kCGImagePropertyExifSensingMethod as String] as? Int,
            shutterSpeedValue: exifDictionary?[kCGImagePropertyExifShutterSpeedValue as String] as? String,
            subjectArea: exifDictionary?[kCGImagePropertyExifSubjectArea as String] as? [Int],
            subsecTimeDigitized: exifDictionary?[kCGImagePropertyExifSubsecTimeDigitized as String] as? Int,
            subsecTimeOriginal: exifDictionary?[kCGImagePropertyExifSubsecTimeOrginal as String] as? Int,
            whiteBalance: exifDictionary?[kCGImagePropertyExifWhiteBalance as String] as? Int
        )

        if #available(iOS 13.1, *) {
            exif.compositeImage = exifDictionary?[kCGImagePropertyExifCompositeImage as String] as? Int
        }

        if #available(iOS 13, *) {
            exif.offsetTime = exifDictionary?[kCGImagePropertyExifOffsetTime as String] as? String
            exif.offsetTimeDigitized = exifDictionary?[kCGImagePropertyExifOffsetTimeDigitized as String] as? String
            exif.offsetTimeOriginal = exifDictionary?[kCGImagePropertyExifOffsetTimeOriginal as String] as? String
        }

        let gpsDictionary = dictionary["{GPS}"] as? [String: Any]
        let gps = GPS(
            altitude: gpsDictionary?[kCGImagePropertyGPSAltitude as String] as? String,
            altitudeRef: gpsDictionary?[kCGImagePropertyGPSAltitudeRef as String] as? Int,
            destBearing: gpsDictionary?[kCGImagePropertyGPSDestBearing as String] as? String,
            destBearingRef: gpsDictionary?[kCGImagePropertyGPSDestBearingRef as String] as? String,
            hPositioningError: gpsDictionary?[kCGImagePropertyGPSHPositioningError as String] as? Int,
            imgDirection: gpsDictionary?[kCGImagePropertyGPSImgDirection as String] as? String,
            imgDirectionRef: gpsDictionary?[kCGImagePropertyGPSImgDirectionRef as String] as? String,
            latitude: gpsDictionary?[kCGImagePropertyGPSLatitude as String] as? String,
            latitudeRef: gpsDictionary?[kCGImagePropertyGPSLatitudeRef as String] as? String,
            longitude: gpsDictionary?[kCGImagePropertyGPSLongitude as String] as? String,
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

        if #available(iOS 11, *) {
            properties.primaryImage = dictionary[kCGImagePropertyPrimaryImage as String] as? Int
        }

        self = properties
    }
}
