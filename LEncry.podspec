#
#  Be sure to run `pod spec lint LEncry.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LEncry"
  s.version      = "0.0.2"
  s.summary      = "LEncry can AES and RSA with md5 and so on"

  s.description  = <<-DESC
                    LEncry can AES and RSA with md5 and so on,we can deal data with encry operate
                    DESC


  s.homepage     = "https://github.com/mymirror/LEncry"


  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author       = { "mirror" => "852171945@qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/mymirror/LEncry.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

   s.source_files  = "LEncry/LEncry/LEncry.h","LEncry/LEncry/LEncry.m", "LEncry/LEncry/**/*.{h,m}"

   s.public_header_files = "LEncry/LEncry/OpenSSL/opensslIncludes/openssl/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

    s.requires_arc = true

  # s.dependency "JSONKit", "~> 1.4"
    s.vendored_libraries = "LEncry/LEncry/OpenSSL/lib/libcrypto.a","LEncry/LEncry/OpenSSL/lib/libssl.a"



end
