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

      context 'atom parent' do
        before { @atom_parent = create :atom  }

        it 'should set an atom parent' do
          [@atom_parent.id, @atom_parent.name].each do |value|
            expect { post beach_api_core.v1_atoms_path, params: { atom: { title: Faker::Name.title, kind: 'item',
                                                                          atom_parent_id: value } },
                          headers: bearer_auth }
              .to change(Atom, :count).by(1)
            expect(response.status).to eq 201
            expect(json_body[:atom]).to be_present
            expect(json_body[:atom][:atom_parent_id]).to be_present
            expect(Atom.last.atom_parent).to be_present
          end
        end
      end
    end

    describe 'when update' do
      let!(:atom) { create :atom }
      let(:new_title) { Faker::Name.title }
      let(:new_name) { Faker::Lorem.word }

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
        put beach_api_core.v1_atoms_path, params: { id: atom.name, atom: { name: new_name } }, headers: bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:atom][:name]).to eq new_name
      end

      it 'should return 404' do
        put beach_api_core.v1_atoms_path, params: { id: 'some_name', atom: { title: new_title } }, headers: bearer_auth
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
        expect(json_body[:atom].keys).to include(:id, :title, :atom_parent_id, :kind, :actions)
      end
    end

    describe 'when destroy' do
      let!(:atom) { create :atom }
      let(:other_atom) { create :atom }

      it 'should successfully destroy an atom' do
        delete beach_api_core.v1_atoms_path, params: { id: atom.id }, headers: bearer_auth
        expect(response.status).to eq(200)
        expect(Atom.find_by(id: atom.id)).to be_blank
        delete beach_api_core.v1_atoms_path, params: { id: other_atom.name }, headers: bearer_auth
        expect(response.status).to eq(200)
        expect(Atom.find_by(id: other_atom.id)).to be_blank
      end

      it_behaves_like 'an forbidden resource' do
        before { delete beach_api_core.v1_atoms_path, params: { id: atom.id }, headers: developer_bearer_auth }
      end
    end

    describe 'when index' do
      let(:user) { create :user, :with_organisation }
      let(:kind) { Faker::Lorem.word }

      before do
        create :assignment, user: user, keeper: BeachApiCore::Instance.current
        create :permission, atom: (create :atom, kind: kind), actions: { update: true }, keeper: user
        create :permission, atom: (create :atom, kind: kind), actions: { update: true, execute: true }, keeper: (create :role)
        create :permission, atom: (create :atom, kind: kind), actions: { update: true, create: true }, keeper: user.roles.first
        create :permission, atom: (create :atom, kind: kind), actions: { update: true, create: true }, keeper: oauth_user.roles.first
        create :permission, atom: (create :atom, kind: kind), actions: { create: true }, keeper: (create :user)
        create :permission, atom: (create :atom), actions: { create: true, update: true }, keeper: (create :user)
        create :permission, atom: (create :atom, kind: kind), actions: { create: true, update: true }, keeper: user
        create :permission, atom: (create :atom, kind: kind), actions: { create: true, update: true }, keeper: user.organisations.first
      end

      it_behaves_like 'an forbidden resource' do
        before { get beach_api_core.v1_atoms_path, headers: developer_bearer_auth }
      end

      it 'should return list of atoms' do
        get beach_api_core.v1_atoms_path,
            params: { user_id: user.id, kind: kind, actions: %w(create update) }, headers: bearer_auth
        expect(response.status).to eq(200)
        expect(json_body[:atoms].all? { |a| a[:actions].present? }).to be_truthy
        expect(json_body[:atoms].size).to eq 3
        get beach_api_core.v1_atoms_path,
            params: { kind: kind, actions: %w(create update) }, headers: bearer_auth
        expect(response.status).to eq(200)
        expect(json_body[:atoms].size).to eq 1
      end
    end
  end
end
