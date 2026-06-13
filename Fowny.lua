local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- 1. TẠO GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FNV4_Hub"

-- Nút FNV4 có thể kéo thả
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 40); toggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
toggleBtn.Text = "FNV4"; toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Draggable = true -- Cho phép kéo nút chính

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 280, 0, 500); mainFrame.Position = UDim2.new(0.5, -140, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); mainFrame.Visible = false; mainFrame.Active = true; mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame); title.Size = UDim2.new(1, 0, 0, 30); title.Text = "Fowny Hub Vip v4"; title.BackgroundColor3 = Color3.fromRGB(0, 0, 0); title.TextColor3 = Color3.new(1, 1, 1)

-- 2. BIẾN
local savedLocations = {}
local infJump, autoGold, autoRainbow = false, false, false

-- 3. HÀM TẠO NÚT
local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton", mainFrame); btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = pos
    btn.Text = text; btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(function() callback(btn) end); return btn
end

-- 4. TELEPORT LOGIC
local nameInput = Instance.new("TextBox", mainFrame); nameInput.Size = UDim2.new(0.9, 0, 0, 30); nameInput.Position = UDim2.new(0.05, 0, 0.1, 0); nameInput.PlaceholderText = "Tên vị trí..."
local listFrame = Instance.new("ScrollingFrame", mainFrame); listFrame.Size = UDim2.new(0.9, 0, 0.25, 0); listFrame.Position = UDim2.new(0.05, 0, 0.3, 0); listFrame.BackgroundTransparency = 1

local saveBtn = createButton("Lưu Vị Trí", UDim2.new(0.05, 0, 0.2, 0), function()
    if nameInput.Text ~= "" and player.Character:FindFirstChild("HumanoidRootPart") then
        local name = nameInput.Text; savedLocations[name] = player.Character.HumanoidRootPart.CFrame
        local container = Instance.new("Frame", listFrame); container.Size = UDim2.new(1, 0, 0, 30); container.BackgroundTransparency = 1; container.Position = UDim2.new(0,0,0, #listFrame:GetChildren()*35)
        local btn = Instance.new("TextButton", container); btn.Size = UDim2.new(0.7, 0, 1, 0); btn.Text = name
        btn.MouseButton1Click:Connect(function() if player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = savedLocations[name] end end)
        local del = Instance.new("TextButton", container); del.Size = UDim2.new(0.3, 0, 1, 0); del.Position = UDim2.new(0.7, 0, 0, 0); del.Text = "Xóa"; del.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        del.MouseButton1Click:Connect(function() container:Destroy() end)
    end
end)

-- 5. CHỨC NĂNG KHÁC (ĐÃ SỬA LỖI TP)
createButton("Nhảy vô hạn: TẮT", UDim2.new(0.05, 0, 0.6, 0), function(btn)
    infJump = not infJump; btn.Text = infJump and "Nhảy vô hạn: BẬT" or "Nhảy vô hạn: TẮT"; btn.BackgroundColor3 = infJump and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)
createButton("Auto Gold: TẮT", UDim2.new(0.05, 0, 0.7, 0), function(btn)
    autoGold = not autoGold; btn.Text = autoGold and "Auto Gold: BẬT" or "Auto Gold: TẮT"; btn.BackgroundColor3 = autoGold and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)
createButton("Auto Rainbow: TẮT", UDim2.new(0.05, 0, 0.8, 0), function(btn)
    autoRainbow = not autoRainbow; btn.Text = autoRainbow and "Auto Rainbow: BẬT" or "Auto Rainbow: TẮT"; btn.BackgroundColor3 = autoRainbow and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
end)

-- 6. LOGIC
toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
UIS.JumpRequest:Connect(function() if infJump and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid:ChangeState("Jumping") end end)

task.spawn(function()
    while task.wait(0.6) do -- Tăng thời gian chờ để ổn định
        if (autoGold or autoRainbow) and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.ActionText == "CLAIM" then
                    local pName = obj.Parent.Name
                    if (autoGold and pName:find("Gold")) or (autoRainbow and pName:find("Rainbow")) then
                        -- TP lệch ra ngoài 3 studs để không bị kẹt trong vật thể
                        player.Character.HumanoidRootPart.CFrame = obj.Parent:GetPivot().CFrame + Vector3.new(0,3,0)
                        fireproximityprompt(obj)
                    end
                end
            end
        end
    end
end)
