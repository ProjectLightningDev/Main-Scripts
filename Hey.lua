-- LocalScript (place in StarterPlayerScripts)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Get remote events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local SubmitWordEvent = RemoteEvents:WaitForChild("SubmitWordEvent")
local UpdateUIEvent = RemoteEvents:WaitForChild("UpdateUIEvent")

-- Predefined dictionary with definitions
local Dictionary = {
	["apple"] = "A round fruit with red, yellow, or green skin.",
	["banana"] = "A long curved fruit with yellow skin.",
	["book"] = "A written or printed work consisting of pages.",
	["computer"] = "An electronic device for processing data.",
	["dog"] = "A domesticated carnivorous mammal.",
	["elephant"] = "A very large plant-eating mammal with a trunk.",
	["fruit"] = "The sweet and fleshy product of a tree or plant.",
	["game"] = "An activity that one engages in for amusement.",
	["house"] = "A building for human habitation.",
	["internet"] = "A global computer network.",
	["jungle"] = "An area of land overgrown with dense forest.",
	["king"] = "The male ruler of an independent state.",
	["lamp"] = "A device for giving light.",
	["music"] = "Vocal or instrumental sounds combined in harmony.",
	["nature"] = "The phenomena of the physical world collectively.",
	["ocean"] = "A very large expanse of sea.",
	["planet"] = "A celestial body moving in an orbit around a star.",
	["queen"] = "The female ruler of an independent state.",
	["rain"] = "The condensed moisture of the atmosphere falling.",
	["sun"] = "The star around which the earth orbits.",
	["tiger"] = "A large cat with a distinctive pattern of dark stripes.",
	["universe"] = "All existing matter and space considered as a whole.",
	["volcano"] = "A mountain that emits lava.",
	["water"] = "A colorless, transparent liquid.",
	["xylophone"] = "A musical instrument with wooden bars.",
	["year"] = "The time taken by the earth to make one revolution.",
	["zebra"] = "An African wild horse with black-and-white stripes."
}

-- Create UI sounds
local successSound = Instance.new("Sound")
successSound.Name = "SuccessSound"
successSound.SoundId = "rbxassetid://1839997929" -- Correct sound ID as requested
successSound.Volume = 0.5
successSound.Parent = SoundService

local errorSound = Instance.new("Sound")
errorSound.Name = "ErrorSound"
errorSound.SoundId = "rbxassetid://9085993693" -- Error sound ID as requested
errorSound.Volume = 0.5
errorSound.Parent = SoundService

local typeSound = Instance.new("Sound")
typeSound.Name = "TypeSound"
typeSound.SoundId = "rbxassetid://8058488452" -- Typing sound
typeSound.Volume = 0.2
typeSound.Parent = SoundService

local clickSound = Instance.new("Sound")
clickSound.Name = "ClickSound"
clickSound.SoundId = "rbxassetid://6042583476" -- Click sound
clickSound.Volume = 0.3
clickSound.Parent = SoundService

local confettiSound = Instance.new("Sound")
confettiSound.Name = "ConfettiSound" 
confettiSound.SoundId = "rbxassetid://9114487799"
confettiSound.Volume = 0.4
confettiSound.Parent = SoundService

-- Create main UI
local mainUI = Instance.new("ScreenGui")
mainUI.Name = "WordGameUI"
mainUI.ResetOnSpawn = false
mainUI.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 180)
mainFrame.Position = UDim2.new(0.5, -175, 0.8, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = mainUI

-- Add rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- Add shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Add gradient
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
})
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

-- Title with icon
local titleIcon = Instance.new("ImageLabel")
titleIcon.Name = "TitleIcon"
titleIcon.Size = UDim2.new(0, 24, 0, 24)
titleIcon.Position = UDim2.new(0, 20, 0, 15)
titleIcon.BackgroundTransparency = 1
titleIcon.Image = "rbxassetid://7733658504" -- Dictionary icon
titleIcon.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 0, 30)
titleLabel.Position = UDim2.new(0, 54, 0, 12)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "WORD DISCOVERER"
titleLabel.Parent = mainFrame

