
local function kmake(rows)
  local kb = {}
  kb.keyboard = rows
  kb.resize_keyboard = true
  kb.selective = true
  return kb
end
local function kmakerow(texts)
  local row = {}
  for i=1 , #texts do
    row[i] = {text=URL.escape(texts[i])}
  end
  return row
end
local function save_file(name, text)
  local file = io.open("data/"..name, "w")
  file:write(text)
  file:flush()
  file:close()
end
local function start_menu()
  local rw1_texts = {'پنل مدیریت'}
  local rw2_texts = {'درباره ما'}
  local rows ={kmakerow(rw1_texts),kmakerow(rw2_texts)}
  return kmake(rows)
end
local function panel_menu()
  local rw1_texts = {'تبدیل متن به فایل',}
  local rw2_texts = {'راه اندازی مجدد',}
  local rw3_texts = {'منو اصلی'}
  local rows ={kmakerow(rw1_texts),kmakerow(rw2_texts),kmakerow(rw3_texts)}
  return kmake(rows)
end
local function action(msg)
  if msg.text == '/start' and msg.chat.id == bot_sudo then
    local start = "`سلام ادمین عزیز` 🙂🌹\n "..(msg.from.first_name or '*No name*').." \n _برای انجام امور خود روی دکمه ی_ \n پنل مدیریت \n `کلیک کنید با تشکر` "
    api.sendMessage(msg.chat.id, start, true,msg.message_id, true,start_menu())
    return
  elseif msg.text == 'درباره ما' then
    local pms = [[
    `ربات شخصی ورژن 1`

    _سازنده_ : [Ali](https://t.me/ali_timsar)
    `سازنده` : [Artin](https://t.me/artinialized)
    ]]
    local keyboard = {}
    keyboard.inline_keyboard = {
      {
        {text = "سازنده" , url = 'https://t.me/ali_timsar'},
        {text = "سازنذه" , url = 'https://t.me/artinialized'},
      }
    }
    api.sendMessage(msg.chat.id, pms, true,msg.message_id, true,keyboard)
    return
  elseif msg.text == 'پنل مدیریت' and msg.chat.id == bot_sudo then
    local pmm = '`ادمین عزیز یکی از گزینه های زیر رو انتخاب کن`😊'
    api.sendMessage(msg.chat.id, pmm, true,msg.message_id, true,panel_menu())
    return
  elseif msg.text == 'تبدیل متن به فایل' and msg.chat.id == bot_sudo then
    local msgss = [[
    `ادمین عزیز ❤️😊برای تبدیل متن به فایل و فرمت های مورد نظرت از الگوی زیر استفاده کن`
    /create test.text salam
    _تمامی فرمت ها ساپورت میشوند_
    `نکته ی مهم`
    _متن شما باید انگلیسی باشد_
    ]]
    api.sendReply(msg, msgss, true)
    return
  elseif msg.text == 'منو اصلی' and msg.chat.id == bot_sudo then
    api.sendMessage(msg.chat.id, '_منوی اصلی عبارت است از :_', true,msg.message_id, true,start_menu())
    return
  elseif msg.text == 'راه اندازی مجدد' and msg.chat.id == bot_sudo then
    local msgs = "_راه اندازی مجدد توسط_ \n "..msg.from.first_name.." \n `با موفقیت انجام شد!` "
    local keyboard = {}
    keyboard.inline_keyboard = {
      {
        {text = "|"..(msg.from.username or '*No username*').."|\n|"..msg.from.id.."|" , url = 'https://t.me/'..msg.from.username..''},
      }
    }
    bot_init(true)
    api.sendMessage(msg.chat.id, msgs, true,msg.message_id, true,keyboard)
    return
  elseif msg.text:match("^[/!#](create) ([^%s]+) (.+)$") and msg.chat.id == bot_sudo then
    local matches = { string.match(msg.text, "^[/!](create) ([^%s]+) (.+)$") }
    local name = matches[2]
    local text = matches[3]
    local saving = save_file(name, text)
    local sending = sendDocument(msg.chat.id,"data/"..name)
    local text = sendMessage(msg.chat.id,"_!فایل_ \n _["..matches[2].."]_ \n`ساخته شد✅`",true,false,true)
  end
end
return {
  action = action,
  iaction = iaction
}
