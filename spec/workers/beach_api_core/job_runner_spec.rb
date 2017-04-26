require 'rails_helper'

module BeachApiCore
  describe JobRunner do
    xdescribe 'should send a request with params from given job' do
      let!(:job) { create :job }

      it do
        expect { subject.perform(job.id) }.to change()
      end
    end
  end
end