-- Status label with animation container
local statusContainer = Instance.new("Frame")
statusContainer.Name = "StatusContainer"
statusContainer.Size = UDim2.new(0.9, 0, 0, 24)
statusContainer.Position = UDim2.new(0.05, 0, 0, 50)
statusContainer.BackgroundTransparency = 1
statusContainer.ClipsDescendants = true
statusContainer.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -30, 1, 0)
statusLabel.Position = UDim2.new(0, 30, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = ""
statusLabel.Parent = statusContainer

-- Status icon (spinning loading circle)
local statusIcon = Instance.new("ImageLabel")
statusIcon.Name = "StatusIcon"
statusIcon.Size = UDim2.new(0, 20, 0, 20)
statusIcon.Position = UDim2.new(0, 0, 0, 2)
statusIcon.BackgroundTransparency = 1
statusIcon.Image = "rbxassetid://4965945816" -- Circular loading icon
statusIcon.ImageTransparency = 1 -- Start invisible
statusIcon.Parent = statusContainer

-- Input field with modern styling
local inputContainer = Instance.new("Frame")
inputContainer.Name = "InputContainer"
inputContainer.Size = UDim2.new(0.9, 0, 0, 42)
inputContainer.Position = UDim2.new(0.05, 0, 0, 84)
inputContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
inputContainer.BorderSizePixel = 0
inputContainer.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputContainer

local inputIcon = Instance.new("ImageLabel")
inputIcon.Name = "InputIcon"
inputIcon.Size = UDim2.new(0, 20, 0, 20)
inputIcon.Position = UDim2.new(0, 12, 0.5, -10)
inputIcon.BackgroundTransparency = 1
inputIcon.Image = "rbxassetid://7734053495" -- Search/text icon
inputIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
inputIcon.Parent = inputContainer

local textBox = Instance.new("TextBox")
textBox.Name = "WordTextBox"
textBox.Size = UDim2.new(1, -50, 1, 0)
textBox.Position = UDim2.new(0, 40, 0, 0)
textBox.BackgroundTransparency = 1
textBox.Font = Enum.Font.Gotham
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 16
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.PlaceholderText = "Type a word..."
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
textBox.Text = ""
textBox.ClearTextOnFocus = true
textBox.Parent = inputContainer

-- Submit button with modern design
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(0.9, 0, 0, 42)
submitButton.Position = UDim2.new(0.05, 0, 0, 136)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
submitButton.BorderSizePixel = 0
submitButton.Font = Enum.Font.GothamBold
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 16
submitButton.Text = "DISCOVER"
submitButton.AutoButtonColor = false
submitButton.Parent = mainFrame

-- Add rounded corners to submit button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = submitButton

-- Create notification popup with enhanced design
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(0, 340, 0, 180)
notificationFrame.Position = UDim2.new(0.5, -170, 0.4, -90)
notificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
notificationFrame.BorderSizePixel = 0
notificationFrame.Visible = false
notificationFrame.ZIndex = 10
notificationFrame.Parent = mainUI

-- Add rounded corners to notification
local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 12)
notifCorner.Parent = notificationFrame

-- Add shadow to notification
local notifShadow = Instance.new("ImageLabel")
notifShadow.Name = "Shadow"
notifShadow.Size = UDim2.new(1, 24, 1, 24)
notifShadow.Position = UDim2.new(0, -12, 0, -12)
notifShadow.BackgroundTransparency = 1
notifShadow.Image = "rbxassetid://6014261993"
notifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
notifShadow.ImageTransparency = 0.5
notifShadow.ScaleType = Enum.ScaleType.Slice
notifShadow.SliceCenter = Rect.new(49, 49, 450, 450)
notifShadow.ZIndex = 9
notifShadow.Parent = notificationFrame

-- Notification icon circle background
local iconBackground = Instance.new("Frame")
iconBackground.Name = "IconBackground"
iconBackground.Size = UDim2.new(0, 60, 0, 60)
iconBackground.Position = UDim2.new(0.5, -30, 0, 30)
iconBackground.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
iconBackground.ZIndex = 11
iconBackground.Parent = notificationFrame

local iconBackCorner = Instance.new("UICorner")
iconBackCorner.CornerRadius = UDim.new(1, 0) -- Make it circular
iconBackCorner.Parent = iconBackground

-- Notification icon
local iconImage = Instance.new("ImageLabel")
iconImage.Name = "IconImage"
iconImage.Size = UDim2.new(0, 36, 0, 36)
iconImage.Position = UDim2.new(0.5, -18, 0.5, -18)
iconImage.BackgroundTransparency = 1
iconImage.Image = "rbxassetid://7733917977" -- Success check icon
iconImage.ZIndex = 12
iconImage.Parent = iconBackground

