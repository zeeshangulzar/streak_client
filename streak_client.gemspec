Gem::Specification.new do |s|
  s.name        = "streak_client"
  s.version     = "0.1.4"
  s.date        = "2017-08-30"
  s.summary     = "Streak API Client"
  s.description = "Client for the Streak REST API"
  s.authors     = ["Aleksandar Abu Samra"]
  s.files       = Dir.glob("lib/**/*.rb")
  s.license     = "MIT"
  s.homepage    = "https://github.com/aaleksandar/streak_client"

  s.add_dependency("rest-client")
  s.add_dependency("multi_json")
end
