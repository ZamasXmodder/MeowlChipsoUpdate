-- Meowl Update: Loader -> CMD1 (ASCII user) -> Login (con lluvia) -> Brainrot List (multi-select)
-- v6.2 "Crimson+Smart+Rainbow+Ghost" (bugfix: UDim.new; guardias pcall en transición)
-- Icons: loader=107979318717959, login=104395147515167
-- Key: 002288
-- Get Key URL: https://zamasxmodder.github.io/Meowl-Update-Brainrot-MirandaHub/

local G = (getgenv and getgenv()) or _G
if G.__MEOWL_SMART_BOOT_RUNNING then return end
G.__MEOWL_SMART_BOOT_RUNNING = true

local Players           = game:GetService("Players")
local TeleportService   = game:GetService("TeleportService")
local TweenService      = game:GetService("TweenService")
local LP                = Players.LocalPlayer

-- ===== THEME (rojos + arcoíris)
local THEME = {
  bg         = Color3.fromRGB(14,8,10),
  panel      = Color3.fromRGB(28,14,16),
  panelLite  = Color3.fromRGB(32,16,18),
  text       = Color3.fromRGB(255,232,234),
  textDim    = Color3.fromRGB(255,170,178),
  accent     = Color3.fromRGB(255,120,140),
  glass_a    = 0.14,
  rainColor  = Color3.fromRGB(255,140,150),
}
local GET_KEY_URL = "https://zamasxmodder.github.io/EsokBooAutoBraintosWeb/"
local VALID_KEY   = "002288"

-- ===== Safe parent
local function getGuiParent()
  local ok, ui = pcall(function() if gethui then return gethui() end return game:GetService("CoreGui") end)
  if ok and ui then return ui end
  local pg = LP and LP:FindFirstChildOfClass("PlayerGui")
  return pg or game:GetService("CoreGui")
end

local UI = Instance.new("ScreenGui")
UI.Name = "MeowlSmartBoot_v62"
UI.IgnoreGuiInset = true
UI.ZIndexBehavior = Enum.ZIndexBehavior.Global
UI.DisplayOrder = 2000
UI.ResetOnSpawn = false
pcall(function() if syn and syn.protect_gui then syn.protect_gui(UI) end end)
UI.Parent = getGuiParent()

-- ===== Responsive UIScale
local rootScale = Instance.new("UIScale", UI)
local function recomputeScale()
  local cam = workspace.CurrentCamera
  if not cam then return end
  local v = cam.ViewportSize
  local s = math.clamp(math.min(v.X, v.Y) / 900, 0.75, 1.25)
  rootScale.Scale = s
end
recomputeScale()
task.defer(function()
  local cam = workspace.CurrentCamera
  if not cam then return end
  cam:GetPropertyChangedSignal("ViewportSize"):Connect(recomputeScale)
end)

