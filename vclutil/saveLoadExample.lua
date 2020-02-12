local VCL=require "qvcl"

local path = getScriptPath().."\\config.cfg"

local stopped
function OnStop()
    if mainForm then mainForm:Release(); mainForm = nil; VCL = nil end
    message("Робот отключен пользователем")
    stopped = true
end
--================================== Параметры =========================================

ACCOUNT                 = "";          -- Торговый счет
CLIENT_CODE             = "";          -- Код клиента
SEC_CODE                = "";          -- Код бумаги
CLASS_CODE              = "";          -- Код класса


--================================== Функции =================================
-- Чтение таблицы из файла-- и все!
function LoadFromFile ( directory )
    local st, err = os.rename ( directory, directory )  --пробуем переименовать файл, если файла нет, то вернет nil и текст ошибки
    if st then  --нашли файл с настройками
       local func, err = loadfile ( path )
       if func then
          func ()
          ACCOUNT = config.ACCOUNT
          CLIENT_CODE = config.CLIENT_CODE
          SEC_CODE = config.SEC_CODE
          CLASS_CODE = config.CLASS_CODE
          message("Настройки загружены из директории:\n"..path)
       else
          message ( "Настройки не загружены:\n"..err, 3 )  --если файл config.cfg не содержит в таблице данных
       end
    else
       message ( "Файл настроек не найден:\n"..err, 3 )  --нет такого файла (не удалось переименовать)
    end
end
--
function Log (ad,...)
    local str="";
    for i=1,arg.n do
        if arg[i] ~= nil then str=str..tostring(arg[i]) end
    end
end

function Handler(Sender,...)
local SN=Sender.Name  --получает имя поля (EditButton, ComboBox, FloatSpinEdit и т.д)
   if SN == "Button_exit" then OnFormClose()
   elseif SN == "Button_save" then SaveToFile("config", path)    Log(0,"Значения из таблицы сохранены в файл  ", path)
   elseif SN == "Button_load" then
        LoadFromFile ( path )
        Edit_account.Text = ACCOUNT
        Edit_client_code.Text = CLIENT_CODE
        Edit_sec_code.Text = SEC_CODE
        ComboBox_class_code.Text = CLASS_CODE
   elseif SN == "Edit_account" then
      ACCOUNT = Edit_account.Text
   elseif SN == "Edit_client_code" then
      CLIENT_CODE = Edit_client_code.Text
   elseif SN == "Edit_sec_code" then
      SEC_CODE = Edit_sec_code.Text
   elseif SN == "ComboBox_class_code" then
      CLASS_CODE = ComboBox_class_code.Text
   end
end

--================================== Интерфейс =================================

mainForm = VCL.Form({Name = "mainForm", Height = 150, Width = 600, Caption = "Робот",
Position = "", OnClose = OnStop})--тут просто вызываем OnStop()

Button_save = VCL.Button(mainForm, {Name = "Button_save",  top=100, left=130, Caption="Сохранить", Width=80, Enabled = true, OnClick = Handler, ShowHint=true, Hint="Запись значений таблицы в файл"})
Button_load = VCL.Button(mainForm, {Name = "Button_load",  top=100, left=350, Caption="Загрузить", Width=80, Enabled = true, OnClick = Handler, ShowHint=true, Hint="Загрузка значений в таблицу из файла"})
-- Выбор торгового счета
Label_account = VCL.Label(mainForm, {    Name = "Label_account",
                                        top=10, left=10,
                                        Caption="Торговый счет",
                                        ShowHint=true,
                                        Hint=" Элемент Label"})

Edit_account = VCL.Edit(mainForm,  {    Name = "Edit_account",
                                        Text = ACCOUNT,
                                        top=10, left=110, Width=90,
                                        ShowHint=true, Hint="Элемент EditButton", OnExit = Handler })
-- Выбор кода клиента
Label_client_code = VCL.Label(mainForm, {    Name = "Label_client_code",
                                            Caption="Код клиента",
                                            top=10, left=240,
                                            ShowHint=true, Hint=" Элемент Label"})
Edit_client_code = VCL.Edit(mainForm, {    Name = "Edit_client_code",
                                        Text = CLIENT_CODE,
                                        top=10, left=330, Width=90,
                                        ShowHint=true, Hint="Элемент EditButton", OnExit = Handler })
-- Выбор кода бумаги
Label_sec_code = VCL.Label(mainForm, {    Name = "Label_sec_code",
                                        Caption="Код бумаги",
                                        top=40, left=10,
                                        ShowHint=true, Hint=" Элемент Label" })
Edit_sec_code = VCL.Edit(mainForm, {    Name = "Edit_sec_code",
                                        Text = SEC_CODE,
                                        top=40, left=110, Width=90,
                                        ShowHint=true, Hint="Элемент EditButton", OnExit = Handler }) 
-- Выбор кода класса
Label_class_code = VCL.Label(mainForm, {Name = "Label_class_code",
                                        Caption="Код класса",
                                        top=40, left=240,
                                        ShowHint=true, Hint=" Элемент Label" })
local text = (CLASS_CODE ~= "" and CLASS_CODE) or "Выбрать..."
ComboBox_class_code = VCL.ComboBox(mainForm, {    Name = "ComboBox_class_code",
                                                Text = text,
                                                top=40, left=330, Width=110,
                                                ShowHint=true, Hint="Элемент ComboBox", OnExit = Handler, })
for _,i in ipairs({"SPBFUT","SPBOPT","TQBR"}) do    ComboBox_class_code.Items:Add(i) end

mainForm:Show()
-- Конец скрипта интерфейса
--=================================== Основной блок скрипта =================================
-- Сохранение таблицы или массива в файл без вложенных таблиц, тип string or number для ключей и значений
function SaveToFile (table_name, path)
  os.remove ( path )  --удаляем файл перед созданием нового
  local t = {ACCOUNT = ACCOUNT, CLIENT_CODE = CLIENT_CODE, SEC_CODE = SEC_CODE, CLASS_CODE = CLASS_CODE}
  local f, err = io.open (path, "w")
  if not f then
     return nil, err
  end
  local res = {}
  f:write ( table_name.." =\n{\n" )
  for k, v in pairs ( t ) do
    k = (type(k) == "number" and '['..k..']') or k
    v = (type(v) == "string" and '"'..v..'"') or v
    res[#res + 1] = "\t"..k.."="..v
  end
  f:write ( table.concat ( res, ",\n" ) )
  f:write ("\n}"); f:flush (); f:close ()
  return true
end
--
function main()
    while not stopped do
       sleep (1)
    end
    sleep(300)
end