extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var walkingSpeed = 5.0
var crouchingSpeed = 3.5
var crawlSpeed = 2.5

var trueSpeed = walkingSpeed

var isCrouching = false
var isCrawling = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	if Input.is_action_just_pressed("crouch"):
		if isCrouching == false:
			movementStateChange("crouch")
			trueSpeed = crouchingSpeed
			
		elif isCrouching == true:
			movementStateChange("uncrouch")
			trueSpeed = walkingSpeed
			
	elif Input.is_action_just_pressed("crawl"):
		if isCrawling == false:
			movementStateChange("crawl")
			trueSpeed = crawlSpeed
		elif isCrawling == true:
			movementStateChange("uncrawl")
			trueSpeed = walkingSpeed


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * trueSpeed
		velocity.z = direction.z * trueSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, trueSpeed)
		velocity.z = move_toward(velocity.z, 0, trueSpeed)

	move_and_slide()

func movementStateChange(changeType):
	match changeType:
		"crouch":
			if isCrawling:
				$AnimationPlayer.play_backwards("CrouchToCrawl")
			else:
				$AnimationPlayer.play("StandingToCrouch")
			isCrouching = true
			changeCollisionShapeTo("crouching")
			isCrawling = false
			
		"uncrouch":
			$AnimationPlayer.play_backwards("StandingToCrouch")
			isCrouching = false
			isCrawling = false
			changeCollisionShapeTo("standing")

		"crawl":
			if isCrouching:
				$AnimationPlayer.play("CrouchToCrawl")
			else:
				$AnimationPlayer.play("StandingToCrawl")
			isCrouching = false
			isCrawling = true
			changeCollisionShapeTo("crawling")

		"uncrawl":
			$AnimationPlayer.play_backwards("StandingToCrawl")
			isCrawling = false
			isCrouching = false
			changeCollisionShapeTo("standing")

#Change collision shapes for standing, crouch, crawl
func changeCollisionShapeTo(shape):
	match shape:
		"crouching":
			#Disabled == false is enabled!
			$CrouchingCollisionShape.disabled = false
			$CrawlingCollisionShape.disabled = true
			$StandingCollisionShape.disabled = true
		"standing":
			#Disabled == false is enabled!
			$StandingCollisionShape.disabled = false
			$CrawlingCollisionShape.disabled = true
			$CrouchingCollisionShape.disabled = true
		"crawling":
			#Disabled == false is enabled!
			$CrawlingCollisionShape.disabled = false
			$StandingCollisionShape.disabled = true
			$CrouchingCollisionShape.disabled = true
