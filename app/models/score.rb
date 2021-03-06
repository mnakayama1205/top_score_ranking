class Score < ApplicationRecord
  belongs_to :player

  validates :score, presence: true, numericality: true
  validates :time, presence: true

  scope :players, -> (player_names) do
    players = Player.where(player_names)
    where(player[])
  end

  def self.filter(players: nil, before: nil, after: nil, page: nil, limit: nil)
    players = Player.where(name: players&.map(&:capitalize))
    result = Score.all.order(:id)
    result = result.where(player: players.ids) if players.present?
    result = result.where('time < ?', before.to_datetime) if before.present?
    result = result.where('time > ?', after.to_datetime.end_of_day) if after.present?

    if page.present?  && limit.present?
      offset = limit.to_i * (page.to_i - 1)
      result = result.offset(offset).limit(limit)
    end

    result
  end
end
