# 未調整のスポーンマーカーを、現在位置からY軸＋500ブロックへ移動
execute as @e[type=armor_stand,tag=spawn_marker] unless entity @s[tag=adjusted] run tp @s ~ ~500 ~
# 調整済みとしてマーク
execute as @e[type=armor_stand,tag=spawn_marker] run tag @s add adjusted