# frozen_string_literal: true

require 'csv'
require 'securerandom'

# Service to download ftp files from the server
class Memo
  CSV_NAME = 'rows.csv'
  attr_accessor :id, :title, :body

  def initialize(title:, body:, id: nil)
    @id    = id
    @title = title
    @body  = body
  end

  def save
    rows = Memo.read_csv
    rows.map! do |row|
      row[0] == id ? [@id, @title, @body] : row
    end
    rows.push([@id = SecureRandom.hex(20), @title, @body]) unless id
    Memo.write_csv(rows)
  end

  def destory
    rows = Memo.read_csv
    rows.delete_if { |row| row[0] == id }
    Memo.write_csv(rows)
  end

  class << self
    def all
      Memo.read_csv.map! { |row| Memo.new(id: row[0], title: row[1], body: row[2]) }
    end

    def find(id)
      memo = nil
      CSV.foreach(CSV_NAME) do |row|
        memo = Memo.new(id: row[0], title: row[1], body: row[2]) if row[0] == id
      end
      memo
    end

    def write_csv(rows)
      CSV.open(CSV_NAME, 'w') do |csv|
        rows.each { |row| csv << row }
      end
    end

    def read_csv
      CSV.read(CSV_NAME)
    end
  end
end
