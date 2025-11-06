extends CharacterBody2D

# --- Variabel Gerakan ---
# @export membuat variabel ini bisa diubah di Inspector.
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

# --- Gravitasi ---
# Mengambil nilai gravitasi dari Project Settings (Physics > 2d)
# Ini cara yang lebih baik daripada menuliskannya langsung.
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- Referensi Node ---
# (Saya menggunakan nama variabel Anda 'player_u1')
@onready var player_u1: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# 1. Terapkan Gravitasi
	# Hanya tambahkan gravitasi jika karakter tidak sedang di lantai.
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Handle Lompat (Jump)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Handle Gerakan Kiri/Kanan
	var direction: float = Input.get_axis("ui_left", "ui_right")

	# 4. Handle Arah Sprite (Flipping)
	# Ini akan membalik sprite jika bergerak ke kiri (direction < 0)
	if direction > 0:
		player_u1.flip_h = false  # Menghadap Kanan
	elif direction < 0:
		player_u1.flip_h = true   # Menghadap Kiri

	# 5. Terapkan Kecepatan Horizontal
	if direction != 0:
		# Jika ada input, bergerak sesuai speed
		velocity.x = direction * speed
	else:
		# Jika tidak ada input, berhenti perlahan (decelerasi)
		velocity.x = move_toward(velocity.x, 0, speed)

	# 6. Panggil Fungsi Gerakan Utama
	move_and_slide()

	# 7. Update Animasi (SETELAH semua fisika)
	update_animation()


# Fungsi terpisah untuk mengurus animasi agar lebih rapi
func update_animation():
	# Cek jika sedang di udara
	if not is_on_floor():
		player_u1.play("jump") # Asumsi Anda punya animasi bernama "jump"
	else:
		# Cek jika sedang bergerak horizontal
		if velocity.x != 0:
			player_u1.play("run")
		else:
			player_u1.play("idle")
