Pod::Spec.new do |s|
    s.name        = "BiometryAuthUI"
    s.version     = "0.0.3"
    s.summary     = "BiometryAuthUI makes it easy to deal with login with biometry"
    s.homepage    = "https://github.com/AntonBelousov/BiometryAuthUI"
    s.license     = { :type => "MIT" }
    s.authors     = { "antbelousov" => "antbelousov@gmail.com" }

    s.requires_arc          = true
    s.ios.deployment_target = "9.0"
    s.source                = { :git => "https://github.com/AntonBelousov/BiometryAuthUI.git", :tag => s.version }
    s.source_files          = 'Source/**/*.{h,m}'
    s.resources             = ['Source/**/*.{xcassets}', 'Source/**/*.{xib}']
end
