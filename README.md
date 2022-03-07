# kincone_selenium

## はじめに

.env_copyのファイル名を.envに変更してください。
.envに、kinconeログイン用のemailとpasswordが保存されます。
平文でガッツリ保存されるので、取り扱いにはご注意ください。

## 実行方法

ruby kincone_starter.rb

## Seleniumに関する設定の注意事項

webdriverとchromeのバージョンが違うと、うまく起動しません。
seleniumを使用するにあたっては、以下などを参考にしつつ、対応ください。

なお、ダウンロードしたchromedriverのpermissionが足りないと、以下の指示どおり対応してもうまくいきません。

[【Ruby】chromedriverのバージョンエラー（seleniumでスクレイピング） \- Qiita](https://qiita.com/koki_73/items/5f15ecb41269da6cadb0)

また、pipを使えばいい感じにやってくれるという記事も散見されるのですが、私はうまくできませんでした。。。