-- ===== Rainbow Stroke
local function rainbowSequence(steps)
  steps = steps or 12
  local ks = {}
  for i=0,steps do
    local t = i/steps
    local c = Color3.fromHSV(t, 0.95, 1)
    ks[#ks+1] = ColorSequenceKeypoint.new(t, c)
  end
  return ColorSequence.new(ks)
end

local function applyRainbowStroke(instance, thickness)
  local stroke = Instance.new("UIStroke")
  stroke.Thickness = thickness or 2
  stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  stroke.Parent = instance
  local grad = Instance.new("UIGradient")
  grad.Color = rainbowSequence(16)
  grad.Rotation = 0
  grad.Offset = Vector2.new(0,0)
  grad.Parent = stroke
  task.spawn(function()
    local r, dir, off = 0, 1, 0
    while UI.Parent and instance.Parent do
      r = (r + 1.5) % 360
      off = off + 0.005 * dir
      if off >= 0.15 then dir = -1 end
      if off <= -0.15 then dir = 1 end
      grad.Rotation = r
      grad.Offset = Vector2.new(off, 0)
      task.wait(1/60)
    end
  end)
  return stroke
end

-- ===== Icono circular
local function CircularIconBright(imageId, z)
  local holder = Instance.new("Frame")
  holder.BackgroundColor3 = Color3.fromRGB(60,20,24)
  holder.BackgroundTransparency = 0.08
  holder.BorderSizePixel = 0
  holder.ClipsDescendants = true
  holder.ZIndex = z or 10
  Instance.new("UIAspectRatioConstraint", holder).AspectRatio = 1
  Instance.new("UICorner", holder).CornerRadius = UDim.new(1,0)
  applyRainbowStroke(holder, 1.4)

  local halo = Instance.new("ImageLabel")
  halo.BackgroundTransparency = 1
  halo.Image = "rbxassetid://457665422"
  halo.ImageTransparency = 0.35
  halo.ScaleType = Enum.ScaleType.Fit
  halo.Size = UDim2.fromScale(1.6,1.6)
  halo.Position = UDim2.fromScale(0.5,0.5)
  halo.AnchorPoint = Vector2.new(0.5,0.5)
  halo.ImageColor3 = THEME.accent
  halo.ZIndex = holder.ZIndex + 0
  halo.Parent = holder

  local img = Instance.new("ImageLabel")
  img.BackgroundTransparency = 1
  img.Size = UDim2.fromScale(1,1)
  img.Position = UDim2.fromScale(0.5,0.5)
  img.AnchorPoint = Vector2.new(0.5,0.5)
  img.Image = imageId
  img.ImageColor3 = Color3.new(1,1,1)
  img.ScaleType = Enum.ScaleType.Fit
  img.ZIndex = holder.ZIndex + 2
  img.Parent = holder

  return holder, img
end

-- ===== Toast
local function bigToast(line1, line2)
  local card = Instance.new("Frame")
  card.Size = UDim2.fromScale(0.86, 0.12)
  card.AnchorPoint = Vector2.new(0.5,0)
  card.Position = UDim2.fromScale(0.5, 0.08)
  card.BackgroundColor3 = Color3.fromRGB(38,10,12)
  card.BackgroundTransparency = 0.04
  card.BorderSizePixel = 0
  card.ZIndex = 5000
  card.Parent = UI
  applyRainbowStroke(card, 1.8)
  Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)

  local t1 = Instance.new("TextLabel")
  t1.BackgroundTransparency = 1
  t1.Font = Enum.Font.GothamSemibold
  t1.TextSize = 22
  t1.TextColor3 = THEME.text
  t1.TextXAlignment = Enum.TextXAlignment.Left
  t1.Size = UDim2.new(1,-20,0.6,0)
  t1.Position = UDim2.fromOffset(10,6)
  t1.Text = line1
  t1.ZIndex = card.ZIndex + 1
  t1.Parent = card

  local t2 = Instance.new("TextLabel")
  t2.BackgroundTransparency = 1
  t2.Font = Enum.Font.Gotham
  t2.TextSize = 16
  t2.TextColor3 = THEME.textDim
  t2.TextXAlignment = Enum.TextXAlignment.Left
  t2.Size = UDim2.new(1,-20,0.4,-6)
  t2.Position = UDim2.fromOffset(10, 34)
  t2.Text = line2 or ""
  t2.ZIndex = card.ZIndex + 1
  t2.Parent = card

  card.BackgroundTransparency = 1; t1.TextTransparency, t2.TextTransparency = 1,1
  TweenService:Create(card, TweenInfo.new(0.15), {BackgroundTransparency = 0.04}):Play()
  TweenService:Create(t1, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
  TweenService:Create(t2, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
  task.delay(2.2, function()
    TweenService:Create(card, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    TweenService:Create(t1, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
    TweenService:Create(t2, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
    task.wait(0.18); if card then card:Destroy() end
  end)
end

-- ===== Lluvia 8-bit
local function startCodeRain()
  local backdrop = Instance.new("Frame")
  backdrop.Name = "CodeRain"
  backdrop.Size = UDim2.fromScale(1,1)
  backdrop.BackgroundColor3 = THEME.bg
  backdrop.BackgroundTransparency = 0.9
  backdrop.BorderSizePixel = 0
  backdrop.ZIndex = 1
  backdrop.Parent = UI

  local function newDrop(x, yStart)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.ArialBold
    lbl.TextColor3 = THEME.rainColor
    lbl.TextSize = 16
    lbl.ZIndex = 2
    lbl.Size = UDim2.fromOffset(20,20)
    lbl.Text = ({"0","1","A","B","C","D","E","F","#","*","+","%","?"})[math.random(1,13)]
    lbl.Position = UDim2.fromOffset(x, yStart or -20)
    lbl.Parent = backdrop

    local cam = workspace.CurrentCamera
    local H = (cam and cam.ViewportSize.Y or 720) + math.random(240,360)
    local T = math.random(18,28)/10
    TweenService:Create(lbl, TweenInfo.new(T, Enum.EasingStyle.Linear), {Position = UDim2.fromOffset(x, H)}):Play()
    task.delay(T, function() if lbl then lbl:Destroy() end end)
  end

  local function tickRain()
    local cam = workspace.CurrentCamera
    local vw = (cam and cam.ViewportSize.X or 1280)
    local columns = math.max(14, math.floor(vw / 36))
    for i=1,columns do
      newDrop(i*36 + math.random(-8,8), -math.random(0, 250))
    end
  end

  local cam = workspace.CurrentCamera
  if cam then
    cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
      backdrop.Size = UDim2.fromScale(1,1)
    end)
  end

  task.spawn(function()
    while backdrop.Parent do
      tickRain()
      task.wait(0.28)
    end
  end)

  return backdrop
end

-- ===== Loader
local function showLoader(onDone)
  local root = Instance.new("Frame")
  root.Size = UDim2.fromScale(0.46,0.32)
  root.Position = UDim2.fromScale(0.5,0.5)
  root.AnchorPoint = Vector2.new(0.5,0.5)
  root.BackgroundColor3 = THEME.panelLite
  root.BackgroundTransparency = 1
  root.BorderSizePixel = 0
  root.ZIndex = 5
  root.Parent = UI
  Instance.new("UICorner",root).CornerRadius = UDim.new(0,16)
  applyRainbowStroke(root,2)

  local iconHolder = CircularIconBright("rbxassetid://107979318717959", 7)
  iconHolder.Size = UDim2.fromScale(0.24,0.66)
  iconHolder.Position = UDim2.fromScale(0.14,0.5)
  iconHolder.AnchorPoint = Vector2.new(0.5,0.5)
  iconHolder.Parent = root

  local title = Instance.new("TextLabel")
  title.BackgroundTransparency = 1
  title.Position = UDim2.fromScale(0.34,0.24)
  title.Size = UDim2.fromScale(0.60,0.25)
  title.Text = "loading Meowl Update - Steal A Brainrot"
  title.TextColor3 = THEME.text
  title.Font = Enum.Font.GothamSemibold
  title.TextScaled = true
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.ZIndex = 7
  title.Parent = root

  local status = Instance.new("TextLabel")
  status.BackgroundTransparency = 1
  status.Position = UDim2.fromScale(0.34,0.56)
  status.Size = UDim2.fromScale(0.60,0.20)
  status.Text = "Initializing..."
  status.TextColor3 = THEME.textDim
  status.Font = Enum.Font.Gotham
  status.TextScaled = true
  status.TextXAlignment = Enum.TextXAlignment.Left
  status.ZIndex = 7
  status.Parent = root

  local bar = Instance.new("Frame")
  bar.BackgroundColor3 = Color3.fromRGB(40,0,0)
  bar.BackgroundTransparency = 0.25
  bar.Size = UDim2.fromScale(0.58,0.12)
  bar.Position = UDim2.fromScale(0.34,0.80)
  bar.ZIndex = 7
  bar.Parent = root
  Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)
  applyRainbowStroke(bar,2)

  local fill = Instance.new("Frame")
  fill.BackgroundColor3 = THEME.accent
  fill.Size = UDim2.fromScale(0,1)
  fill.ZIndex = 8
  fill.Parent = bar
  Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)

  TweenService:Create(root, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundTransparency = THEME.glass_a}):Play()

  local D=3.4
  task.spawn(function()
    local t0=os.clock(); local dots=0
    while os.clock()-t0 < D do
      local t=(os.clock()-t0)/D
      TweenService:Create(fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(t,1)}):Play()
      dots=(dots%3)+1; status.Text=("Initializing"..string.rep(".",dots))
      task.wait(0.2)
    end
  end)

  task.delay(D, function()
    for _,v in ipairs(root:GetDescendants()) do
      if v:IsA("TextLabel") then TweenService:Create(v, TweenInfo.new(0.12), {TextTransparency=1}):Play()
      elseif v:IsA("Frame") then TweenService:Create(v, TweenInfo.new(0.12), {BackgroundTransparency=1}):Play() end
    end
    task.wait(0.14); root:Destroy(); if onDone then onDone() end
  end)
