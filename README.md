# rye-template-simple
package management for Python

## Overview
- ryeを用いて，pythonとpython packageの管理を行います．
- シェルスクリプト１つで初期設定が完了します．
- Linter・FormatterにRuffを採用しています．

## Requirement
- ryeがinstallされていること
  - [Rye公式](https://rye.astral.sh/)
- VSCodeのRyeの拡張機能がinstallされていること
  - [Ruff / charliermarsh.ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)

以下のinstall方法は更新されている可能性があるので，公式サイトをご確認ください
### Linux
```
curl -sSf https://rye.astral.sh/get | bash
```


### macOS
```
curl -sSf https://rye.astral.sh/get | bash
```
または
```
brew install rye
```

### 共通
install後，PATHを通す
```
echo 'source "$HOME/.rye/env"' >> ~/.profile
```
または
```
echo 'source "$HOME/.rye/env"' >> ~/.bashrc
```

以下などで設定を反映させる．使用しているshellや環境に応じて，適切なファイルに記述してください．
```
source ~/.bashrc
```


## Usage
> [!CAUTION]
> 空のディレクトリで行うことを推奨します．
> シェルスクリプト内にsrc/ディレクトリをすべて消す操作が含まれているので注意してください

背景：ryeの初期設定で，src/プロジェクト名というディレクトリ構造が作成されるが，src/のみの構成に変更するためにsrc/以下を一度削除して再作成する処理が記述されています．

1. これから使用するプロジェクトに移動する（空のディレクトリ）
2. setup.shファイルを作成し，本リポジトリ内のsetup.shの内容を貼り付ける
```
touch setup.sh
```
3. パーミッションを与える
```
chmod +x setup.sh
```
4. 実行する
```
./setup.sh
```

## Command
ryeでよく使うコマンドについて解説

### init
ryeプロジェクトの作成
```
rye init プロジェクト名
```

### pin
pythonバージョンの指定
```
rye pin 3.10
```

### sync
ライブラリの同期．pythonバージョンの変更や，**ライブラリの追加(add)を行った後は必ず行う．**
```
rye sync
```

### add
パッケージの追加(pip install)

pip installの代わりに`rye add`でパッケージを追加していくのが基本的な使い方です．`rye sync`も忘れずに
```
rye add パッケージ名
```
開発用パッケージの追加（formatやtest用など）
```
rye add --dev パッケージ名
```
バージョン指定
```
rye add "パッケージ名==1.1.1"
```

### remove
パッケージの削除(pip uninstall)
```
rye remove パッケージ名
```

### run
仮想環境で実行
```
rye run python 〇〇.py
```
```
rye run コマンド
```

pyproject.tomlの以下の欄にコマンドを設定することが出来ます．

本テンプレートではフォーマットのコマンドを作成しています．
```
[tool.rye.scripts]
```

### activate
仮想環境に入る（OSによって異なる可能性があります．venvで検索してください）
```
. .venv/bin/activate
```

### deactivate
仮想環境から抜け出す
```
deactivate
```

## Features
setup.pyで行っていることの解説
- `rye init .`でryeのプロジェクトを作成
- `rye pin 3.10`でpythonのバージョン指定
- ディレクトリ構成が`src/プロジェクト名`になり，構造が深くなるのが嫌なので`src/`になるように変更
  - この際最初に存在する`src/`以下のファイルを全削除
  - buildのターゲットディレクトリをそれにあわせて変更
  - 実際にbuildは行ったこと無い（行うこともおそらく無い）のでbuild時の挙動は未確認
- `rye run 〇〇`ではなく，Makefileを用いて`make 〇〇`で実行できるように**Makefile**を作成
- `make init`を実行し，必要最低限のパッケージを追加
- `.vscode/setting.json`を作成し，保存時にformatをかける設定を追加
  - VSCodeのRuffの拡張機能を追加しておく
  - [Ruff / charliermarsh.ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)
- `.gitignore`にpythonでよく見かけるcommit不要なファイルを追記
- `pyproject.toml`にformat用の設定，コマンドを追加

Makefileは完全好みのため不要であれば削除してください．

## Reference
- [Rye](https://rye.astral.sh/)
- [pythonパッケージ管理ツールryeを使う - 肉球でキーボード](https://nsakki55.hatenablog.com/entry/2023/05/29/013658)
- [【Pythonのパッケージ管理に悩む方へ】パッケージ管理ツールRyeを使ってみた | DevelopersIO](https://dev.classmethod.jp/articles/get-start-rye-python/)
- [【Python】Ryeで始めるPythonプロジェクト #初心者 - Qiita](https://qiita.com/kissy24/items/37c881498dcb8a01f3bd)
- [Pythonライブラリ管理ツール決定版！Ryeを導入してみた](https://zenn.dev/ncdc/articles/1979def94dedea)
- [Pythonのパッケージ管理ツールのコマンド比較表](https://zenn.dev/tanny/articles/041f46c06f76f5)

## Contact
疑問点や改善などあれば，メンションをつけて[Issue](https://github.com/ryhara/rye-template-simple/issues)にコメントしてください．


## License
本テンプレートの使用に伴い発生する可能性のある，ファイルやデバイスの破損，その他いかなる損害に対しても責任を負いかねます．
ご自身の責任において行ってください．

[MIT](https://github.com/ryhara/rye-template-simple/blob/main/LICENSE)
