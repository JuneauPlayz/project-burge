extends AudioStreamPlayer
# music
const zinnia_music = preload("res://assets/Pokémon Omega Ruby & Alpha Sapphire - Vs Zinnia (Highest Quality).mp3")
const og_music = preload("res://assets/Pokémon Red, Blue & Yellow - Trainer Battle Music (HQ).mp3")
const crimson_highlands_music = preload("res://assets/Crimson Highlands - Zodiac Battle.mp3")
const lake_music = preload("res://assets/Lake   Pokémon Diamond & Pearl Music Extended HD.mp3")

#sound fx
const CLIACK = preload("res://assets/cliack.mp3")
const FIRE_HIT = preload("res://assets/fire hit.mp3")

func play_music(song, volume):
	match song:
		"og":
			stream = og_music
		"zinnia":
			stream = zinnia_music
		"crimson":
			stream = crimson_highlands_music
		"lake":
			stream = lake_music
	stream.set_loop(true)
	volume_db = volume-5
	play()
	
func play_FX(sound, volume = 0.0):
	var soundfx : AudioStream
	match sound:
		"click":
			soundfx = CLIACK
		"fire_hit":
			soundfx = FIRE_HIT
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = soundfx
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume-5
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
	
