# frozen_string_literal: true

require 'minitest/autorun'
require_relative './memo'

# Service to download ftp files from the server
class MemoTest < Minitest::Test
  def setup
    id = Memo.read_csv[-1][0]
    @memo = Memo.find(id)
  end

  def test_find
    assert @memo
    refute Memo.find('fdsa')
  end

  def test_all
    assert Memo.all
  end

  def test_read_csv
    assert Memo.read_csv
  end

  def test_create
    hoge_title = 'hoge title1'
    hoge_body = 'hoge body1'
    memo = Memo.new(title: hoge_title, body: hoge_body)
    memo.save
    memo2 = Memo.find(memo.id)
    assert_equal memo2.title, hoge_title
    assert_equal memo2.body,  hoge_body
  end

  def test_update
    hoge_title = 'これすげ'
    hoge_body = 'マジすげ'
    @memo.title = hoge_title
    @memo.body = hoge_body
    @memo.save
    rows = Memo.read_csv
    assert_equal rows[-1][1], hoge_title
    assert_equal rows[-1][2], hoge_body
  end

  def test_destroy
    assert @memo
    @memo.destory
    refute Memo.find(@memo.id)
  end
end
