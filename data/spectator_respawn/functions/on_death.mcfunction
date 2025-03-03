execute as @a[scores={isDead=1..},tag=spConfigured] run gamemode spectator @s
execute as @a[scores={isDead=1..},tag=spConfigured] run scoreboard players set @s respawnTimer 100