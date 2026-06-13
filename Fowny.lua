local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FownyVIP_v2"

-- Biến lưu trữ
local savedLocations = {}

-- 1. Nút Mở/Đóng Menu (Toggle)
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
toggleBtn.Text = "Fowny VIP v2"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)

-- 2. Menu chính (Main Frame)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true -- Tính năng kéo thả

-- Tiêu đề
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Fowny VIP v2 - Manager"
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.TextColor3 = Color3.new(1, 1, 1)

-- Ô nhập tên và Nút lưu
local nameInput = Instance.new("TextBox", mainFrame)
nameInput.Size = UDim2.new(0.9, 0, 0, 30)
nameInput.Position = UDim2.new(0.05, 0, 0.15, 0)
nameInput.PlaceholderText = "Tên vị trí..."

local saveBtn = Instance.new("TextButton", mainFrame)
saveBtn.Size = UDim2.new(0.9, 0, 0, 30)
saveBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
saveBtn.Text = "Lưu Vị Trí"
saveBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
saveBtn.TextColor3 = Color3.new(1, 1, 1)

-- Danh sách vị trí
local listFrame = Instance.new("ScrollingFrame", mainFrame)
listFrame.Size = UDim2.new(0.9, 0, 0.55, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
listFrame.BackgroundTransparency = 1

-- Logic Đóng/Mở
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Hàm cập nhật danh sách
local function updateList()
	for _, child in pairs(listFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	local yPos = 0
	for name, cframe in pairs(savedLocations) do
		local btn = Instance.new("TextButton", listFrame)
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.Position = UDim2.new(0, 0, 0, yPos)
		btn.Text = name
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btn.TextColor3 = Color3.new(1, 1, 1)
		
		btn.MouseButton1Click:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = cframe
			end
		end)
		yPos = yPos + 35
	end
	listFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Sự kiện lưu
saveBtn.MouseButton1Click:Connect(function()
	local name = nameInput.Text
	if name ~= "" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		savedLocations[name] = player.Character.HumanoidRootPart.CFrame
		nameInput.Text = ""
		updateList()
	end
end)
-- Đoạn mã này sẽ ép buộc tất cả ProximityPrompt trong game thành tức thì
game.Workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("ProximityPrompt") then
		descendant.HoldDuration = 0
	end
end)

-- Áp dụng cho những vật đã có sẵn từ trước
for _, v in pairs(game.Workspace:GetDescendants()) do
	if v:IsA("ProximityPrompt") then
		v.HoldDuration = 0
	end
end
