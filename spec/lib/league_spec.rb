require_relative '../spec_helper.rb'

describe Clashinator::League do

  let(:league_ok) { Clashinator::League.league_info('29000022') }
  let(:league_list) { Clashinator::League.list_leagues(limit: 1) }

  describe 'when League class exists' do
    it 'must have a Base Class parent' do
      Clashinator::League.superclass.must_equal Clashinator::Base
    end
  end

  describe 'when list_leagues class method exists' do
    it 'must have a class method named list_leagues' do
      Clashinator::League.must_respond_to 'list_leagues'
    end

    it 'must return an ArrayResource of league instances' do
      league_list.must_be_instance_of Clashinator::ArrayResource
      league_list.items.length.wont_equal 0
      league_list.items.first.must_be_instance_of Clashinator::League
      league_list.items.first.must_respond_to 'id'
      league_list.items.first.must_respond_to 'name'
      league_list.items.first.must_respond_to 'icon_urls'
    end

    it 'must have array hash attributes as objects' do
      league_list.items.first
                 .icon_urls.must_be_instance_of Clashinator::BadgeUrl
    end

    it 'must raise an error when wrong paging params are given' do
      lambda do
        Clashinator::League.list_leagues(
          limit: 1, after: '2938383838', before: '2938383838'
        ).must_raise ArgumentError
      end
    end
  end

  describe 'when league_info class method exists' do
    it 'must include a class method named league_info' do
      Clashinator::League.must_respond_to 'league_info'
    end

    it 'must return an instance of league' do
      league_ok.must_be_instance_of Clashinator::League
      league_ok.must_respond_to 'id'
      league_ok.must_respond_to 'name'
      league_ok.must_respond_to 'icon_urls'
    end

    it 'must have array hash attributes as objects' do
      league_ok.icon_urls.must_be_instance_of Clashinator::BadgeUrl
    end

    it 'must raise an error when wrong league_id is provided' do
      -> { Clashinator::League.league_info('2222222222222') }
        .must_raise RuntimeError
    end
  end

  describe 'when league_seasons class method exists' do
    it 'must include a class method named league_seasons' do
      Clashinator::League.must_respond_to 'league_seasons'
    end

    it 'must return an ArrayResource of season instances' do
      seasons = Clashinator::League.league_seasons('29000022', limit: 1)
      seasons.must_be_instance_of Clashinator::ArrayResource
      seasons.items.length.wont_equal 0
      seasons.items.first.must_be_instance_of Clashinator::Season
    end

    it 'must raise an error when wrong paging params are given' do
      lambda do
        Clashinator::League.league_seasons(
          '29000022', limit: 1, after: '2938383838', before: '2938383838'
        ).must_raise ArgumentError
      end
    end

    it 'must raise an error when league_id is different than Legend League' do
      -> { Clashinator::League.league_seasons('29000012', limit: 1) }
        .must_raise RuntimeError
    end

    it 'must raise an error when wrong league_id is provided' do
      -> { Clashinator::League.league_seasons('2222222222222', limit: 1) }
        .must_raise RuntimeError
    end
  end

  describe 'when league_season_rankings class method exists' do
    it 'must include a class method named league_season_rankings' do
      Clashinator::League.must_respond_to 'league_season_rankings'
    end

    it 'must return an ArrayResource of ranking instances' do
      rankings = Clashinator::League.league_season_rankings(
        '29000022', '2015-10', limit: 1
      )
      rankings.must_be_instance_of Clashinator::ArrayResource
      rankings.items.first.must_be_instance_of Clashinator::PlayerRanking
    end

    it 'must raise an error when wrong paging params are given' do
      lambda do
        Clashinator::League.league_season_rankings(
          '29000022', '2015-10',
          limit: 1, after: '2938383838', before: '2938383838'
        ).must_raise ArgumentError
      end
    end

    it 'must raise an error when league_id is different than Legend League' do
      lambda do
        Clashinator::League
          .league_season_rankings('29000012', '2015-10', limit: 1)
          .must_raise ArgumentError
      end
    end

    it 'must raise an error when wrong league_id is provided' do
      lambda do
        Clashinator::League
          .league_season_rankings('2222222222222', '2015-10', limit: 1)
          .must_raise ArgumentError
      end
    end

    it 'must raise an error when wrong season_id is provided' do
      lambda do
        Clashinator::League
          .league_season_rankings('29000022', '2222222222222', limit: 1)
          .must_raise ArgumentError
      end
    end
  end
end
