require 'rails_helper'

module BeachApiCore
  describe 'V1::Atom', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    before do
      create :assignment, role: (create :role, name: 'admin'), user: oauth_user, keeper: BeachApiCore::Instance.current
    end

    describe 'when create' do
      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_atoms_path }
      end

      it_behaves_like 'an forbidden resource' do
        before { post beach_api_core.v1_atoms_path, params: { atom: { title: Faker::Name.title, kind: 'item' } },
                      headers: developer_bearer_auth }
      end

      it 'should successfully create an atom' do
        expect { post beach_api_core.v1_atoms_path, params: { atom: { title: Faker::Name.title, kind: 'item' } },
                      headers: bearer_auth }
            .to change(Atom, :count).by(1)
        expect(response.status).to eq 201
        expect(json_body[:atom]).to be_present
      end
    end

    describe 'when update' do
      let!(:atom) { create :atom }
      let(:new_title) { Faker::Name.title }
      let(:new_kind) { Faker::Lorem.word }

      it_behaves_like 'an authenticated resource' do
        before { put beach_api_core.v1_atoms_path, params: { id: atom.id } }
      end

      it_behaves_like 'an forbidden resource' do
        before { put beach_api_core.v1_atoms_path, params: { id: atom.id, atom: { title: new_title } },
                     headers: developer_bearer_auth }
      end

      it 'should successfully update an atom' do
        put beach_api_core.v1_atoms_path, params: { id: atom.id, atom: { title: new_title } }, headers: bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:atom][:title]).to eq new_title
        put beach_api_core.v1_atoms_path, params: { name: atom.name, atom: { kind: new_kind } }, headers: bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:atom][:kind]).to eq new_kind
      end

      it 'should return 404' do
        put beach_api_core.v1_atoms_path, params: { name: 'some_name', atom: { title: new_title } }, headers: bearer_auth
        expect(response.status).to eq 404
        put beach_api_core.v1_atoms_path, params: { id: '', atom: { title: new_title } }, headers: bearer_auth
        expect(response.status).to eq 404
      end
    end

    describe 'when show' do
      let!(:atom) { create :atom }
      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_atom_path(atom) }
      end

      it_behaves_like 'an forbidden resource' do
        before { get beach_api_core.v1_atom_path(atom), headers: developer_bearer_auth }
      end

      it 'should return an atom' do
        get beach_api_core.v1_atom_path(atom), headers: bearer_auth
        expect(response.status).to eq(200)
        expect(json_body[:atom]).to be_present
        expect(json_body[:atom].keys).to include(:id, :title, :atom_parent_id, :kind)
      end
    end

    describe 'when destroy' do
      let!(:atom) { create :atom }
      let(:other_atom) { create :atom }

      it 'should successfully destroy an atom' do
        delete beach_api_core.v1_atoms_path, params: { id: atom.id }, headers: bearer_auth
        expect(response.status).to eq(200)
        expect(Atom.find_by(id: atom.id)).to be_blank
        delete beach_api_core.v1_atoms_path, params: { name: other_atom.name }, headers: bearer_auth
        expect(response.status).to eq(200)
        expect(Atom.find_by(id: other_atom.id)).to be_blank
      end

      it_behaves_like 'an forbidden resource' do
        before { delete beach_api_core.v1_atoms_path, params: { id: atom.id }, headers: developer_bearer_auth }
      end
    end

    describe 'when index' do
      before { create_list :atom, 3 }

      it_behaves_like 'an forbidden resource' do
        before { get beach_api_core.v1_atoms_path, headers: developer_bearer_auth }
      end

      it 'should return list of atoms' do
        get beach_api_core.v1_atoms_path, headers: bearer_auth
        expect(response.status).to eq(200)
        expect(json_body[:atoms].size).to eq 3
      end
    end
  end
end