class UstaImporter
  attr_reader :team, :matches

  def initialize(team_id, matches)
    @team = Team.find(team_id)
    @matches = matches
  end

  def import
    ActsAsTenant.with_tenant(team) do
      Match.transaction do
        existing_matche_dates = Match.pluck(:date).map(&:beginning_of_day)
        matches.each do |match|
          next if match[:match_date].past?
          next if existing_matche_dates.include?(match[:match_date].beginning_of_day)
          m               = team.matches.build
          m.usta_match_id = match[:match_id]
          m.date          = match[:match_date]
          m.home_team     = match[:home]
          m.opponent      = match[:opponent]
          m.location      = "#{match[:location][:name]}\n#{match[:location][:address]}" if match[:location].present?
          m.save!
        end
      end
    end
  end
end

# format from UstaScraper
#[{
#  :match_id=>"1004148635",
#  :match_date=>"Mon, 19 May 2014 12:30:00 EDT -04:00",
#  :home=>true,
#  :opponent=>"Woburn",
#  :location=>{:name=>"Bass River Tennis Club Inc.", :address=>"31 Tozer Rd Beverly MA 01915"}
#}]