-- Notification title
local notifTitle = Instance.new("TextLabel")
notifTitle.Name = "NotifTitle"
notifTitle.Size = UDim2.new(0.9, 0, 0, 30)
notifTitle.Position = UDim2.new(0.05, 0, 0, 100)
notifTitle.BackgroundTransparency = 1
notifTitle.Font = Enum.Font.GothamBold
notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
notifTitle.TextSize = 18
notifTitle.Text = "New Word Discovered!"
notifTitle.ZIndex = 11
notifTitle.Parent = notificationFrame

-- Notification description
local notifDesc = Instance.new("TextLabel")
notifDesc.Name = "NotifDescription"
notifDesc.Size = UDim2.new(0.9, 0, 0, 50)
notifDesc.Position = UDim2.new(0.05, 0, 0, 130)
notifDesc.BackgroundTransparency = 1
notifDesc.Font = Enum.Font.Gotham
notifDesc.TextColor3 = Color3.fromRGB(220, 220, 220)
notifDesc.TextSize = 14
notifDesc.Text = "Word definition here"
notifDesc.TextWrapped = true
notifDesc.ZIndex = 11
notifDesc.Parent = notificationFrame

-- Create confetti container
local confettiContainer = Instance.new("Frame")
confettiContainer.Name = "ConfettiContainer"
confettiContainer.Size = UDim2.new(1, 0, 1, 0)
confettiContainer.Position = UDim2.new(0, 0, 0, 0)
confettiContainer.BackgroundTransparency = 1
confettiContainer.ZIndex = 8
confettiContainer.Parent = mainUI

-- Create SVG confetti shapes for better visuals
local confettiShapes = {
	-- Star shape path
	"rbxassetid://7734751233",
	-- Circle shape
	"rbxassetid://7734750933",
	-- Square shape
	"rbxassetid://7734751348",
	-- Heart shape
	"rbxassetid://7734751091"
}

-- Function to rotate the status icon
local function animateStatusIcon()
	-- Create a continuous rotation
	local rotationTween = TweenService:Create(
		statusIcon,
		TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
		{Rotation = 360}
	)
	rotationTween:Play()
end

-- Initialize the animation
animateStatusIcon()

-- Get word definition from local dictionary
local function getWordDefinition(word)
	local lowerWord = string.lower(word)

	-- Check if word exists in our dictionary
	if Dictionary[lowerWord] then
		return {
			success = true,
			word = word,
			definition = Dictionary[lowerWord]
		}
	else
		-- Generate a random response for demo purposes
		local randomNum = math.random(1, 10)
		if randomNum <= 8 then -- 80% chance of success for testing
			return {
				success = true,
				word = word,
				definition = "A word in the English language. (Definition simulated)"
			}
		else
			return {
				success = false,
				error = "Word not found in dictionary"
			}
		end
	end
end

-- Button hover and press effects
local function buttonHoverEffect()
	-- Original state
	local originalColor = submitButton.BackgroundColor3
	local hoverColor = Color3.fromRGB(10, 132, 255)
	local pressColor = Color3.fromRGB(0, 90, 210)

	-- Create tweens
	local hoverTween = TweenService:Create(
		submitButton,
		TweenInfo.new(0.2),
		{BackgroundColor3 = hoverColor}
	)

	local leaveTween = TweenService:Create(
		submitButton,
		TweenInfo.new(0.2),
		{BackgroundColor3 = originalColor}
	)

	local pressTween = TweenService:Create(
		submitButton,
		TweenInfo.new(0.1),
		{BackgroundColor3 = pressColor, Size = UDim2.new(0.89, 0, 0, 40)}
	)

	local releaseTween = TweenService:Create(
		submitButton,
		TweenInfo.new(0.1),
		{BackgroundColor3 = hoverColor, Size = UDim2.new(0.9, 0, 0, 42)}
	)

	-- Connect events
	submitButton.MouseEnter:Connect(function()
		hoverTween:Play()
	end)

	submitButton.MouseLeave:Connect(function()
		leaveTween:Play()
	end)

	submitButton.MouseButton1Down:Connect(function()
		clickSound:Play()
		pressTween:Play()
	end)

	submitButton.MouseButton1Up:Connect(function()
		releaseTween:Play()
	end)
end