end

-- ===== CMD window
local function makeCMDWindow(z)
  local overlay = Instance.new("Frame")
  overlay.Size = UDim2.fromScale(1,1)
  overlay.BackgroundTransparency = 1
  overlay.ZIndex = z or 6
  overlay.Parent = UI

  local win = Instance.new("Frame")
  win.Size = UDim2.fromScale(0.92, 0.86)
  win.Position = UDim2.fromScale(0.5,0.5)
  win.AnchorPoint = Vector2.new(0.5,0.5)
  win.BackgroundColor3 = THEME.panel
  win.BorderSizePixel = 0
  win.ZIndex = overlay.ZIndex + 1
  win.Parent = overlay
  applyRainbowStroke(win, 1.1)
  Instance.new("UICorner",win).CornerRadius = UDim.new(0,6)

  local titleBar = Instance.new("Frame")
  titleBar.Size = UDim2.new(1,0,0,28)
  titleBar.BackgroundColor3 = Color3.fromRGB(38,10,12)
  titleBar.ZIndex = win.ZIndex + 1
  titleBar.Parent = win
  applyRainbowStroke(titleBar,1)

  local titleText = Instance.new("TextLabel")
  titleText.BackgroundTransparency = 1
  titleText.Size = UDim2.new(1,-12,1,0)
  titleText.Position = UDim2.fromOffset(8,0)
  titleText.Font = Enum.Font.Code
  titleText.TextSize = 16
  titleText.TextXAlignment = Enum.TextXAlignment.Left
  titleText.TextColor3 = THEME.text
  titleText.Text = "Administrator: Command Prompt"
  titleText.ZIndex = titleBar.ZIndex + 1
  titleText.Parent = titleBar

  local pad = Instance.new("Frame")
  pad.Position = UDim2.fromOffset(10,36)
  pad.Size = UDim2.new(1,-20,1,-46)
  pad.BackgroundColor3 = Color3.fromRGB(16,6,8)
  pad.ZIndex = win.ZIndex + 1
  pad.Parent = win
  Instance.new("UICorner",pad).CornerRadius = UDim.new(0,4)
  applyRainbowStroke(pad, 1.0)

  return overlay, pad
end

