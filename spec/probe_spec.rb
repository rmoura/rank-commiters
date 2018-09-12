require 'spec_helper'
require 'rank-commiters/probe'

describe RankCommiters::Probe do
  let(:probe)            { RankCommiters::Probe.new }
  let(:repo_existente)   { 'Dinda-com-br/braspag-rest' }
  let(:repo_inexistente) { 'Dinda-com-br/inexistentes' }
  let(:repo_empty)       { 'teste/teste' }
  let(:limite_excedido)  { 'Dinda-com-br/octopus' }

  before { RankCommiters::Config.access_token = nil }

  describe '#query' do
    context 'quando repositório existente' do
      subject do
        VCR.use_cassette('repo_existente') { probe.query(repo_existente) }
      end

      it { expect(subject).to an_instance_of(Array) }
      it { expect(subject).to all(an_instance_of Net::HTTPOK) }
    end

    context 'repositório não encontrado' do
      subject do
        VCR.use_cassette('repo_inexistente') { probe.query(repo_inexistente) }
      end

      it do
        expect(subject).to match(
          a_collection_containing_exactly(an_instance_of Net::HTTPNotFound)
        )
      end
    end

    context 'repositório sem commits' do
      subject do
        VCR.use_cassette('repo_empty') { probe.query(repo_empty) }
      end

      it do
        expect(subject).to match(
          a_collection_containing_exactly(an_instance_of Net::HTTPConflict)
        )
      end
    end

    context 'quando limite de acessos excedido' do
      subject do
        VCR.use_cassette('limite_excedido') { probe.query(limite_excedido) }
      end

      it do
        expect(subject).to match(
          a_collection_containing_exactly(an_instance_of Net::HTTPForbidden)
        )
      end
    end

    context 'quando parâmetro de autenticação inválido' do
      subject do
        VCR.use_cassette('access_token_invalido') { probe.query(repo_existente) }
      end

      before { RankCommiters::Config.access_token = 'invalid' }

      it do
        expect(subject).to match(
          a_collection_containing_exactly(an_instance_of Net::HTTPUnauthorized)
        )
      end
    end
  end
end