-- Enhanced confetti effect with better shapes and animations
local function createConfetti()
	-- Play confetti sound
	confettiSound:Play()

	-- Generate confetti particles
	for i = 1, 60 do
		-- Use image labels for better shapes
		local confetti = Instance.new("ImageLabel")
		confetti.Name = "Confetti"

		-- Random size
		local size = math.random(15, 30)
		confetti.Size = UDim2.new(0, size, 0, size)

		-- Random shape from our collection
		confetti.Image = confettiShapes[math.random(1, #confettiShapes)]

		-- Random color
		local colors = {
			Color3.fromRGB(255, 82, 82),   -- Red
			Color3.fromRGB(50, 168, 255),  -- Blue
			Color3.fromRGB(255, 201, 41),  -- Yellow
			Color3.fromRGB(122, 229, 130), -- Green
			Color3.fromRGB(252, 137, 226), -- Pink
			Color3.fromRGB(156, 136, 255)  -- Purple
		}
		confetti.ImageColor3 = colors[math.random(1, #colors)]

		-- Random starting position (above screen)
		confetti.Position = UDim2.new(math.random(1, 100)/100, 0, -0.1, math.random(-20, 20))
		confetti.BackgroundTransparency = 1
		confetti.ZIndex = 9
		confetti.Parent = confettiContainer

		-- Random rotation
		local rotation = math.random(0, 360)
		confetti.Rotation = rotation

		-- Create tween for falling animation with swinging effect
		local fallDuration = math.random(20, 40)/10
		local swingAmount = math.random(-100, 100)

		local fallTween = TweenService:Create(
			confetti,
			TweenInfo.new(
				fallDuration,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.In
			),
			{
				Position = UDim2.new(
					math.random(1, 100)/100 + (swingAmount/500),
					math.random(-50, 50),
					1.2,
					0
				),
				Rotation = rotation + math.random(-180, 180),
				ImageTransparency = 0.9
			}
		)

		-- Play tween and add rotation during fall
		fallTween:Play()

		-- Add continuous rotation during fall
		local spinSpeed = math.random(5, 15)/10
		local spinDirection = math.random(1, 2) == 1 and 1 or -1

		spawn(function()
			local start = tick()
			while tick() - start < fallDuration and confetti.Parent do
				confetti.Rotation = confetti.Rotation + (spinDirection * spinSpeed)
				wait()
			end
		end)

		-- Remove confetti after animation completes
		fallTween.Completed:Connect(function()
			confetti:Destroy()
		end)
	end
end

-- Show checking animation
local function showChecking()
	-- Reset and show status
	statusLabel.Text = "Checking word..."

	-- Show and animate the icon
	local fadeInTween = TweenService:Create(
		statusIcon,
		TweenInfo.new(0.3),
		{ImageTransparency = 0}
	)
	fadeInTween:Play()

	-- Pulse animation for the text
	spawn(function()
		local pulseCount = 0
		while pulseCount < 10 and statusLabel.Text == "Checking word..." do
			local pulseTween = TweenService:Create(
				statusLabel,
				TweenInfo.new(0.5),
				{TextTransparency = 0.4}
			)
			pulseTween:Play()
			wait(0.5)

			local unpulseTween = TweenService:Create(
				statusLabel,
				TweenInfo.new(0.5),
				{TextTransparency = 0}
			)
			unpulseTween:Play()
			wait(0.5)

			pulseCount = pulseCount + 1
		end
	end)
end

-- Hide checking animation
local function hideChecking()
	local fadeOutTween = TweenService:Create(
		statusIcon,
		TweenInfo.new(0.3),
		{ImageTransparency = 1}
	)
	fadeOutTween:Play()

	-- Clear status with fade
	local textFadeTween = TweenService:Create(
		statusLabel,
		TweenInfo.new(0.3),
		{TextTransparency = 1}
	)
	textFadeTween:Play()

	textFadeTween.Completed:Connect(function()
		statusLabel.Text = ""
		statusLabel.TextTransparency = 0
	end)
end

-- Enhanced notification system with animations
local function showNotification(notifType, title, description)
	-- Set notification content
	notifTitle.Text = title
	notifDesc.Text = description

	-- Set icon and colors based on notification type
	if notifType == "success" then
		iconImage.Image = "rbxassetid://7733917977" -- Check mark icon
		iconBackground.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		successSound:Play()

		-- Show confetti for successful words
		createConfetti()
	elseif notifType == "error" or notifType == "exists" then
		iconImage.Image = "rbxassetid://7734056434" -- X mark icon
		iconBackground.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
		errorSound:Play()
	end

	-- Reset properties for animation
	notificationFrame.Visible = true
	notificationFrame.Position = UDim2.new(0.5, -170, 0.3, -90)
	notificationFrame.BackgroundTransparency = 1
	notifShadow.ImageTransparency = 1

	iconBackground.Size = UDim2.new(0, 40, 0, 40)
	iconBackground.Position = UDim2.new(0.5, -20, 0, 40)
	iconBackground.BackgroundTransparency = 1

	iconImage.ImageTransparency = 1
	notifTitle.TextTransparency = 1
	notifDesc.TextTransparency = 1

	-- Entrance animations (staggered for visual appeal)
	local frameEntrance = TweenService:Create(
		notificationFrame,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{BackgroundTransparency = 0, Position = UDim2.new(0.5, -170, 0.4, -90)}
	)

	local shadowFade = TweenService:Create(
		notifShadow,
		TweenInfo.new(0.4, Enum.EasingStyle.Quad),
		{ImageTransparency = 0.5}
	)

	local iconBackgroundEntrance = TweenService:Create(
		iconBackground,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.1),
		{BackgroundTransparency = 0, Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.5, -30, 0, 30)}
	)

	local iconFade = TweenService:Create(
		iconImage,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3),
		{ImageTransparency = 0}
	)

	local titleFade = TweenService:Create(
		notifTitle,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.4),
		{TextTransparency = 0}
	)

	local descFade = TweenService:Create(
		notifDesc,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.5),
		{TextTransparency = 0}
	)

	frameEntrance:Play()
	shadowFade:Play()
	iconBackgroundEntrance:Play()
	iconFade:Play()
	titleFade:Play()
	descFade:Play()

	-- Slight bounce animation for icon
	spawn(function()
		wait(0.5)
		local bounceTween = TweenService:Create(
			iconBackground,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 64, 0, 64), Position = UDim2.new(0.5, -32, 0, 28)}
		)
		bounceTween:Play()

		wait(0.2)
		local returnTween = TweenService:Create(
			iconBackground,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.5, -30, 0, 30)}
		)
		returnTween:Play()
	end)

	-- Hide notification after delay
	delay(4, function()
		-- Exit animations
		local frameExit = TweenService:Create(
			notificationFrame,
			TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{BackgroundTransparency = 1, Position = UDim2.new(0.5, -170, 0.3, -90)}
		)

		local shadowExit = TweenService:Create(
			notifShadow,
			TweenInfo.new(0.4, Enum.EasingStyle.Quad),
			{ImageTransparency = 1}
		)

		local iconBackgroundExit = TweenService:Create(
			iconBackground,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{BackgroundTransparency = 1}
		)

		local iconExit = TweenService:Create(
			iconImage,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ImageTransparency = 1}
		)

		local titleExit = TweenService:Create(
			notifTitle,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{TextTransparency = 1}
		)

		local descExit = TweenService:Create(
			notifDesc,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{TextTransparency = 1}
		)

		frameExit:Play()
		shadowExit:Play()
		iconBackgroundExit:Play()
		iconExit:Play()
		titleExit:Play()
		
		titleExit:Play()
        descExit:Play()
        
        frameExit.Completed:Connect(function()
            notificationFrame.Visible = false
        end)
    end)
