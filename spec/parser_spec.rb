require 'spec_helper'
require 'rank-commiters/probe'
require 'rank-commiters/parser'

describe 'RankCommiters.Parser' do
  let(:probe)            { RankCommiters::Probe.new }
  let(:repo_existente)   { 'Dinda-com-br/braspag-rest' }
  let(:repo_inexistente) { 'Dinda-com-br/inexistentes' }
  let(:repo_empty)       { 'teste/teste' }
  let(:limite_excedido)  { 'Dinda-com-br/octopus' }

  before { RankCommiters::Config.access_token = nil }

  context 'quando repositório existente' do
    let(:results) do
      VCR.use_cassette('repo_existente') { probe.query(repo_existente) }
    end

    subject { RankCommiters.Parser(results) }

    it { expect(subject).to an_instance_of(Hash) }
    it { expect(subject).to include(status: 'Sucesso') }
    it { expect(subject).to include(commiters: an_instance_of(Hash)) }

    context 'an commiter' do
      let(:commiter) { subject[:commiters].first }

      it do
        expect(commiter).to include(
          {
            name:          be_a(String),
            email:         match(/[a-z]+@[a-z.]+/),
            login:         be_a(String),
            avatar_url:    match(%r[http(s)?://[a-z.]+]),
            commits_count: be_a(Integer)
          }
        )
      end
    end
  end

  context 'quando repositório não encontrado' do
    let(:results) do
      VCR.use_cassette('repo_inexistente') { probe.query(repo_inexistente) }
    end

    subject { RankCommiters.Parser(results) }

    it { expect(subject).to include(status: 'Repositório Não Encontrado') }
    it { expect(subject).to include(commiters: be_empty) }
  end

  context 'quando limite de acessos excedido' do
    let(:results) do
      VCR.use_cassette('limite_excedido') { probe.query(limite_excedido) }
    end

    subject { RankCommiters.Parser(results) }

    it { expect(subject).to include(status: 'Limite de Acessos Excedido') }
    it { expect(subject).to include(commiters: be_empty) }
  end

  context 'quando repositório sem commits' do
    let(:results) do
      VCR.use_cassette('repo_empty') { probe.query(repo_empty) }
    end

    subject { RankCommiters.Parser(results) }

    it { expect(subject).to include(status: 'Repositório Vázio (Sem Commits)') }
    it { expect(subject).to include(commiters: be_empty) }
  end

  context 'quando parâmetro de autenticação inválido' do
    let(:results) do
      RankCommiters::Config.access_token = 'invalid'
      VCR.use_cassette('access_token_invalido') { probe.query(repo_existente) }
    end

    subject { RankCommiters.Parser(results) }

    it { expect(subject).to include(status: 'Acesso Não Autorizado') }
    it { expect(subject).to include(commiters: be_empty) }
  end
end
