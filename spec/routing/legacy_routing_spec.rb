require 'rails_helper'

RSpec.describe 'Legacy', type: :request do
  describe '/map.html' do
    subject! { get('/map.html') }

    it { is_expected.to redirect_to('/en/map') }
  end

  describe '/cheque' do
    subject! { get('/cheque') }

    it { is_expected.to redirect_to('https://monero-map.org/cheque/') }
  end

  describe '/crypto_box' do
    subject! { get('/crypto_box') }

    it { is_expected.to redirect_to('https://monero-map.org/crypto_box/') }
  end

  describe '/epicerie' do
    subject! { get('/epicerie') }

    it { is_expected.to redirect_to('https://libre-market.com/m/epicerie') }
  end

  describe '/les-marchands/:id' do
    subject! { get('/les-marchands/1234-foobar') }

    it { is_expected.to redirect_to('/fr/merchants/1234-foobar') }
  end

  describe '/commercants/:id' do
    subject! { get('/commercants/1234-foobar') }

    it { is_expected.to redirect_to('/fr/merchants/1234-foobar') }
  end

  describe '/les-groupes-locaux' do
    subject! { get('/les-groupes-locaux') }

    it { is_expected.to redirect_to('/fr/local_groups') }
  end

  describe '/groupes-locaux' do
    subject! { get('/groupes-locaux') }

    it { is_expected.to redirect_to('/fr/local_groups') }
  end

  describe '/les-projets' do
    subject! { get('/les-projets') }

    it { is_expected.to redirect_to('/fr/projects') }
  end

  describe '/les-projets/:id' do
    subject! { get('/les-projets/1234-foobar') }

    it { is_expected.to redirect_to('/fr/projects/1234-foobar') }
  end

  describe '/projets/:id' do
    subject! { get('/projets/1234-foobar') }

    it { is_expected.to redirect_to('/fr/projects/1234-foobar') }
  end

  describe '/compta' do
    subject! { get('/compta') }

    it { is_expected.to redirect_to('/fr/tutorials/accounting') }
  end

  describe '/comptabilite' do
    subject! { get('/comptabilite') }

    it { is_expected.to redirect_to('/fr/tutorials/accounting') }
  end

  describe '/tutoriels/accounting' do
    subject! { get('/tutoriels/accounting') }

    it { is_expected.to redirect_to('/fr/tutorials/accounting') }
  end

  describe '/commercants/new' do
    subject! { get('/commercants/new') }

    it { is_expected.to redirect_to('/fr/merchant_proposals/new') }
  end

  describe '/glossaire' do
    subject! { get('/glossaire') }

    it { is_expected.to redirect_to('/fr/glossaries') }
  end

  describe '/annuaire' do
    subject! { get('/annuaire') }

    it { is_expected.to redirect_to('/fr/directories') }
  end

  describe '/risques' do
    subject! { get('/risques') }

    it { is_expected.to redirect_to('/fr/risks') }
  end

  describe '/foire-aux-questions' do
    subject! { get('/foire-aux-questions') }

    it { is_expected.to redirect_to('/fr/faq') }
  end

  describe '/en/accounting' do
    subject! { get('/en/accounting') }

    it { is_expected.to redirect_to('/en/tutorials/accounting') }
  end

  describe '/en/merchants/new' do
    subject! { get('/en/merchants/new') }

    it { is_expected.to redirect_to('/en/merchant_proposals/new') }
  end

  describe '/frequently-asked-questions' do
    subject! { get('/frequently-asked-questions') }

    it { is_expected.to redirect_to('/en/faq') }
  end

  describe '/en/frequently-asked-questions' do
    subject! { get('/en/frequently-asked-questions') }

    it { is_expected.to redirect_to('/en/faq') }
  end

  describe '/glossary' do
    subject! { get('/glossary') }

    it { is_expected.to redirect_to('/en/glossaries') }
  end

  describe '/en/glossary' do
    subject! { get('/en/glossary') }

    it { is_expected.to redirect_to('/en/glossaries') }
  end

  describe '/stats' do
    subject! { get('/stats') }

    it { is_expected.to redirect_to('/en/stats') }
  end

  describe '/map/embed' do
    context 'without query parameters' do
      subject! { get('/map/embed') }

      it { is_expected.to redirect_to('/en/map/embed') }
    end

    context 'with query parameters' do
      subject! { get('/map/embed?coins[]=june') }

      it { is_expected.to redirect_to('/en/map/embed?coins[]=june') }
    end
  end

  describe '/es/los-comerciantes/:id' do
    subject! { get('/es/los-comerciantes/1234-foobar') }

    it { is_expected.to redirect_to('/es/merchants/1234-foobar') }
  end

  describe '/es/comerciantes/:id' do
    subject! { get('/es/comerciantes/1234-foobar') }

    it { is_expected.to redirect_to('/es/merchants/1234-foobar') }
  end

  describe '/es/los-grupos-locales' do
    subject! { get('/es/los-grupos-locales') }

    it { is_expected.to redirect_to('/es/local_groups') }
  end

  describe '/es/grupos-locales' do
    subject! { get('/es/grupos-locales') }

    it { is_expected.to redirect_to('/es/local_groups') }
  end

  describe '/es/los-proyectos' do
    subject! { get('/es/los-proyectos') }

    it { is_expected.to redirect_to('/es/projects') }
  end

  describe '/es/los-proyectos/:id' do
    subject! { get('/es/los-proyectos/1234-foobar') }

    it { is_expected.to redirect_to('/es/projects/1234-foobar') }
  end

  describe '/es/proyectos/:id' do
    subject! { get('/es/proyectos/1234-foobar') }

    it { is_expected.to redirect_to('/es/projects/1234-foobar') }
  end

  describe '/es/contabilidad' do
    subject! { get('/es/contabilidad') }

    it { is_expected.to redirect_to('/es/tutorials/accounting') }
  end

  describe '/es/tutoriales/accounting' do
    subject! { get('/es/tutoriales/accounting') }

    it { is_expected.to redirect_to('/es/tutorials/accounting') }
  end

  describe '/es/comerciantes/new' do
    subject! { get('/es/comerciantes/new') }

    it { is_expected.to redirect_to('/es/merchant_proposals/new') }
  end

  describe '/es/el-colectivo' do
    subject! { get('/es/el-colectivo') }

    it { is_expected.to redirect_to('/es/collective') }
  end

  describe '/es/glosario' do
    subject! { get('/es/glosario') }

    it { is_expected.to redirect_to('/es/glossaries') }
  end

  describe '/es/anuario' do
    subject! { get('/es/anuario') }

    it { is_expected.to redirect_to('/es/directories') }
  end

  describe '/es/riesgos' do
    subject! { get('/es/riesgos') }

    it { is_expected.to redirect_to('/es/risks') }
  end

  describe '/es/preguntas-mas-frecuentes' do
    subject! { get('/es/preguntas-mas-frecuentes') }

    it { is_expected.to redirect_to('/es/faq') }
  end

  describe '/c' do
    context 'when /c does not have get params' do
      subject! { get('/c') }

      it { is_expected.to redirect_to('https://monero-map.org/c/') }
    end

    context 'when /c have get params' do
      subject! { get('/c/?foo=bar') }

      it { is_expected.to redirect_to('https://monero-map.org/c/?foo=bar') }
    end
  end

  describe '/:locale/projects/accounting' do
    subject! { get('/fr/projects/accounting') }

    it { is_expected.to redirect_to('/fr/tutorials/accounting') }
  end

  describe '/:locale/blogs/flyer' do
    subject! { get('/fr/blogs/flyer') }

    it { is_expected.to redirect_to('/fr/projects/flyer') }
  end

  describe '/:locale/projects/local_groups' do
    subject! { get('/fr/projects/local_groups') }

    it { is_expected.to redirect_to('/fr/local_groups') }
  end
end
