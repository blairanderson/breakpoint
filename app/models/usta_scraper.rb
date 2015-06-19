class UstaScraper
  attr_reader :agent, :team_number, :year
  attr_accessor :locations, :team_names

  def initialize(team_number, year)
    Chronic.time_class = Time.zone
    @agent = Mechanize.new

    @team_number = team_number
    @year = year
    @current_page = team_page
    @locations = []
    @team_names = []
    load_teams
  end

  def team_page
    @team_page ||= agent.get "http://tennislink.usta.com/leagues/Main/StatsAndStandings.aspx?t=R-3&par1=#{team_number}&par2=#{year}"
  end

  def team_name
    return @team_name if @team_name.present?
    name = team_page.search(".TeamSummaryDetail h1").text.squish
    # name should look like Team: Bass River;Kroondyk/LaPierre
    name_and_captain = name.split(":")[1].squish
    locations << extract_location
    @team_name = { name: name_and_captain.split(";").first, name_and_captain: name_and_captain }
  end

  def load_teams
    return_link = team_page.link_with(text: team_name[:name_and_captain]).node
    rows = team_page.search("#TeamSummary").search('tr')
    # skip the header and empty footer rows with [1...-1]
    rows[1...-1].map do |row|
      name_and_captain = row.search('td').first.search('a').first
      name_with_captain = name_and_captain.text.squish
      name = name_with_captain.split(";").first
      unless name == team_name[:name]
        click_javascript_link(name_and_captain)
        locations << extract_location
      end
      team_names << { name: name, name_and_captain: name_with_captain }
    end
    click_javascript_link(return_link)
  end

  def extract_location
    row_with_location    = @current_page.search('.TeamSummaryTable tr')[3]
    column_with_location = row_with_location.search('td')[2]
    name_and_address     = column_with_location.inner_html.split('<br>')
    name                 = name_and_address[0].try(:squish)
    address              = name_and_address[1].try(:squish)
    { name: Nokogiri::HTML(name).text, address: Nokogiri::HTML(address).text }
  end

  def find_location(location)
    locations.select { |l| l[:name] == location }.first
  end

  def find_opponent(home_team, visiting_team)
    if home_team == team_name[:name]
      visiting_team
    else
      home_team
    end
  end

  def match_schedule_page
    click_javascript_link(team_page.link_with(text: "Match Schedule").node)
  end

  def matches
    rows = match_schedule_page.search('.panes').search('table').last.search('tr')
    # skip the header and empty footer rows with [1...-1]
    rows[1...-1].map do |row|
      columns        = row.search('td')
      match_id       = columns[0].search('a').text
      scheduled_date = columns[1].text
      scheduled_time = columns[2].text
      match_date     = Chronic.parse("#{scheduled_date} #{scheduled_time}")
      home_team      = columns[3].text.squish.split(";").first
      visiting_team  = columns[5].text.squish.split(";").first
      location       = find_location(columns[7].text.squish)
      next if home_team == "Bye" || visiting_team == "Bye"
      {
        match_id: match_id,
        match_date: match_date,
        home: home_team == team_name[:name],
        opponent: find_opponent(home_team, visiting_team),
        location: location
      }
    end.compact
  end

  def match_dates
    matches.map { |m| m[:match_date] }
  end

  def click_back_to_previous_page
    click_javascript_link(@current_page.link_with(text: "Back to Previous Page").node)
  end

  def click_javascript_link(link)
    form = @current_page.forms.first
    event_data = extract_postback_data(link)
    form.add_field! "__EVENTTARGET", event_data[:event_target]
    form.add_field! "__EVENTARGUMENT", event_data[:event_argument]
    @current_page = form.submit
  end

  # href will look like: javascript:__doPostBack('ctl00$mainContent$lnkMatchSummaryForTeams','')
  def extract_postback_data(link)
    # grab the params to the __doPostBack method call, use to submit the form
    match = link.attr('href').match(/'(.*?)','(.*?)'/)
    { event_target: match[1], event_argument: match[2] }
  end
end