end

-- Handle text input sounds
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    if textBox.Text ~= "" and textBox.Text:sub(-1):match("%S") then
        -- Play typing sound with slight randomization for realism
        typeSound.PlaybackSpeed = math.random(95, 105) / 100
        typeSound:Play()
    end
end)

-- Handle word submission
local function submitWord()
    local word = textBox.Text:match("^%s*(.-)%s*$") -- Trim whitespace
    
    if word == "" then
        -- Empty word
        statusLabel.Text = "Please enter a word"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        
        -- Flash animation
        local flashTween = TweenService:Create(
            statusLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 0.5}
        )
        
        local unflashTween = TweenService:Create(
            statusLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 0}
        )
        
        flashTween:Play()
        flashTween.Completed:Connect(function()
            unflashTween:Play()
        end)
        
        errorSound:Play()
        return
    end
    
    -- Reset text and color
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    
    -- Show checking animation
    showChecking()
    
    -- Simulate dictionary lookup with delay for visual effect
    delay(1.5, function()
        -- Get result from dictionary
        local result = getWordDefinition(word)
        
        -- Hide checking animation
        hideChecking()
        
        -- Process result
        if result.success then
            -- Success notification
            showNotification("success", "Word Discovered!", result.definition)
            
            -- Inform server (in a real game)
            SubmitWordEvent:FireServer(word)
        else
            -- Error notification
            showNotification("error", "Word Not Found", "This word couldn't be found in our dictionary.")
        end
        
        -- Clear textbox
        textBox.Text = ""
    end)
