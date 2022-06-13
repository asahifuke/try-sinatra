# Name
 Sinatraを使ったWebアプリケーション

 # Installation
 - まず、git@github.com:asahifuke/try_sinatra.gitをdevelopmentブランチでクローンします。
```bash
git clone -b development git@github.com:asahifuke/try-sinatra.git
```

- cloneしたディレクトリーに移ります。
```bash
cd try-sinatra
```

- rbenvの3.1.2をインストールしてください
```bash
rbenv install 3.1.2
```

- rbenvのバージョンをlocalで3.1.2にしてください。
```bash
rbenv local 3.1.2
```

- gemをインストールしてください。
```bash
bundle install 
```
- ターミナルで以下を実行してください。
```bash
$ bundle exec ruby app.rb
```

- ブラウザを立ち上げて、localhost:4567にアクセスしてください。
```http
http://localhost:4567
```
