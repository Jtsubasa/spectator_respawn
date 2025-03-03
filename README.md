# Spectator Respawn Data Pack

このデータパックは、プレイヤーが死亡した際に一時的にスペクテイターモードとなり、一定時間後に指定のリスポーン地点にテレポートする機能を提供します。  
さらに、ワールド内からコマンドを利用して、任意のチームの追加やリスポーン地点の変更が可能です。  
※ 初期状態では特定のチーム設定は行われていません。必要なチームは管理者側で後から追加してください。

---

## ディレクトリ構造
spectator_respawn/                 ← データパックのルートフォルダ
├─ pack.mcmeta
├─ README.md
└─ data/
   └─ spectator_respawn/
      ├─ functions/
      │  ├─ load.mcfunction
      │  ├─ tick.mcfunction
      │  ├─ on_death.mcfunction
      │  ├─ timer.mcfunction
      │  └─ dynamic_respawn.mcfunction
      └─ tags/
         └─ functions/
            └─ tick.json

---


---

## インストール方法

1. このフォルダ（spectator_respawn）をワールドの `datapacks/` フォルダに配置してください。  
2. ゲーム内で `/reload` コマンドを実行してデータパックを読み込みます。

---

## 基本動作

- **死亡時の処理:**  
  spConfigured タグが付与されたプレイヤーが死亡すると、内部の deathCount（objective: `isDead`）により検知され、  
  即座にスペクテイターモードに切替わり、`respawnTimer` が 100（約5秒）にセットされます。

- **タイマー処理:**  
  毎tick、`respawnTimer` が 1 ずつ減算されます。

- **リスポーン処理:**  
  タイマーが 0 になったプレイヤーに対して、データパック内の dynamic_respawn.mcfunction が動作します。  
  この関数は、プレイヤーに割り当てられた `teamID`（例：1～10）に応じ、対応するスポーンマーカー（armor_stand に  
  付与されたタグ `spawn_team_<ID>`）の位置へテレポートさせ、ゲームモードをサバイバルに戻します。  
  ※ 現在のサンプルでは teamID=1～4 の例を記述していますが、必要に応じて teamID=5～10 も追加可能です。

---

## 管理者による動的チーム登録方法

データパック内に個別のチーム処理用ファイルは用意していません。  
代わりに、管理者は以下の手順で任意のチームを追加してください。（ここではチームID を例として利用します。）

1. **チーム作成および対象プレイヤーの登録**  
   - まず、任意の方法でプレイヤーに数値の teamID を割り当てます。  
     例：チーム「sample」を teamID 1 とする場合、対象プレイヤーに対して  
     ```
     /scoreboard players set <player> teamID 1
     ```  
   - また、データパックの影響対象とするため、対象プレイヤーにタグ `spConfigured` を付与してください。  
     例：  
     ```
     /tag <player> add spConfigured
     ```

2. **スポーンマーカーの召喚**  
   - チームID 1 のリスポーン地点として利用するスポーンマーカーを、管理者がコマンドから召喚します。  
     例：  
     ```
     /summon armor_stand ~ ~ ~ {Tags:["spawn_marker","spawn_team_1"],Invisible:1b,Marker:1b,NoGravity:1b}
     ```  
     ※ この armor_stand の位置が、チームID 1 のリスポーン地点となります。  
     ※ 他のチーム（teamID 2～10）についても、同様に  
     `spawn_team_2` などのタグを付与して召喚してください。

3. **動作確認**  
   - 対象プレイヤーが死亡すると、5秒後に対応するスポーンマーカーの位置へテレポートし、サバイバルモードに戻ります。

---

## 注意事項

- 本データパックは、対象プレイヤーとして `spConfigured` タグが付与されているもののみ処理します。  
  管理者側で対象プレイヤーの登録を忘れないようにしてください。
- チームの管理は scoreboard の `teamID`（dummy 型）を利用しています。  
  各プレイヤーに正しい数値が設定されていることを確認してください。
- dynamic_respawn.mcfunction 内は、現状 teamID=1～4 の例を示しています。  
  必要に応じて、チーム数の上限（例：10 まで）を想定して内容を拡張してください。

---

## 更新履歴

- **初版:** 動的にチームを登録できる仕組みを実装（チームID による管理・スポーンマーカーを利用）  
