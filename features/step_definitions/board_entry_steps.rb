Given /^"(.*)"で"(.*)"つめのブログにアクセスする$/ do |user, num|
  Given %!"#{user}"でログインする!
  entry = @entries[num.to_i - 1]
  visit url_for(:controller => "user", :entry_id => entry[:id], :action => "blog", :uid => entry[:uid])
end

Given /^"(.*)"でブログを書く$/ do |user|
  @entries ||= []
  Given %!"#{user}"でログインする!
  Given %!"ブログを書く"リンクをクリックする!
  Given %!"#{"board_entry[title]"}"に"#{"test"+(@entries.size+1).to_s}"と入力する!
  Given %!"#{"editor_mode_hiki"}"を選択する!
  Given %!"#{"contents_hiki"}"に"#{"test"}"と入力する!
  Given %!"#{"作成"}"ボタンをクリックする!
  entry = BoardEntry.last
  @entries << { :id => entry.id, :uid => entry.symbol.split(":").last }
end

Given /^以下のブログを書く:$/ do |entries_table|
  @entries ||= []
  entries_table.hashes.each do |hash|
    Given %!"#{hash[:user]}"でログインする!
    Given %!"ブログを書く"リンクをクリックする!
    Given %!"#{"board_entry[title]"}"に"#{hash[:title]}"と入力する!
    Given %!"タグ"に"#{hash[:tag]}"と入力する!
    Given %!"#{"editor_mode_hiki"}"を選択する!
    Given %!"#{"contents_hiki"}"に"#{"test"}"と入力する!
    Given %!"#{hash[:publication_type]}"を選択する!  if hash[:publication_type]
    Given %!"#{"作成"}"ボタンをクリックする!
    entry = BoardEntry.last
    @entries << { :id => entry.id, :uid => entry.symbol.split(":").last }
  end
end

Given /^以下のフォーラムを書く:$/ do |entries_table|
  @entries ||= []
  entries_table.hashes.each do |hash|
    Given %!"#{hash[:user]}"でログインする!
    Given %!"#{hash[:user]}"で"#{hash[:group]}"というグループを作成する!
    Given %!"記事を書く"リンクをクリックする!
    Given %!"#{"board_entry[title]"}"に"#{hash[:title]}"と入力する!
    Given %!"タグ"に"#{hash[:tag]}"と入力する!
    Given %!"#{"editor_mode_hiki"}"を選択する!
    Given %!"#{"contents_hiki"}"に"#{"test"}"と入力する!
    Given %!"#{hash[:publication_type]}"を選択する!
    Given %!"#{"作成"}"ボタンをクリックする!
    entry = BoardEntry.last
    @entries << { :id => entry.id, :uid => entry.symbol.split(":").last }
  end
end

Given /^"([^\"]*)"で"([^\"]*)"を直接指定したブログを書く$/ do |user, publication_symbol|
  @entries ||= []
  Given %!"#{user}"でログインする!
  Given %!"ブログを書く"リンクをクリックする!
  Given %!"#{"board_entry[title]"}"に"test"と入力する!
  Given %!"#{"publication_type_protected"}"を選択する!
  Given %!"#{"publication_symbols_value"}"に"#{publication_symbol}"と入力する!
  Given %!"#{"editor_mode_hiki"}"を選択する!
  Given %!"#{"contents_hiki"}"に"#{"test"}"と入力する!
  Given %!"#{"作成"}"ボタンをクリックする!
  entry = BoardEntry.last
  @entries << { :id => entry.id, :uid => entry.symbol.split(":").last }
end

Given /^"(.*)"でブログを"(.*)"回書く$/ do |user, num|
  num.to_i.times do
    Given %!"#{user}"でブログを書く!
  end
end

Given /^"(.*)"で"(.*)"つめのブログにポイントを"(.*)"回つける$/ do |user,target,num|
  Given %!"#{user}"でログインする!
  entry = @entries[target.to_i - 1]
  num.to_i.times do
    visit(url_for(:controller => :board_entries, :action => :ado_pointup, :id => entry[:id]), :post)
  end
end

Given /^"(.*)"でコメントを"(.*)"回書く$/ do |user, times|
  Given %!"#{user}"でログインする!
  Given %!"1"つめのブログに"#{times}"回コメントを書く!
end

Given /^"(.*)"つめのブログに"(.*)"回コメントを書く$/ do |num,times_num|
  entry = @entries[num.to_i - 1]
  (1..times_num.to_i).each do
    visit(url_for(:controller => :board_entries, :action => :ado_create_comment,:id => entry[:id], :board_entry_comment => { :contents => "test" }), :post)
  end
end
