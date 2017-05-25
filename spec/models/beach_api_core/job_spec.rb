require 'rails_helper'

module BeachApiCore
  describe Job, type: :model do
    subject { build :job }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      job = build :job, start_at: nil, every: nil
      expect(job).to be_invalid
      expect(job.errors.messages.keys).to include(:start_at)
      expect(build(:job, start_at: 2.hours.since, every: nil)).to be_valid
      expect(build(:job, start_at: nil, every: '1.hour')).to be_valid
    end

    it 'should validate that headers, method and uri are present in params hash' do
      %i(headers method uri).each do |param|
        job = build :job
        job.params.delete(param)
        expect(job).to be_invalid
        expect(job.errors.messages.keys).to include(:params)
      end
    end

    it 'should validate format of `every`' do
      expect(build(:job, every: '1.hour')).to be_valid
      expect(build(:job, every: '2.days')).to be_valid
      expect(build(:job, every: '1 hour')).to be_invalid
    end

    describe 'should perform cron jobs' do
      subject { Job }

      before do
        create :job, last_run: nil, every: '1.hour'
        create :job, last_run: 1.hour.ago, every: '1.hour'
        create :job, last_run: Time.now, every: '1.hour'
        create :job, last_run: 1.hour.ago, every: '2.hours'
      end

      it do
        expect { subject.perform_cron }.to change(JobRunner.jobs, :size).by(2)
      end
    end
  end
end