end

-- Connect submit button
submitButton.MouseButton1Click:Connect(submitWord)

-- Connect text box Enter key
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitWord()
    end
end)

-- Apply button hover effects
buttonHoverEffect()

-- Handle server updates (for multiplayer compatibility)
UpdateUIEvent.OnClientEvent:Connect(function(updateType, data)
    if updateType == "WordDiscovered" then
        -- Show global word discovery notification if needed
        -- This can be used for global announcements
    elseif updateType == "AlreadyDiscovered" then
        -- Word was already found
        showNotification("exists", "Already Discovered", "This word has already been discovered!")
    end
end)

-- Enhanced loading animation for the status icon
local function enhanceLoadingAnimation()
    -- Stop any existing animation
    for _, tween in pairs(statusIcon:GetChildren()) do
        if tween:IsA("TweenBase") then
            tween:Cancel()
        end
    end
    
    -- Create pulse effect alongside rotation
    spawn(function()
        while statusIcon.Parent do
            local pulseTween = TweenService:Create(
                statusIcon,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Size = UDim2.new(0, 22, 0, 22)}
            )
            
            local unpulseTween = TweenService:Create(
                statusIcon,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Size = UDim2.new(0, 20, 0, 20)}
            )
            
            pulseTween:Play()
            wait(0.8)
            unpulseTween:Play()
            wait(0.8)
        end
    end)
    
    -- Create color shift effect for more visual interest
    spawn(function()
        local colors = {
            Color3.fromRGB(0, 122, 255),   -- Blue
            Color3.fromRGB(88, 101, 242),  -- Discord blue
            Color3.fromRGB(45, 156, 255)   -- Light blue
        }
        
        local index = 1
        while statusIcon.Parent do
            local colorTween = TweenService:Create(
                statusIcon,
                TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {ImageColor3 = colors[index]}
            )
            
            colorTween:Play()
            wait(1.2)
            
            index = index % #colors + 1
        end
    end)
end

-- Create a glowing effect for the status icon
local function addIconGlow()
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://1316045217" -- Radial gradient
    glow.ImageColor3 = Color3.fromRGB(0, 122, 255)
    glow.ImageTransparency = 0.7
    glow.ZIndex = statusIcon.ZIndex - 1
    glow.Parent = statusIcon
    
    -- Animate the glow
    spawn(function()
        while glow.Parent do
            local glowTween = TweenService:Create(
                glow,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {ImageTransparency = 0.5}
            )
            
            local unglowTween = TweenService:Create(
                glow,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {ImageTransparency = 0.8}
            )
            
            glowTween:Play()
            wait(1.5)
            unglowTween:Play()
            wait(1.5)
        end
    end)
end

-- Apply enhanced loading animations
enhanceLoadingAnimation()
addIconGlow()

-- Add dictionary words count display
local dictionaryStatsContainer = Instance.new("Frame")
dictionaryStatsContainer.Name = "DictionaryStats"
dictionaryStatsContainer.Size = UDim2.new(0, 100, 0, 24)
dictionaryStatsContainer.Position = UDim2.new(1, -120, 0, 15)
dictionaryStatsContainer.BackgroundTransparency = 1
dictionaryStatsContainer.Parent = mainFrame

local dictionaryIcon = Instance.new("ImageLabel")
dictionaryIcon.Name = "DictionaryIcon"
dictionaryIcon.Size = UDim2.new(0, 20, 0, 20)
dictionaryIcon.Position = UDim2.new(0, 0, 0, 2)
dictionaryIcon.BackgroundTransparency = 1
dictionaryIcon.Image = "rbxassetid://7734115798" -- Book icon
dictionaryIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
dictionaryIcon.Parent = dictionaryStatsContainer

local wordsCountLabel = Instance.new("TextLabel")
wordsCountLabel.Name = "WordsCountLabel"
wordsCountLabel.Size = UDim2.new(1, -24, 1, 0)
wordsCountLabel.Position = UDim2.new(0, 24, 0, 0)
wordsCountLabel.BackgroundTransparency = 1
wordsCountLabel.Font = Enum.Font.Gotham
wordsCountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
wordsCountLabel.TextSize = 12
wordsCountLabel.TextXAlignment = Enum.TextXAlignment.Left
wordsCountLabel.Text = Dictionary .." words"
wordsCountLabel.Parent = dictionaryStatsContainer

