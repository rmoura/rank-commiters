require 'spec_helper'
require 'rank-commiters/config'

describe 'RankCommiters::Config' do
  subject { RankCommiters::Config }

  context 'quando não especificado opções de configuração' do
    it 'o atributo access_token deverá ser nil' do
      expect(subject.access_token).to be_nil
    end

    it 'o atributo output_path deverá ser /tmp' do
      expect(subject.output_path).to eql('/tmp')
    end
  end

  context 'quando atributos especificados' do
    before do
      subject.access_token = 'teste3token'
      subject.output_path  = Dir.home
    end

    it 'o valor dos atributos deve ser o mesmo especificado' do
      expect(subject.access_token).to eql('teste3token')
      expect(subject.output_path ).to eql(Dir.home)
    end
  end
end
