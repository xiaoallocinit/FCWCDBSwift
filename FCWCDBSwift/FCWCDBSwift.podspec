# pod lib lint --verbose --allow-warnings FCWCDBSwift.podspec
# pod trunk push --verbose --allow-warnings FCWCDBSwift.podspec
Pod::Spec.new do |wcdb|
  wcdb.name         = "FCWCDBSwift"
  wcdb.version      = "1.0.0"
  wcdb.summary      = "This is the copy of WCDB, which is a cross-platform database framework developed by WeChat."
  wcdb.description  = <<-DESC
                      The WeChat Database, for Swift. 
                      It can be a replacement for Core Data, SQLite & FMDB.
                      DESC
  wcdb.homepage     = "https://github.com/xiaoallocinit/FCWCDBSwift.swift"
  wcdb.license      = { :type => "BSD", :file => "LICENSE" }
  wcdb.author             = { "xiao2683" => "xiao2683@qq.com" }
  wcdb.ios.deployment_target = "9.0"
  wcdb.osx.deployment_target = "10.9"
  wcdb.watchos.deployment_target = "2.0"
  wcdb.tvos.deployment_target = "9.0"
  wcdb.source       = { :git => "https://github.com/xiaoallocinit/FCWCDBSwift.swift.git", :tag => wcdb.version }
  wcdb.source_files  = "source/**/*.swift", "source/**/**/*.swift", "source/util/*.{h,c}"
  wcdb.module_name = "WCDBSwift"
  wcdb.requires_arc = true
  wcdb.pod_target_xcconfig = { 
    "GCC_PREPROCESSOR_DEFINITIONS" => "SQLITE_HAS_CODEC WCDB_BUILTIN_SQLCIPHER",
    'SWIFT_WHOLE_MODULE_OPTIMIZATION' => 'YES',
    'APPLICATION_EXTENSION_API_ONLY' => 'YES',
    "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/WCDBSwift",
    "LIBRARY_SEARCH_PATHS[sdk=macosx*]" => "$(SDKROOT)/usr/lib/system",
    "OTHER_SWIFT_FLAGS[config=Release][sdk=iphonesimulator*]" => "-D WCDB_IOS",
    "OTHER_SWIFT_FLAGS[config=Release][sdk=iphoneos*]" => "-D WCDB_IOS",
    "OTHER_SWIFT_FLAGS[config=Debug]" => "-D DEBUG",
    "OTHER_SWIFT_FLAGS[config=Debug][sdk=iphonesimulator*]" => "-D WCDB_IOS -D DEBUG",
    "OTHER_SWIFT_FLAGS[config=Debug][sdk=iphoneos*]" => "-D WCDB_IOS -D DEBUG",
  }
  wcdb.swift_version = '5.0'
  wcdb.dependency 'WCDBOptimizedSQLCipher', '~> 1.2.0'
  wcdb.dependency 'SQLiteRepairKit', '~> 1.2.0'
end