-- ===== CMD1 (logs) — tu ASCII, 100% ASCII y sin RichText
local function showCMD1(onDone)
  local overlay, pad = makeCMDWindow(6)

  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.fromScale(1,1)
  scroll.BackgroundTransparency = 1
  scroll.ScrollBarThickness = 8
  scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
  scroll.CanvasSize = UDim2.new(0,0,0,0)
  scroll.ZIndex = pad.ZIndex + 1
  scroll.Parent = pad

  local tf = Instance.new("TextLabel")
  tf.BackgroundTransparency = 1
  tf.TextXAlignment = Enum.TextXAlignment.Left
  tf.TextYAlignment = Enum.TextYAlignment.Top
  tf.Font = Enum.Font.Code
  tf.TextSize = 18
  tf.TextColor3 = THEME.text
  tf.TextStrokeColor3 = Color3.new(0,0,0)
  tf.TextStrokeTransparency = 0.55
  tf.RichText = false
  tf.TextWrapped = false
  tf.Size = UDim2.new(1,-8,1,-8)
  tf.Position = UDim2.fromOffset(4,4)
  tf.ZIndex = scroll.ZIndex + 1
  tf.Parent = scroll

  local userAtBottom, initialLock = false, true
  task.spawn(function()
    for _ = 1, 6 do scroll.CanvasPosition = Vector2.new(0, 0); task.wait(0.02) end
    initialLock = false
  end)
  local function nearBottom()
    local maxY = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteSize.Y)
    return scroll.CanvasPosition.Y >= maxY - 4
  end
  scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    userAtBottom = nearBottom()
  end)
  local function push(s)
    tf.Text = (tf.Text=="" and s) or (tf.Text.."\n"..s)
    task.wait()
    if (not initialLock) and userAtBottom then
      local maxY = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteSize.Y)
      scroll.CanvasPosition = Vector2.new(0, maxY)
    end
  end

  local function sanitizeAsciiStrict(str)
      local out = {}
      for i = 1, #str do
          local ch = string.byte(str, i)
          if ch and ch >= 32 and ch <= 126 then
              out[#out+1] = string.char(ch)
          else
              out[#out+1] = " "
          end
      end
      return table.concat(out)
  end

  push("Microsoft Windows [Version 10.0.19045.5088]")
  push("(c) Microsoft Corporation. All rights reserved.\n")

  local ascii_safe = [[
   .m.                                   ,_
         ' ;M;                                ,;m `
           ;M;.           ,      ,           ;SMM;
          ;;Mm;         ,;  ____  ;,         ;SMM;
         ;;;MM;        ; (.MMMMMM.) ;       ,SSMM;;
       ,;;;mMp'        l  ';mmmm;/  j       SSSMM;;
     .;;;;;MM;         .\,.mmSSSm,,/,      ,SSSMM;;;
    ;;;;;;mMM;        .;MMmSSSSSSSmMm;     ;MSSMM;;;;
   ;;;;;;mMSM;     ,_ ;MMmS;;;;;;mmmM;  -,;MMMMMMm;;;;
  ;;;;;;;MMSMM;     \"*;M;( ( '') );m;*"/ ;MMMMMM;;;;;,
 .;;;;;;mMMSMM;      \(@;! _     _ !;@)/ ;MMMMMMMM;;;;;,
 ;;;;;;;MMSSSM;       ;,;.*o*> <*o*.;m; ;MMMMMMMMM;;;;;;,
.;;;;;;;MMSSSMM;     ;Mm;           ;M;,MMMMMMMMMMm;;;;;;.
;;;;;;;mmMSSSMMMM,   ;Mm;,   '-    ,;M;MMMMMMMSMMMMm;;;;;;;
;;;;;;;MMMSSSMMMMMMMm;Mm;;,  ___  ,;SmM;MMMMMMSSMMMM;;;;;;;;
;;'";;;MMMSSSSMMMMMM;MMmS;;,  "  ,;SmMM;MMMMMMSSMMMM;;;;;;;;.
!   ;;;MMMSSSSSMMMMM;MMMmSS;;._.;;SSmMM;MMMMMMSSMMMM;;;;;;;;;
    ;;;;*MSSSSSSMMMP;Mm*"'q;'   `;p*"*M;MMMMMSSSSMMM;;;;;;;;;
    ';;;  ;SS*SSM*M;M;'     `-.        ;;MMMMSSSSSMM;;;;;;;;;,
     ;;;. ;P  `q; qMM.                 ';MMMMSSSSSMp' ';;;;;;;
     ;;;; ',    ; .mm!     \.   `.   /  ;MMM' `qSS'    ';;;;;;
     ';;;       ' mmS';     ;     ,  `. ;'M'   `S       ';;;;;
      `;;.        mS;;`;    ;     ;    ;M,!     '  luk   ';;;;
       ';;       .mS;;, ;   '. o  ;   oMM;                ;;;;
        ';;      MMmS;; `,   ;._.' -_.'MM;                 ;;;
         `;;     MMmS;;; ;   ;      ;  MM;                 ;;;
           `'.   'MMmS;; `;) ',    .' ,M;'                 ;;;
              \    '' ''; ;   ;    ;  ;'                   ;;
               ;        ; `,  ;    ;  ;                   ;;
                        |. ;  ; (. ;  ;      _.-.         ;;
           .-----..__  /   ;  ;   ;' ;\  _.-" .- `.      ;;
         ;' ___      `*;   `; ';  ;  ; ;'  .-'    :      ;
         ;     """*-.   `.  ;  ;  ;  ; ' ,'      /       |
         ',          `-_    (.--',`--'..'      .'        ',
           `-_          `*-._'.\\\;||\\)     ,'
              `"*-._        "*`-ll_ll'l    ,'
                 ,==;*-._           "-.  .'
              _-'    "*-=`*;-._        ;'
            ."            ;'  ;"*-.    `
            ;   ____      ;//'     "-   `,
            `+   .-/                 ".\\;
              `*" /                    "'
  ]]
  push(sanitizeAsciiStrict(ascii_safe).."\n")

  push("C:\\Windows\\system32> echo Meowl Update bootstrap")
  push("Meowl Update bootstrap")
  push("Scanning modules: netui.dll gfxcore.pak auth.meowl")
  push("Linking pipeline: ui->auth->telemetry [READY]")
  push("Driver check: DirectUI OK, Input READY, Net ENABLED")
  push("C:\\Windows\\system32> loading Login panel")

  task.delay(0.9, function()
    for _,v in ipairs(overlay:GetDescendants()) do
      if v:IsA("TextLabel") then TweenService:Create(v, TweenInfo.new(0.12), {TextTransparency=1}):Play()
      elseif v:IsA("TextBox") or v:IsA("Frame") then TweenService:Create(v, TweenInfo.new(0.12), {BackgroundTransparency=1}):Play() end
    end
    task.wait(0.14); overlay:Destroy()
    if onDone then onDone() end
  end)
end

-- ===== ACTION: Auto-Rejoin
local function autoRejoin()
  local placeId = game.PlaceId
  local jobId   = game.JobId
  if G.__MEOWL_REJOINING then return end
  G.__MEOWL_REJOINING = true
  bigToast("Rejoining...", "Returning to your current server")
  task.spawn(function()
    local ok, err
    if typeof(jobId) == "string" and #jobId > 0 then
      ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LP)
      end)
    else
      ok, err = pcall(function()
        TeleportService:Teleport(placeId, LP)
      end)
    end
    if not ok then
      warn("Teleport failed:", err)
      bigToast("Teleport failed", tostring(err or "unknown error"))
      G.__MEOWL_REJOINING = false
    end
  end)
end

-- ===== Brainrot List (multi-select + Select All + GO GHOST ALL)
local function showBrainrotList()
  local rain = startCodeRain()

  local root = Instance.new("Frame")
  root.Size = UDim2.fromScale(0.78,0.7)
  root.Position = UDim2.fromScale(0.5,0.52)
  root.AnchorPoint = Vector2.new(0.5,0.5)
  root.BackgroundColor3 = THEME.panelLite
  root.BackgroundTransparency = THEME.glass_a
  root.ZIndex = 7
  root.Parent = UI
  Instance.new("UICorner",root).CornerRadius = UDim.new(0,16)
  applyRainbowStroke(root,2)

  local padAll = Instance.new("UIPadding", root)
  padAll.PaddingTop=UDim.new(0,12); padAll.PaddingBottom=UDim.new(0,12); padAll.PaddingLeft=UDim.new(0,12); padAll.PaddingRight=UDim.new(0,12)

  local header = Instance.new("Frame")
  header.BackgroundTransparency = 1
  header.Size = UDim2.new(1,0,0,72)
  header.Parent = root
  header.ZIndex=20

  local icon = CircularIconBright("rbxassetid://104395147515167", 30)
  icon.Size = UDim2.fromOffset(56,56)
  icon.Position = UDim2.fromOffset(0,8)
  icon.Parent = header

  local title = Instance.new("TextLabel")
  title.BackgroundTransparency=1
  title.Position=UDim2.fromOffset(66,6)
  title.Size=UDim2.new(1,-520,0,30)
  title.Font=Enum.Font.GothamSemibold
  title.TextSize=24
  title.TextXAlignment=Enum.TextXAlignment.Left
  title.TextColor3=THEME.text
  title.Text="Auto Search Brainrot"
  title.ZIndex=24
  title.Parent=header

  local subtitle = Instance.new("TextLabel")
  subtitle.BackgroundTransparency=1
  subtitle.Position=UDim2.fromOffset(66,36)
  subtitle.Size=UDim2.new(1,-520,0,26)
  subtitle.Font=Enum.Font.Gotham
  subtitle.TextSize=16
  subtitle.TextXAlignment=Enum.TextXAlignment.Left
  subtitle.TextColor3=THEME.textDim
  subtitle.Text="Select brainrots to run the private bot."
  subtitle.ZIndex=24
  subtitle.Parent=header

  -- ---- Controls (layout horizontal + autosize)  **BUGFIX: UDim.new**
  local controls = Instance.new("Frame")
  controls.BackgroundColor3=Color3.fromRGB(40,10,12)
  controls.AutomaticSize = Enum.AutomaticSize.X
  controls.Size=UDim2.new(0,0,0,48)
  controls.AnchorPoint = Vector2.new(1,0)
  controls.Position=UDim2.new(1,-12,0,12)
  controls.BorderSizePixel=0
  controls.ZIndex=50
  controls.Parent=header
  Instance.new("UICorner",controls).CornerRadius=UDim.new(0,12) -- <- FIX
  applyRainbowStroke(controls,1.2)

  local controlsPad = Instance.new("UIPadding", controls)
  controlsPad.PaddingTop=UDim.new(0,6); controlsPad.PaddingBottom=UDim.new(0,6)
  controlsPad.PaddingLeft=UDim.new(0,8); controlsPad.PaddingRight=UDim.new(0,8)

  local row = Instance.new("UIListLayout", controls)
  row.FillDirection = Enum.FillDirection.Horizontal
  row.Padding = UDim.new(0,8)
  row.VerticalAlignment = Enum.VerticalAlignment.Center
  row.SortOrder = Enum.SortOrder.LayoutOrder

  local function mkCtlBtn(txt, w)
    local b = Instance.new("TextButton")
    b.AutoButtonColor=false
    b.Size=UDim2.new(0,w,1,0)
    b.BackgroundColor3=Color3.fromRGB(42,10,12)
    b.Text=txt
    b.Font=Enum.Font.GothamSemibold
    b.TextSize=16
    b.TextColor3=THEME.text
    b.BorderSizePixel=0
    b.ZIndex=60
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    applyRainbowStroke(b,1.1)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(60,16,18)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(42,10,12)}):Play() end)
    b.Parent = controls
    return b
  end

  local btnSelectAll = mkCtlBtn("Select All", 140)
  local btnRun       = mkCtlBtn("RUN SELECTED", 180)
  local btnGoGhost   = mkCtlBtn("GO GHOST ALL", 160)
  btnGoGhost.Visible = false

  local sep = Instance.new("Frame"); sep.Size=UDim2.new(1,0,0,1); sep.Position=UDim2.fromOffset(0,72)
  sep.BackgroundColor3=Color3.fromRGB(80,20,24); sep.BackgroundTransparency=0.25; sep.BorderSizePixel=0; sep.Parent=root; sep.ZIndex=10
  applyRainbowStroke(sep,0.6)

  local list = Instance.new("ScrollingFrame")
  list.BackgroundTransparency = 1
  list.Position = UDim2.fromOffset(0,76)
  list.Size = UDim2.new(1,0,1,-100)
  list.ScrollBarThickness = 6
  list.AutomaticCanvasSize = Enum.AutomaticSize.Y
  list.ZIndex = 8
  list.Parent = root

  local layout = Instance.new("UIListLayout", list)
  layout.FillDirection = Enum.FillDirection.Vertical
  layout.SortOrder = Enum.SortOrder.LayoutOrder
  layout.Padding = UDim.new(0,10)

  local selected, cards = {}, {}

  local function setSelected(card, val)
    selected[card] = val and true or nil
    if card:FindFirstChild("SelGlow") then card.SelGlow.Visible = val and true or false end
    if card:FindFirstChild("Chk") then card.Chk.Text = val and "✓" or "" end
  end

  local function allSelected()
    local total, ok = 0, 0
    for _,c in ipairs(cards) do total += 1; if selected[c] then ok += 1 end end
    return total>0 and ok==total, ok, total
  end

  local function updateTopButtons()
    local all, cnt = allSelected()
    btnRun.Text = "RUN SELECTED ("..cnt..")"
    btnGoGhost.Visible = all
  end

  local function makeCard(titleText, imageId)
    local card = Instance.new("Frame")
    card.Name = "Card"
    card.BackgroundColor3 = THEME.panel
    card.BackgroundTransparency = 0.04
    card.Size = UDim2.new(1,0,0,170)
    card.ZIndex = 9
    card.Parent = list
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)
    applyRainbowStroke(card,1.2)
    table.insert(cards, card)

    local pad = Instance.new("UIPadding", card)
    pad.PaddingTop=UDim.new(0,12); pad.PaddingLeft=UDim.new(0,12); pad.PaddingRight=UDim.new(0,12); pad.PaddingBottom=UDim.new(0,12)

    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamSemibold
    t.TextSize = 20
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextColor3 = THEME.text
    t.Text = titleText
    t.Size = UDim2.new(1,-180,0,26)
    t.Position = UDim2.fromOffset(0,0)
    t.ZIndex = 10
    t.Parent = card

    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.Image = imageId
    img.ScaleType = Enum.ScaleType.Fit
    img.Size = UDim2.fromOffset(160, 110)
    img.Position = UDim2.fromOffset(0, 34)
    img.ZIndex = 10
    img.Parent = card
    applyRainbowStroke(img,1)

    local selGlow = Instance.new("Frame")
    selGlow.Name = "SelGlow"
    selGlow.BackgroundColor3 = Color3.fromRGB(60,20,24)
    selGlow.BackgroundTransparency = 0.7
    selGlow.BorderSizePixel = 0
    selGlow.Visible = false
    selGlow.ZIndex = 11
    selGlow.Parent = card
    selGlow.Size = UDim2.fromScale(1,1)
    Instance.new("UICorner", selGlow).CornerRadius = UDim.new(0,12)
    applyRainbowStroke(selGlow,2)

    local chk = Instance.new("TextLabel")
    chk.Name = "Chk"
    chk.BackgroundColor3 = Color3.fromRGB(42,10,12)
    chk.Text = ""
    chk.Font = Enum.Font.GothamBold
    chk.TextColor3 = THEME.text
    chk.TextSize = 20
    chk.Size = UDim2.fromOffset(34,34)
    chk.Position = UDim2.new(1,-34,0,0)
    chk.ZIndex = 12
    chk.Parent = card
    Instance.new("UICorner", chk).CornerRadius = UDim.new(1,0)
    applyRainbowStroke(chk,1)

    local btn = Instance.new("TextButton")
    btn.Text = "RUN PRIVATED BOT"
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.TextColor3 = THEME.text
    btn.BackgroundColor3 = Color3.fromRGB(42,10,12)
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 220, 0, 44)
    btn.Position = UDim2.fromOffset(180, 80)
    btn.ZIndex = 10
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    applyRainbowStroke(btn,1.1)

    btn.MouseEnter:Connect(function()
      TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(60,16,18)}):Play()
    end)
    btn.MouseLeave:Connect(function()
      TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(42,10,12)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
      bigToast("Launching "..titleText, "Rejoining current server…")
      autoRejoin()
    end)

    local function toggle()
      setSelected(card, not selected[card])
      updateTopButtons()
    end
    card.InputBegan:Connect(function(i)
      if i.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
    end)
    chk.InputBegan:Connect(function(i)
      if i.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
    end)

    return card
  end

  -- Cards originales + extra
  makeCard("Chipso And Queso",   "rbxassetid://127097195323696")
  makeCard("Extinct La Grande",  "rbxassetid://106504231225062")
  makeCard("KetupatKepat",       "rbxassetid://110731297126399")
  makeCard("Evilodon",           "rbxassetid://122929824308637")
  makeCard("La Grande Combinacion",   "rbxassetid://70515189923740")
  makeCard("La Secret Combinacion",   "rbxassetid://76434949238019")
  makeCard("Chicleteira Bicicleteira","rbxassetid://98357270095692")
  makeCard("Las Sis",                 "rbxassetid://103638922490554")

  updateTopButtons()

  -- Select All (toggle)
  btnSelectAll.MouseButton1Click:Connect(function()
    local all = allSelected()
    for _,c in ipairs(cards) do setSelected(c, not all) end
    updateTopButtons()
    bigToast(not all and "All selected" or "Selection cleared", not all and "You can now GO GHOST ALL" or "")
  end)

  -- GO GHOST ALL
  btnGoGhost.MouseButton1Click:Connect(function()
    bigToast("GO GHOST ALL", "Launching all selected entries…")
    autoRejoin()
  end)

  -- RUN SELECTED
  btnRun.MouseButton1Click:Connect(function()
    local _, cnt = allSelected()
    if cnt == 0 then
      bigToast("No selection", "Pick at least one brainrot.")
      return
    end
    bigToast("Launching "..tostring(cnt).." selected", "Rejoining current server…")
    autoRejoin()
  end)
end

-- ===== LOGIN
local function showLogin()
  local rain = startCodeRain()

  local root = Instance.new("Frame")
  root.Size = UDim2.fromScale(0.6,0.6)
  root.Position = UDim2.fromScale(0.5,0.52)
  root.AnchorPoint = Vector2.new(0.5,0.5)
  root.BackgroundColor3 = THEME.panelLite
  root.BackgroundTransparency = THEME.glass_a
  root.ZIndex = 7
  root.Parent = UI
  Instance.new("UICorner",root).CornerRadius = UDim.new(0,18)
  applyRainbowStroke(root,2)

  local padAll = Instance.new("UIPadding", root)
  padAll.PaddingTop=UDim.new(0,16); padAll.PaddingBottom=UDim.new(0,16); padAll.PaddingLeft=UDim.new(0,16); padAll.PaddingRight=UDim.new(0,16)

  local header = Instance.new("Frame"); header.BackgroundTransparency=1; header.Size=UDim2.new(1,0,0,80); header.Parent=root; header.ZIndex=8
  local appIcon = CircularIconBright("rbxassetid://104395147515167", 10)
  appIcon.Size = UDim2.fromOffset(60,60); appIcon.Position = UDim2.fromOffset(0,10); appIcon.Parent = header

  local tTitle = Instance.new("TextLabel")
  tTitle.BackgroundTransparency = 1; tTitle.Position = UDim2.fromOffset(70,8)
  tTitle.Size = UDim2.new(1,-220,0,34); tTitle.Font = Enum.Font.GothamSemibold; tTitle.TextSize=26
  tTitle.TextXAlignment = Enum.TextXAlignment.Left; tTitle.TextColor3 = THEME.text
  tTitle.Text = "Miranda Meowl Updated"; tTitle.ZIndex=8; tTitle.Parent=header

  local tInfo = Instance.new("TextLabel")
  tInfo.BackgroundTransparency=1; tInfo.Position=UDim2.fromOffset(70,42)
  tInfo.Size = UDim2.new(1,-220,0,28); tInfo.Font=Enum.Font.Gotham; tInfo.TextSize=16
  tInfo.TextXAlignment=Enum.TextXAlignment.Left; tInfo.TextColor3=THEME.textDim; tInfo.ZIndex=8; tInfo.Parent=header

  local head = CircularIconBright("rbxassetid://0", 10)
  head.Size = UDim2.fromOffset(60,60); head.Position = UDim2.new(1,-60,0,10); head.AnchorPoint=Vector2.new(1,0)
  head.Parent=header
  task.spawn(function()
    local thumb, ok = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    if ok then head:FindFirstChildOfClass("ImageLabel").Image = thumb end
    local display = (#LP.DisplayName>0 and LP.DisplayName) or LP.Name
    tInfo.Text = string.format("%s  •  @%s  •  Status: Active  •  %d days", display, LP.Name, LP.AccountAge)
  end)

  local sep = Instance.new("Frame"); sep.Size=UDim2.new(1,0,0,1); sep.Position=UDim2.fromOffset(0,80)
  sep.BackgroundColor3=Color3.fromRGB(90,20,26); sep.BackgroundTransparency=0.25; sep.BorderSizePixel=0; sep.Parent=root; sep.ZIndex=8
  applyRainbowStroke(sep,0.6)

  -- Body
  local body = Instance.new("Frame"); body.BackgroundTransparency=1; body.Size=UDim2.new(1,0,1,-92); body.Position=UDim2.fromOffset(0,92); body.Parent=root; body.ZIndex=8

  local lbl = Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,0,0,26)
  lbl.Font=Enum.Font.Gotham; lbl.TextSize=18; lbl.TextXAlignment=Enum.TextXAlignment.Left
  lbl.TextColor3=THEME.text; lbl.Text="Enter key to continue:"; lbl.ZIndex=9; lbl.Parent=body

  local group = Instance.new("Frame"); group.Size=UDim2.new(1,0,0,46); group.Position=UDim2.fromOffset(0,30)
  group.BackgroundColor3 = Color3.fromRGB(40,10,12); group.BorderSizePixel=0; group.ZIndex=9; group.Parent=body
  Instance.new("UICorner",group).CornerRadius = UDim.new(0,10); applyRainbowStroke(group,1.2)

  local keyBox = Instance.new("TextBox")
  keyBox.Size = UDim2.new(1,-54,1,-8); keyBox.Position=UDim2.fromOffset(8,4)
  keyBox.BackgroundTransparency = 1
  keyBox.Text = ""; keyBox.PlaceholderText="your-key-here"
  keyBox.TextColor3=THEME.text; keyBox.PlaceholderColor3=Color3.fromRGB(200,130,140)
  keyBox.Font=Enum.Font.Gotham; keyBox.TextSize=18; keyBox.BorderSizePixel=0; keyBox.ZIndex=10; keyBox.Parent=group
  keyBox.ClearTextOnFocus = false

  -- Máscara con bullets
  local maskLabel = Instance.new("TextLabel")
  maskLabel.BackgroundTransparency=1
  maskLabel.Size=keyBox.Size
  maskLabel.Position=keyBox.Position
  maskLabel.Font=Enum.Font.Gotham
  maskLabel.TextSize=18
  maskLabel.TextColor3=THEME.text
  maskLabel.TextXAlignment = Enum.TextXAlignment.Left
  maskLabel.ZIndex=11
  maskLabel.Parent=group
  maskLabel.Text = ""
  local masked = true
  local function refreshMask()
    keyBox.TextTransparency = masked and 1 or 0
    maskLabel.Visible = masked
    if masked then maskLabel.Text = string.rep("•", utf8.len(keyBox.Text) or #keyBox.Text) end
  end
  keyBox:GetPropertyChangedSignal("Text"):Connect(refreshMask)
  refreshMask()

  local eye = Instance.new("TextButton")
  eye.Text = "👁"; eye.Font = Enum.Font.Gotham; eye.TextSize = 18; eye.TextColor3 = THEME.text
  eye.BackgroundTransparency = 1; eye.Size = UDim2.fromOffset(40,40); eye.Position = UDim2.new(1,-44,0,3); eye.ZIndex=12; eye.Parent = group
  eye.MouseButton1Click:Connect(function()
    masked = not masked
    refreshMask()
    bigToast(masked and "Hidden key" or "Showing key", "")
  end)

  local feedback = Instance.new("TextLabel"); feedback.BackgroundTransparency=1; feedback.Size=UDim2.new(1,0,0,20); feedback.Position=UDim2.fromOffset(0,80)
  feedback.Font=Enum.Font.Gotham; feedback.TextSize=14; feedback.TextXAlignment=Enum.TextXAlignment.Left
  feedback.TextColor3=Color3.fromRGB(255,150,150); feedback.Text=""; feedback.ZIndex=9; feedback.Parent=body

  local btnRow = Instance.new("Frame"); btnRow.BackgroundTransparency=1; btnRow.Size=UDim2.new(1,0,0,46); btnRow.Position=UDim2.fromOffset(0,106); btnRow.ZIndex=9; btnRow.Parent=body
  local function mkBtn(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.5,-6,1,0); b.BackgroundColor3 = Color3.fromRGB(42,10,12)
    b.AutoButtonColor = false
    b.Text = text; b.Font=Enum.Font.GothamSemibold; b.TextSize=18; b.TextColor3=THEME.text; b.BorderSizePixel=0; b.ZIndex=9
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,12); applyRainbowStroke(b,1.2)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(60,16,18)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(42,10,12)}):Play() end)
    return b
  end

  local bGet = mkBtn("Get Key"); bGet.Position=UDim2.fromScale(0,0); bGet.Parent=btnRow
  local bSub = mkBtn("Continue");  bSub.Position=UDim2.fromScale(0.5,0); bSub.Parent=btnRow

  bGet.MouseButton1Click:Connect(function()
    local url = GET_KEY_URL
    pcall(function() if setclipboard then setclipboard(url) end end)
    bigToast("Link copied!", url)
  end)

  local function openBrainrot()
    if rain then rain:Destroy() end
    root:Destroy()
    -- Guardar errores de UI y mostrarlos
    local ok, err = pcall(function()
      showBrainrotList()
    end)
    if not ok then
      warn("UI error:", err)
      bigToast("UI Error", tostring(err))
    end
  end

  local function trySubmit()
    local key = keyBox.Text or ""
    if key ~= VALID_KEY then feedback.Text = "Invalid key. Get the latest key and try again."; return end
    feedback.Text = ""
    bigToast("Key accepted", "Loading Auto Search Brainrot…")
    task.delay(0.25, openBrainrot)
  end

  bSub.MouseButton1Click:Connect(trySubmit)
  keyBox.FocusLost:Connect(function(enter) if enter then trySubmit() end end)
end

-- ===== Orquestación
showLoader(function()
  showCMD1(function()
    showLogin()
  end)
end)
