# frozen_string_literal: true

require 'securerandom'
require 'pg'

# Service to download ftp files from the server
class Memo
  CONN ||= PG.connect(dbname: 'db_usage')
  attr_accessor :title, :body
  attr_reader :id

  def initialize(title:, body:, id: nil)
    @id    = id
    @title = title
    @body  = body
  end

  def save
    if @id.nil?
      CONN.exec('insert into memos(title, body) values($1, $2);', [@title, @body])
    else
      CONN.exec('update memos set title = $1, body = $2 where id = $3', [@title, @body, @id])
    end
  end

  def destory
    CONN.exec('delete from memos where id = $1;', [@id])
  end

  def self.all
    CONN.exec('select * from memos order by id;') do |memos|
      memos.map do |memo|
        Memo.new(id: memo['id'], title: memo['title'], body: memo['body'])
      end
    end
  end

  def self.find(id)
    CONN.exec('select * from memos where id = $1;', [id]) do |memos|
      if (memo = memos.first)
        Memo.new(id: memo['id'], title: memo['title'], body: memo['body'])
      end
    end
  end
end
