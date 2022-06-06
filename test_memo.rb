# frozen_string_literal: true

require 'minitest/autorun'
require_relative './memo'

# Service to download ftp files from the server
class MemoTest < Minitest::Test
  CONN ||= PG.connect(dbname: 'db_usage')
  def setup
    CONN.exec('delete from memos')
    @setup_title = 'setup title'
    @setup_body = 'setup body'
    CONN.exec('insert into memos(title, body) values($1, $2)', [@setup_title, @setup_body])
  end

  def test_find
    CONN.exec('select id from memos where title = $1 and body = $2;', [@setup_title, @setup_body]) do |result|
      memo = result.first
      assert_equal 'setup title', Memo.find(memo['id']).title
      assert_equal 'setup body',  Memo.find(memo['id']).body
    end
    refute Memo.find(-100)
  end

  def test_all
    assert Memo.all
  end

  def test_create
    create_test_title = 'create test title'
    create_test_body = 'create test body'
    before_memos = Memo.all
    memo = Memo.new(title: create_test_title, body: create_test_body)
    memo.save
    after_memos = Memo.all
    assert_equal create_test_title, after_memos.last.title
    assert_equal create_test_body, after_memos.last.body
    assert_equal after_memos.size, before_memos.size + 1
  end

  def test_update
    update_test_title = 'update test title'
    update_test_body = 'update test body'
    id = Memo.all.last.id
    before_memo = Memo.find(id)
    before_memo.title = update_test_title
    before_memo.body  = update_test_body
    before_memo.save
    after_memo = Memo.find(id)
    assert_equal update_test_title, after_memo.title
    assert_equal update_test_body,  after_memo.body
  end

  def test_destory
    before_memos = Memo.all
    memo = Memo.find(before_memos.last.id)
    memo.destory
    assert_equal Memo.all.size, before_memos.size - 1
  end
end