-- Function to highlight correct notifications with special effects
local function enhanceSuccessNotification()
    -- Create animated circles around the success icon for extra flair
    for i = 1, 3 do
        local circle = Instance.new("ImageLabel")
        circle.Name = "SuccessCircle"..i
        circle.Size = UDim2.new(1.5, 0, 1.5, 0)
        circle.Position = UDim2.new(-0.25, 0, -0.25, 0)
        circle.BackgroundTransparency = 1
        circle.Image = "rbxassetid://3570695787" -- Circle
        circle.ImageColor3 = Color3.fromRGB(46, 204, 113)
        circle.ImageTransparency = 0.8
        circle.ZIndex = 10
        circle.Parent = iconBackground
        
        -- Animate circle expanding and fading
        spawn(function()
            while circle.Parent and notificationFrame.Visible do
                circle.ImageTransparency = 0.8
                circle.Size = UDim2.new(1, 0, 1, 0)
                circle.Position = UDim2.new(0, 0, 0, 0)
                
                local expandTween = TweenService:Create(
                    circle,
                    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                    {
                        Size = UDim2.new(2, 0, 2, 0),
                        Position = UDim2.new(-0.5, 0, -0.5, 0),
                        ImageTransparency = 1
                    }
                )
                
                expandTween:Play()
                wait(i * 0.5) -- Stagger the animations
            end
        end)
    end
end

-- Original showNotification function modified to include enhanced effects
local originalShowNotification = showNotification
showNotification = function(notifType, title, description)
    originalShowNotification(notifType, title, description)
    
    -- Add extra effects for success notifications
    if notifType == "success" then
        enhanceSuccessNotification()
    end
end

-- Create an icon that appears when dictionary is being loaded
local dictionaryLoadingIndicator = Instance.new("Frame")
dictionaryLoadingIndicator.Name = "DictionaryLoadingIndicator"
dictionaryLoadingIndicator.Size = UDim2.new(0, 80, 0, 24)
dictionaryLoadingIndicator.Position = UDim2.new(1, -100, 0, -30)
dictionaryLoadingIndicator.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
dictionaryLoadingIndicator.BackgroundTransparency = 0.2
dictionaryLoadingIndicator.Visible = false
dictionaryLoadingIndicator.Parent = mainFrame

local loadingIndicatorCorner = Instance.new("UICorner")
loadingIndicatorCorner.CornerRadius = UDim.new(0, 12)
loadingIndicatorCorner.Parent = dictionaryLoadingIndicator

local loadingIcon = Instance.new("ImageLabel")
loadingIcon.Name = "LoadingIcon"
loadingIcon.Size = UDim2.new(0, 16, 0, 16)
loadingIcon.Position = UDim2.new(0, 8, 0, 4)
loadingIcon.BackgroundTransparency = 1
loadingIcon.Image = "rbxassetid://4965945816" -- Loading circle
loadingIcon.Parent = dictionaryLoadingIndicator

local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(1, -30, 1, 0)
loadingText.Position = UDim2.new(0, 30, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.Gotham
loadingText.TextColor3 = Color3.fromRGB(220, 220, 220)
loadingText.TextSize = 11
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.Text = "Loading..."
loadingText.Parent = dictionaryLoadingIndicator

-- Animate the loading icon
spawn(function()
    while true do
        loadingIcon.Rotation = loadingIcon.Rotation + 2
        wait()
    end
end)

-- Show "dictionary loading" indicator briefly at start
dictionaryLoadingIndicator.Visible = true
spawn(function()
    -- Simulate dictionary loading on game start
    wait(3)
    
    -- Fade out the loading indicator
    local fadeTween = TweenService:Create(
        dictionaryLoadingIndicator,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )
    
    local textFadeTween = TweenService:Create(
        loadingText,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 1}
    )
    
    local iconFadeTween = TweenService:Create(
        loadingIcon,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {ImageTransparency = 1}
    )
    
    fadeTween:Play()
    textFadeTween:Play()
    iconFadeTween:Play()
    
    fadeTween.Completed:Connect(function()
        dictionaryLoadingIndicator.Visible = false
    end)
end)

-- Add a dictionary health indicator
local dictionaryStatusIndicator = Instance.new("Frame")
dictionaryStatusIndicator.Name = "DictionaryStatusIndicator"
dictionaryStatusIndicator.Size = UDim2.new(0, 10, 0, 10)
dictionaryStatusIndicator.Position = UDim2.new(1, -20, 0, 20)
dictionaryStatusIndicator.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Green initially
dictionaryStatusIndicator.Parent = dictionaryStatsContainer

