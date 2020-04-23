//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map(Locale.init)
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try font.validate()
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 5 colors.
  struct color {
    /// Color `background`.
    static let background = Rswift.ColorResource(bundle: R.hostingBundle, name: "background")
    /// Color `default-text`.
    static let defaultText = Rswift.ColorResource(bundle: R.hostingBundle, name: "default-text")
    /// Color `gray-text`.
    static let grayText = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray-text")
    /// Color `inverse-text`.
    static let inverseText = Rswift.ColorResource(bundle: R.hostingBundle, name: "inverse-text")
    /// Color `turquoise`.
    static let turquoise = Rswift.ColorResource(bundle: R.hostingBundle, name: "turquoise")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "background", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func background(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.background, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "default-text", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func defaultText(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.defaultText, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray-text", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func grayText(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.grayText, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "inverse-text", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func inverseText(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.inverseText, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "turquoise", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func turquoise(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.turquoise, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 4 files.
  struct file {
    /// Resource file `SF-Pro-Display-Bold.otf`.
    static let sfProDisplayBoldOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "SF-Pro-Display-Bold", pathExtension: "otf")
    /// Resource file `SF-Pro-Display-Medium.otf`.
    static let sfProDisplayMediumOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "SF-Pro-Display-Medium", pathExtension: "otf")
    /// Resource file `SF-Pro-Display-Regular.otf`.
    static let sfProDisplayRegularOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "SF-Pro-Display-Regular", pathExtension: "otf")
    /// Resource file `SF-Pro-Display-Semibold.otf`.
    static let sfProDisplaySemiboldOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "SF-Pro-Display-Semibold", pathExtension: "otf")

    /// `bundle.url(forResource: "SF-Pro-Display-Bold", withExtension: "otf")`
    static func sfProDisplayBoldOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.sfProDisplayBoldOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "SF-Pro-Display-Medium", withExtension: "otf")`
    static func sfProDisplayMediumOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.sfProDisplayMediumOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "SF-Pro-Display-Regular", withExtension: "otf")`
    static func sfProDisplayRegularOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.sfProDisplayRegularOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "SF-Pro-Display-Semibold", withExtension: "otf")`
    static func sfProDisplaySemiboldOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.sfProDisplaySemiboldOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 4 fonts.
  struct font: Rswift.Validatable {
    /// Font `SFProDisplay-Bold`.
    static let sfProDisplayBold = Rswift.FontResource(fontName: "SFProDisplay-Bold")
    /// Font `SFProDisplay-Medium`.
    static let sfProDisplayMedium = Rswift.FontResource(fontName: "SFProDisplay-Medium")
    /// Font `SFProDisplay-Regular`.
    static let sfProDisplayRegular = Rswift.FontResource(fontName: "SFProDisplay-Regular")
    /// Font `SFProDisplay-Semibold`.
    static let sfProDisplaySemibold = Rswift.FontResource(fontName: "SFProDisplay-Semibold")

    /// `UIFont(name: "SFProDisplay-Bold", size: ...)`
    static func sfProDisplayBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: sfProDisplayBold, size: size)
    }

    /// `UIFont(name: "SFProDisplay-Medium", size: ...)`
    static func sfProDisplayMedium(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: sfProDisplayMedium, size: size)
    }

    /// `UIFont(name: "SFProDisplay-Regular", size: ...)`
    static func sfProDisplayRegular(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: sfProDisplayRegular, size: size)
    }

    /// `UIFont(name: "SFProDisplay-Semibold", size: ...)`
    static func sfProDisplaySemibold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: sfProDisplaySemibold, size: size)
    }

    static func validate() throws {
      if R.font.sfProDisplayBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'SFProDisplay-Bold' could not be loaded, is 'SF-Pro-Display-Bold.otf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.sfProDisplayMedium(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'SFProDisplay-Medium' could not be loaded, is 'SF-Pro-Display-Medium.otf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.sfProDisplayRegular(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'SFProDisplay-Regular' could not be loaded, is 'SF-Pro-Display-Regular.otf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.sfProDisplaySemibold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'SFProDisplay-Semibold' could not be loaded, is 'SF-Pro-Display-Semibold.otf' added to the UIAppFonts array in this targets Info.plist?") }
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 7 images.
  struct image {
    /// Image `AR graph logo`.
    static let arGraphLogo = Rswift.ImageResource(bundle: R.hostingBundle, name: "AR graph logo")
    /// Image `camera`.
    static let camera = Rswift.ImageResource(bundle: R.hostingBundle, name: "camera")
    /// Image `left-arrow-welcome-menu`.
    static let leftArrowWelcomeMenu = Rswift.ImageResource(bundle: R.hostingBundle, name: "left-arrow-welcome-menu")
    /// Image `nextPlot`.
    static let nextPlot = Rswift.ImageResource(bundle: R.hostingBundle, name: "nextPlot")
    /// Image `prevPlot`.
    static let prevPlot = Rswift.ImageResource(bundle: R.hostingBundle, name: "prevPlot")
    /// Image `sandbox`.
    static let sandbox = Rswift.ImageResource(bundle: R.hostingBundle, name: "sandbox")
    /// Image `topic-placeholder`.
    static let topicPlaceholder = Rswift.ImageResource(bundle: R.hostingBundle, name: "topic-placeholder")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "AR graph logo", bundle: ..., traitCollection: ...)`
    static func arGraphLogo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arGraphLogo, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "camera", bundle: ..., traitCollection: ...)`
    static func camera(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.camera, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "left-arrow-welcome-menu", bundle: ..., traitCollection: ...)`
    static func leftArrowWelcomeMenu(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.leftArrowWelcomeMenu, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "nextPlot", bundle: ..., traitCollection: ...)`
    static func nextPlot(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.nextPlot, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "prevPlot", bundle: ..., traitCollection: ...)`
    static func prevPlot(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.prevPlot, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "sandbox", bundle: ..., traitCollection: ...)`
    static func sandbox(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sandbox, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "topic-placeholder", bundle: ..., traitCollection: ...)`
    static func topicPlaceholder(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.topicPlaceholder, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `EquationCell`.
    static let equationCell = _R.nib._EquationCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "EquationCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.equationCell) instead")
    static func equationCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.equationCell)
    }
    #endif

    static func equationCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EquationCell? {
      return R.nib.equationCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EquationCell
    }

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `EquationCell`.
    static let equationCell: Rswift.ReuseIdentifier<EquationCell> = Rswift.ReuseIdentifier(identifier: "EquationCell")

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib {
    struct _EquationCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = EquationCell

      let bundle = R.hostingBundle
      let identifier = "EquationCell"
      let name = "EquationCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EquationCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EquationCell
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "AR graph logo", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'AR graph logo' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "background", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'background' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
