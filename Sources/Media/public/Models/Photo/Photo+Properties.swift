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
        var exif = EXIF(
            apertureValue: dictionary[kCGImagePropertyExifApertureValue as String] as? String,
            brightnessValue: dictionary[kCGImagePropertyExifBrightnessValue as String] as? String,
            colorSpace: dictionary[kCGImagePropertyExifColorSpace as String] as? Int,
            componentsConfiguration: dictionary[kCGImagePropertyExifComponentsConfiguration as String] as? [Int],
            dateTimeDigitized: dictionary[kCGImagePropertyExifDateTimeDigitized as String] as? String,
            dateTimeOriginal: dictionary[kCGImagePropertyExifDateTimeOriginal as String] as? String,
            exifVersion: dictionary[kCGImagePropertyExifVersion as String] as? [Int],
            exposureBiasValue: dictionary[kCGImagePropertyExifExposureBiasValue as String] as? Int,
            exposureMode: dictionary[kCGImagePropertyExifExposureMode as String] as? Int,
            exposureProgram: dictionary[kCGImagePropertyExifExposureProgram as String] as? Int,
            exposureTime: dictionary[kCGImagePropertyExifExposureTime as String] as? String,
            fNumber: dictionary[kCGImagePropertyExifFNumber as String] as? String,
            flash: dictionary[kCGImagePropertyExifFlash as String] as? Int,
            flashPixVersion: dictionary[kCGImagePropertyExifFlashPixVersion as String] as? [Int],
            focalLenIn35mmFilm: dictionary[kCGImagePropertyExifFocalLenIn35mmFilm as String] as? Int,
            focalLength: dictionary[kCGImagePropertyExifFocalLength as String] as? String,
            isoSpeedRatings: dictionary[kCGImagePropertyExifISOSpeedRatings as String] as? [Int],
            lensMake: dictionary[kCGImagePropertyExifLensMake as String] as? String,
            lensModel: dictionary[kCGImagePropertyExifLensModel as String] as? String,
            lensSpecification: dictionary[kCGImagePropertyExifLensSpecification as String] as? [String],
            meteringMode: dictionary[kCGImagePropertyExifMeteringMode as String] as? Int,
            pixelXDimension: dictionary[kCGImagePropertyExifPixelXDimension as String] as? Int,
            pixelYDimension: dictionary[kCGImagePropertyExifPixelYDimension as String] as? Int,
            sceneCaptureType: dictionary[kCGImagePropertyExifSceneCaptureType as String] as? Int,
            sceneType: dictionary[kCGImagePropertyExifSceneType as String] as? Int,
            sensingMethod: dictionary[kCGImagePropertyExifSensingMethod as String] as? Int,
            shutterSpeedValue: dictionary[kCGImagePropertyExifShutterSpeedValue as String] as? String,
            subjectArea: dictionary[kCGImagePropertyExifSubjectArea as String] as? [Int],
            subsecTimeDigitized: dictionary[kCGImagePropertyExifSubsecTimeDigitized as String] as? Int,
            subsecTimeOriginal: dictionary[kCGImagePropertyExifSubsecTimeOrginal as String] as? Int,
            whiteBalance: dictionary[kCGImagePropertyExifWhiteBalance as String] as? Int
        )

        if #available(iOS 13.1, *) {
            exif.compositeImage = dictionary[kCGImagePropertyExifCompositeImage as String] as? Int
        }

        if #available(iOS 13, *) {
            exif.offsetTime = dictionary[kCGImagePropertyExifOffsetTime as String] as? String
            exif.offsetTimeDigitized = dictionary[kCGImagePropertyExifOffsetTimeDigitized as String] as? String
            exif.offsetTimeOriginal = dictionary[kCGImagePropertyExifOffsetTimeOriginal as String] as? String
        }

        let gps = GPS(
            altitude: dictionary[kCGImagePropertyGPSAltitude as String] as? String,
            altitudeRef: dictionary[kCGImagePropertyGPSAltitudeRef as String] as? Int,
            destBearing: dictionary[kCGImagePropertyGPSDestBearing as String] as? String,
            destBearingRef: dictionary[kCGImagePropertyGPSDestBearingRef as String] as? String,
            hPositioningError: dictionary[kCGImagePropertyGPSHPositioningError as String] as? Int,
            imgDirection: dictionary[kCGImagePropertyGPSImgDirection as String] as? String,
            imgDirectionRef: dictionary[kCGImagePropertyGPSImgDirectionRef as String] as? String,
            latitude: dictionary[kCGImagePropertyGPSLatitude as String] as? String,
            latitudeRef: dictionary[kCGImagePropertyGPSLatitudeRef as String] as? String,
            longitude: dictionary[kCGImagePropertyGPSLongitude as String] as? String,
            longitudeRef: dictionary[kCGImagePropertyGPSLongitudeRef as String] as? String,
            speed: dictionary[kCGImagePropertyGPSSpeed as String] as? Int,
            speedRef: dictionary[kCGImagePropertyGPSSpeedRef as String] as? String
        )

        let tiff = TIFF(
            dateTime: dictionary[kCGImagePropertyTIFFDateTime as String] as? String,
            make: dictionary[kCGImagePropertyTIFFMake as String] as? String,
            model: dictionary[kCGImagePropertyTIFFModel as String] as? String,
            orientation: dictionary[kCGImagePropertyTIFFOrientation as String] as? Int,
            resolutionUnit: dictionary[kCGImagePropertyTIFFResolutionUnit as String] as? Int,
            software: dictionary[kCGImagePropertyTIFFSoftware as String] as? String,
            tileLength: dictionary[kCGImagePropertyTIFFTileLength as String] as? Int,
            tileWidth: dictionary[kCGImagePropertyTIFFTileWidth as String] as? Int,
            xResolution: dictionary[kCGImagePropertyTIFFXResolution as String] as? Int,
            yResolution: dictionary[kCGImagePropertyTIFFYResolution as String] as? Int
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
