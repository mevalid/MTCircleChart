Pod::Spec.new do |spec|
  spec.name = "MTCircleChart"
  spec.version = "1.0.0"
  spec.summary = "Multi type circle chart."
  spec.description  = "Circle chart with percentage slide template. Can be used for diagram, graph, chart, report, data visualization, presentation."
  
  spec.homepage = "https://github.com/mevalid/MTCircleChart"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Mirela" => "mevalid224@gmail.com" }

  spec.source       = { :git => "https://github.com/mevalid/MTCircleChart.git", :tag => spec.version }
  spec.source_files  = "MTCircleChart", "MTCircleChart/**/*.{h,m}"
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  spec.swift_version = '>= 4.0'
  spec.platform = :ios, "9.0"
end