local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- 1. -- 1. TẠO GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FHV4_Hub"
-- THÊM DÒNG NÀY ĐỂ GIỮ GUI KHI RESET
screenGui.ResetOnSpawn = false 

local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 40); toggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
-- ... (phần còn lại của code giữ nguyên)

toggleBtn.Text = "FHV4"; toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Draggable = true 

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 280, 0, 720); mainFrame.Position = UDim2.new(0.5, -140, 0.5, -360)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); mainFrame.Visible = false; mainFrame.Active = true; mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame); title.Size = UDim2.new(1, 0, 0, 30); title.Text = "Fowny Hub Vip v4"; title.BackgroundColor3 = Color3.fromRGB(0, 0, 0); title.TextColor3 = Color3.new(1, 1, 1)

-- 2. BIẾN
local savedLocations = {}
local infJump, autoGold, autoRainbow, hitboxEnabled, fogRemoved = false, false, false, false, false
local hitboxSize = 6

-- 3. HÀM TẠO NÚT
local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton", mainFrame); btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = pos
    btn.Text = text; btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(function() callback(btn) end); return btn
end

-- 4. TELEPORT & SPEED
local nameInput = Instance.new("TextBox", mainFrame); nameInput.Size = UDim2.new(0.9, 0, 0, 30); nameInput.Position = UDim2.new(0.05, 0, 0.05, 0); nameInput.PlaceholderText = "Tên vị trí..."
local speedInput = Instance.new("TextBox", mainFrame); speedInput.Size = UDim2.new(0.9, 0, 0, 30); speedInput.Position = UDim2.new(0.05, 0, 0.35, 0); speedInput.PlaceholderText = "Tốc độ (30-40 recommended)"

local listFrame = Instance.new("ScrollingFrame", mainFrame); listFrame.Size = UDim2.new(0.9, 0, 0.20, 0); listFrame.Position = UDim2.new(0.05, 0, 0.11, 0); listFrame.BackgroundTransparency = 1

createButton("Lưu Vị Trí", UDim2.new(0.05, 0, 0.28, 0), function()
    if nameInput.Text ~= "" and player.Character:FindFirstChild("HumanoidRootPart") then
        local name = nameInput.Text; savedLocations[name] = player.Character.HumanoidRootPart.CFrame
        local container = Instance.new("Frame", listFrame); container.Size = UDim2.new(1, 0, 0, 30); container.BackgroundTransparency = 1; container.Position = UDim2.new(0,0,0, #listFrame:GetChildren()*35)
        local btn = Instance.new("TextButton", container); btn.Size = UDim2.new(0.7, 0, 1, 0); btn.Text = name
        btn.MouseButton1Click:Connect(function() if player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = savedLocations[name] end end)
        local del = Instance.new("TextButton", container); del.Size = UDim2.new(0.3, 0, 1, 0); del.Position = UDim2.new(0.7, 0, 0, 0); del.Text = "Xóa"; del.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        del.MouseButton1Click:Connect(function() container:Destroy() end)
    end
end)

createButton("Áp dụng Tốc độ", UDim2.new(0.05, 0, 0.42, 0), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = tonumber(speedInput.Text) or 16
    end
end)

-- 5. CHỨC NĂNG HITBOX & FOG
local hitboxInput = Instance.new("TextBox", mainFrame); hitboxInput.Size = UDim2.new(0.9, 0, 0, 30); hitboxInput.Position = UDim2.new(0.05, 0, 0.51, 0); hitboxInput.PlaceholderText = "Hitbox Size (VD: 6)"
hitboxInput.Text = "6"

createButton("Hitbox: TẮT", UDim2.new(0.05, 0, 0.58, 0), function(btn)
    hitboxEnabled = not hitboxEnabled; btn.Text = hitboxEnabled and "Hitbox: BẬT" or "Hitbox: TẮT"; btn.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)

createButton("Xóa Fog: TẮT", UDim2.new(0.05, 0, 0.65, 0), function(btn)
    fogRemoved = not fogRemoved; btn.Text = fogRemoved and "Xóa Fog: BẬT" or "Xóa Fog: TẮT"; btn.BackgroundColor3 = fogRemoved and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)

-- 6. CHỨC NĂNG KHÁC
createButton("Nhảy vô hạn: TẮT", UDim2.new(0.05, 0, 0.75, 0), function(btn)
    infJump = not infJump; btn.Text = infJump and "Nhảy vô hạn: BẬT" or "Nhảy vô hạn: TẮT"; btn.BackgroundColor3 = infJump and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)
createButton("Auto Gold: TẮT", UDim2.new(0.05, 0, 0.82, 0), function(btn)
    autoGold = not autoGold; btn.Text = autoGold and "Auto Gold: BẬT" or "Auto Gold: TẮT"; btn.BackgroundColor3 = autoGold and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)
createButton("Auto Rainbow: TẮT", UDim2.new(0.05, 0, 0.89, 0), function(btn)
    autoRainbow = not autoRainbow; btn.Text = autoRainbow and "Auto Rainbow: BẬT" or "Auto Rainbow: TẮT"; btn.BackgroundColor3 = autoRainbow and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)

-- 7. LOGIC CHẠY
toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
UIS.JumpRequest:Connect(function() if infJump and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid:ChangeState("Jumping") end end)

RS.RenderStepped:Connect(function()
    if hitboxEnabled then
        hitboxSize = tonumber(hitboxInput.Text) or 6
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Transparency = 0.5
                hrp.CanCollide = false
            end
        end
    end
    if fogRemoved then
        Lighting.FogEnd = 1000000
        Lighting.FogStart = 1000000
    end
end)

task.spawn(function()
    while task.wait(0.6) do
        if (autoGold or autoRainbow) and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.ActionText == "CLAIM" then
                    local pName = obj.Parent.Name
                    if (autoGold and pName:find("Gold")) or (autoRainbow and pName:find("Rainbow")) then
                        player.Character.HumanoidRootPart.CFrame = obj.Parent:GetPivot().CFrame + Vector3.new(0,3,0)
                        fireproximityprompt(obj)
                    end
                end
            end
        end
    end
end)
-- Chức năng tương tác tức thì luôn luôn hoạt động
local function makeInstant()
    -- Cập nhật tất cả các vật phẩm đang có sẵn trong Workspace
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
        end
    end
end

-- Tự động chạy ngay khi script bắt đầu
makeInstant()

-- Theo dõi nếu có vật phẩm mới xuất hiện thì chỉnh luôn
game.Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
    end
end)
-- 1. TẠO NÚT RESIZE (Góc dưới bên phải)
local resizeBtn = Instance.new("TextButton", mainFrame)
resizeBtn.Size = UDim2.new(0, 20, 0, 20)
resizeBtn.Position = UDim2.new(1, -20, 1, -20)
resizeBtn.Text = "◢"
resizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resizeBtn.TextColor3 = Color3.new(1, 1, 1)
resizeBtn.ZIndex = 10

-- 2. LOGIC KÉO THẢ ĐỂ ĐỔI KÍCH THƯỚC
local dragging, dragInput, dragStart, startSize
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Size = UDim2.new(0, math.clamp(startSize.X.Offset + delta.X, 100, 500), 0, math.clamp(startSize.Y.Offset + delta.Y, 100, 600))
end

resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startSize = mainFrame.Size
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
