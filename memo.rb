# frozen_string_literal: true

require 'securerandom'
require_relative './app'

# Service to download ftp files FROM the server
class Memo
  attr_accessor :title, :body
  attr_reader :id

  def initialize(title:, body:, id: nil)
    @id    = id
    @title = title
    @body  = body
  end

  def save
    if @id.nil?
      CONN.exec('INSERT INTO memos(title, body) VALUES($1, $2);', [@title, @body])
    else
      CONN.exec('UPDATE memos SET title = $1, body = $2 WHERE id = $3', [@title, @body, @id])
    end
  end

  def destory
    CONN.exec('DELETE FROM memos WHERE id = $1;', [@id])
  end

  def self.all
    CONN.exec('SELECT * FROM memos ORDER BY id;') do |memos|
      memos.map do |memo|
        Memo.new(id: memo['id'], title: memo['title'], body: memo['body'])
      end
    end
  end

  def self.find(id)
    CONN.exec('SELECT * FROM memos WHERE id = $1;', [id]) do |memos|
      if (memo = memos.first)
        Memo.new(id: memo['id'], title: memo['title'], body: memo['body'])
      end
    end
  end
end
