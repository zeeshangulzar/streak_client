Gem::Specification.new do |s|
  s.name        = "streak_client"
  s.version     = "0.1.8"
  s.date        = "2018-04-27"
  s.summary     = "Streak API Client"
  s.description = "Client for the Streak REST API"
  s.authors     = ["Aleksandar Abu Samra"]
  s.files       = Dir.glob("lib/**/*.rb")
  s.license     = "MIT"
  s.homepage    = "https://github.com/aaleksandar/streak_client"

  s.add_dependency("rest-client")
  s.add_dependency("multi_json")
end