local statusIndicatorCorner = Instance.new("UICorner")
statusIndicatorCorner.CornerRadius = UDim.new(1, 0) -- Make it a circle
statusIndicatorCorner.Parent = dictionaryStatusIndicator

-- Pulse animation for the status indicator
spawn(function()
    local isHealthy = true
    while true do
        -- Simulate occasional dictionary issues
        if math.random(1, 100) <= 10 then
            isHealthy = false
            dictionaryStatusIndicator.BackgroundColor3 = Color3.fromRGB(231, 76, 60) -- Red for issues
            
            -- Change back after some time
            delay(math.random(3, 8), function()
                isHealthy = true
                dictionaryStatusIndicator.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Green for healthy
            end)
        end
        
        -- Create pulse effect
        local growTween = TweenService:Create(
            dictionaryStatusIndicator,
            TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -21, 0, 19)}
        )
        
        local shrinkTween = TweenService:Create(
            dictionaryStatusIndicator,
            TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -20, 0, 20)}
        )
        
        growTween:Play()
        wait(1)
        shrinkTween:Play()
        wait(1)
    end
end)

-- Custom error handling for dictionary failures
local function simulateDictionaryIssue()
    -- This is called randomly to simulate dictionary failures for testing
    local fadeInTween = TweenService:Create(
        dictionaryLoadingIndicator,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.2}
    )
    
    local textFadeInTween = TweenService:Create(
        loadingText,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    )
    
    local iconFadeInTween = TweenService:Create(
        loadingIcon,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {ImageTransparency = 0}
    )
    
    dictionaryLoadingIndicator.Visible = true
    loadingText.Text = "Dictionary issue..."
    
    fadeInTween:Play()
    textFadeInTween:Play()
    iconFadeInTween:Play()
    
    -- After a brief delay, show reconnecting and then success
    delay(2, function()
        loadingText.Text = "Reconnecting..."
        wait(1.5)
        
        -- Fade out
        local fadeOutTween = TweenService:Create(
            dictionaryLoadingIndicator,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        local textFadeOutTween = TweenService:Create(
            loadingText,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 1}
        )
        
        local iconFadeOutTween = TweenService:Create(
            loadingIcon,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {ImageTransparency = 1}
        )
        
        fadeOutTween:Play()
        textFadeOutTween:Play()
        iconFadeOutTween:Play()
        
        fadeOutTween.Completed:Connect(function()
            dictionaryLoadingIndicator.Visible = false
        end)
    end)
end

-- Randomly simulate dictionary issues
spawn(function()
    while true do
        wait(math.random(30, 60))
        if math.random(1, 100) <= 20 then -- 20% chance of dictionary issue
            simulateDictionaryIssue()
        end
    end
end)

-- Create a tip system
local tipTexts = {
    "Try discovering words related to nature!",
    "Some rare words might have special effects!",
    "Longer words may give better rewards.",
    "Words from multiple categories unlock achievements.",
    "Challenge: find 5 animal words in a row!",
    "The dictionary contains over 25 words to discover!",
    "Some words may be temporarily unavailable."
}

local function showRandomTip()
    statusLabel.Text = "Tip: " .. tipTexts[math.random(1, #tipTexts)]
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    
    -- Fade in and out animation
    local fadeInTween = TweenService:Create(
        statusLabel,
        TweenInfo.new(0.5),
        {TextTransparency = 0}
    )
    
    fadeInTween:Play()
    
    delay(5, function()
        local fadeOutTween = TweenService:Create(
            statusLabel,
            TweenInfo.new(0.5),
            {TextTransparency = 1}
        )
        
        fadeOutTween:Play()
        
        fadeOutTween.Completed:Connect(function()
            statusLabel.Text = ""
            statusLabel.TextTransparency = 0
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        end)
    end)
end

-- Show tips periodically
spawn(function()
    wait(10) -- Initial delay
    while true do
        if statusLabel.Text == "" then
            showRandomTip()
        end
        wait(30) -- Show a tip every 30 seconds
    end
end)

-- Initialize UI with a welcome message
delay(1, function()
    statusLabel.Text = "Welcome to Word Discoverer!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    delay(3, function()
        local fadeOutTween = TweenService:Create(
            statusLabel,
            TweenInfo.new(1),
            {TextTransparency = 1}
        )
        
        fadeOutTween:Play()
        
        fadeOutTween.Completed:Connect(function()
            statusLabel.Text = ""
            statusLabel.TextTransparency = 0
        end)
    end)
end)
