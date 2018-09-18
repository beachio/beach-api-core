module BeachApiCore::Admin::ApplicationHelper
  def keepers
    keepers = Doorkeeper::Application.all.to_a.concat(BeachApiCore::Organisation.all)
    keepers.push(BeachApiCore::Instance.current)
    keepers.map { |keeper| [keeper_name(keeper), "#{keeper.class}##{keeper.id}"] }
  end

  def keepers_and_team_keepers
    keepers = Doorkeeper::Application.all.to_a.concat(BeachApiCore::Organisation.all).concat(BeachApiCore::Team.all)
    keepers.push(BeachApiCore::Instance.current)
    keepers.map { |keeper| [keeper_name(keeper), "#{keeper.class}##{keeper.id}"] }
  end

  def webhooks_keeper
    keepers = Doorkeeper::Application.all.to_a
    keepers.push(BeachApiCore::Instance.current)
    keepers.map { |keeper| [keeper_name(keeper), "#{keeper.class}##{keeper.id}"] }
  end

  def keeper_name(keeper)
    case keeper.class.to_s
    when 'BeachApiCore::Instance' then 'Current Instance'
    else
      keeper.class.to_s =~ /(.+)::(.+)/
      "#{Regexp.last_match(2)} - #{keeper.name} (#{keeper.id})"
    end
  end

  def value_for_user(user, field)
    BeachApiCore::ProfileAttribute.find_by(profile: user.profile, profile_custom_field: field)&.value || ''
  end

  def status_options(status)
    %w(Yes No Unsure).inject([]) do |acc, elem|
      option = [elem, elem]
      option << { checked: 'checked' } if elem == status
      acc << option
    end
  end
end
