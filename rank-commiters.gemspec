$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          = 'rank-commiters'
  s.version       = '0.1.0'
  s.summary       = 'Obtem os commits de um projeto e ordena os autores por quantidade de commits'
  s.description   = 'Monta um rank de commiters de um projeto e exporta para um arquivo de saída'
  s.homepage      = 'https://github.com/rmoura/rank-commiters'
  s.license       = 'MIT'

  s.authors       = [ 'Rodney Moura' ]
  s.email         = [ 'rodney.rms@gmail.com' ]

  s.files         = `git ls-files`         .split("\n").reject { |f| f.match(%r{^(spec)/}) }
  s.executables   = `git ls-files -- bin/*`.split("\n").map    { |f| File.basename(f)      }
  s.require_paths = [ 'lib' ]

  s.add_development_dependency 'bundler',      '~> 1.16'
  s.add_development_dependency 'OptionParser', '0.5.1'
end
